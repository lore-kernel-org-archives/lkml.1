Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZLSSHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZLSSHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 13:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZLSSHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 13:07:12 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46359 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZLSSHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 13:07:11 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 19 Dec 2009 10:07:05 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Nikolai ZHUBR <zhubr@mail.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: epoll'ing tcp sockets for reading
In-Reply-To: <1257480306.20091219150206@mail.ru>
Message-ID: <alpine.DEB.2.00.0912190953160.4482@makko.or.mcafeemobile.com>
References: <1257480306.20091219150206@mail.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Dec 2009, Nikolai ZHUBR wrote:

> Hello people, I have a question about epoll'ing tcp sockets.
> 
> Is it possible (with epoll or some other good method) to get userspace
> notified not only of the fact that some data has become available
> for the socket, but also of the respective _size_ available for
> reading connected with this exact event?
> 
> Yes, read'ing until EAGAIN or using FIONREAD would provide this
> sort of information, but there is a problem. In case of subsequent
> continuous data arrival, an application could get stuck reading
> data for one socket infinitely (after epoll return, just before
> the next epoll), unless it implements some kind of artifical safety
> measures.

It is up to your application to handle data arrival correctly, according 
to the latency/throughput constraints of your software.
The "read until EAGAIN" that is cited inside the epoll man pages, does not 
mean that you have to exhaust the data in one single event processing loop.
After you have read and processed "enough data" (where enough depends on 
the nature and constraints of your software), you can just drop that fd 
into an "hot list" and pick the timeout for your next epoll_wait() 
depending on the fact that such list is empty or not (you'd pick zero if 
not empty). Proper handling of new and hot events will ensure that no 
connections will be starving for service.



- Davide


