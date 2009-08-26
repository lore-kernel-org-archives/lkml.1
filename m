Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZHZBO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZHZBO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbZHZBOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:14:55 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:56024 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbZHZBOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:14:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 25 Aug 2009 18:14:55 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Will Brown <dr.hfuhruhurr@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Epoll frequently fails to notify connects at connect
 bursts
In-Reply-To: <8a1bd2320908251748u324ae5e6g7015069180253db3@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0908251812450.18518@makko.or.mcafeemobile.com>
References: <8a1bd2320908251748u324ae5e6g7015069180253db3@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Will Brown wrote:

> PLEASE CC: ME ON ANY REPLIES, thank you.
> 
> *** 1. Epoll frequently fails to notify connects at connect bursts
> 
> *** 2. Sometimes, when several connects come in quickly, epoll
> establishes tcp connections (according to 'netstat') but then fails to
> notify the application by returning from epoll_wait(). In those cases
> a subsequent connection or an EPOLLIN or EPOLLOUT event can cause a
> return from epoll_wait(), which then causes the previously ignored
> connection to be reported. But then the more recent event is not
> notified, the whole sequence lags and everything gets out of whack.
> The problems can easily be reproduced on my Ubuntu machine which runs
> a kernel version 2.6.28 using supplied test program. I also have a
> Ubuntu hosted in VMWare running a 2.6.27 version kernel, which appears
> to NOT have the same problem.

Multiple quasi-simultaneous events for the same fd are merged. This is why 
on POLLIN on accepting sockets you want to do something like:

	while ((afd = accept(sfd, ...)) != -1)
		add_client(afd);



- Davide


