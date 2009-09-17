Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZIQAaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZIQAaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZIQAaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:30:18 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:36390 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbZIQAaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:30:17 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 16 Sep 2009 17:30:18 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gilad Benjamini <gilad@altornetworks.com>
cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: epoll and closed file descriptors
In-Reply-To: <024601ca372d$09ad9fb0$1d08df10$@com>
Message-ID: <alpine.DEB.2.00.0909161726090.3124@makko.or.mcafeemobile.com>
References: <023c01ca3724$9f90fcb0$deb2f610$@com> <alpine.DEB.2.00.0909161656150.3124@makko.or.mcafeemobile.com> <024601ca372d$09ad9fb0$1d08df10$@com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Gilad Benjamini wrote:

> I would, but epoll is preventing me from doing so.
> Early in sys_epoll_ctl there are these lines
> 
>   file = fget(epfd);
>   if (!file)
>     goto error_return;
> 
> Leaving me in a kind of dead lock

The 'epfd' in there, is the _epoll fd_, which, if fget() fails, means you 
close it.
You see likely failing the 'tfile = fget(fd)' (of course, you closed it), 
so if someone else keeps the socket open and you have no chance in telling 
it to drop it (really?), you need to remove the socket from the set before 
closing it.



- Davide


