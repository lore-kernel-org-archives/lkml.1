Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZLSWcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZLSWcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 17:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZLSWcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 17:32:05 -0500
Received: from mx48.mail.ru ([94.100.176.62]:59297 "EHLO mx48.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZLSWcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 17:32:04 -0500
X-Greylist: delayed 38239 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Dec 2009 17:32:04 EST
Date: Sun, 20 Dec 2009 01:38:54 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <203216314.20091220013854@mail.ru>
To: Davide Libenzi <davidel@xmailserver.org>
CC: linux-kernel@vger.kernel.org
Subject: Re[2]: epoll'ing tcp sockets for reading
In-reply-To: <alpine.DEB.2.00.0912190953160.4482@makko.or.mcafeemobile.com>
References: <1257480306.20091219150206@mail.ru>
 <alpine.DEB.2.00.0912190953160.4482@makko.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saturday, December 19, 2009, 9:07:05 PM, Davide Libenzi wrote:
> On Sat, 19 Dec 2009, Nikolai ZHUBR wrote:

>> Hello people, I have a question about epoll'ing tcp sockets.
>> 
>> Is it possible (with epoll or some other good method) to get userspace
>> notified not only of the fact that some data has become available
>> for the socket, but also of the respective _size_ available for
>> reading connected with this exact event?
>> 
>> Yes, read'ing until EAGAIN or using FIONREAD would provide this
>> sort of information, but there is a problem. In case of subsequent
>> continuous data arrival, an application could get stuck reading
>> data for one socket infinitely (after epoll return, just before
>> the next epoll), unless it implements some kind of artifical safety
>> measures.

> It is up to your application to handle data arrival correctly, according 
> to the latency/throughput constraints of your software.
> The "read until EAGAIN" that is cited inside the epoll man pages, does not 
> mean that you have to exhaust the data in one single event processing loop.
> After you have read and processed "enough data" (where enough depends on 
> the nature and constraints of your software), you can just drop that fd 
> into an "hot list" and pick the timeout for your next epoll_wait() 
> depending on the fact that such list is empty or not (you'd pick zero if 
> not empty). Proper handling of new and hot events will ensure that no 
> connections will be starving for service.

Well, no doubt, terrible starvation can be avoided this way, ok.
However doesn't this look like userspace code is forced to make decisions
(when to pause reading new data and proceed to other sockets etc.) based on
some rather abstract/imprecise/overcomplicated assumptions and/or with
the help of additional syscalls, while a simple and reasonable hint for
such a decision being wasted somewhere on the way from kernelspace to
userspace?

(Not that I had something better really; I'm just trying to find the best
approach and its limitations)

Thank you!

Nikolai ZHUBR

> - Davide


