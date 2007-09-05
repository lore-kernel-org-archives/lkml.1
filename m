Return-Path: <linux-kernel-owner+w=401wt.eu-S932494AbXIEQOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbXIEQOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbXIEQOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:14:33 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53964 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbXIEQOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:14:32 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 5 Sep 2007 09:14:12 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: rdunlap@xenotime.net, tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, stable@kernel.org, hch@lst.de,
       jengelh@computergmbh.de, corbet@lwn.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revised timerfd() interface
In-Reply-To: <20070905000831.313400@gmx.net>
Message-ID: <Pine.LNX.4.64.0709050901420.11426@alien.or.mcafeemobile.com>
References: <20070825064114.107820@gmx.net> <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
 <46DD116C.4040301@gmx.net> <20070904011800.762523a4.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
 <20070904204932.208520@gmx.net> <Pine.LNX.4.64.0709041541500.7326@alien.or.mcafeemobile.com>
 <20070905000831.313400@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007, Michael Kerrisk wrote:

> Davide,

A Michael!


> > > As I think about this more, I see more problems with
> > > your argument.  timerfd needs the ability to get and 
> > > get-while-setting just as much as the earlier APIs.
> > > Consider a library that creates a timerfd file descriptor that
> > > is handed off to an application: that library may want
> > > to modify the timer settings without having to create a
> > > new file descriptor (the app mey not be able to be told about
> > > the new fd).  Your argument just doesn't hold, AFAICS.
> > 
> > Such hypotethical library, in case it really wanted to offer such 
> > functionality, could simply return an handle instead of the raw fd, and 
> > take care of all that stuff in userspace.
> 
> Did I miss something?  Is it not the case that as soon as the
> library returns a handle, rather than an fd, then the whole
> advantage of timerfd() (being able to select/poll/epoll on 
> the timer as well as other fds) is lost?  

Why? The handle would simply be a little struct where the timerfd fd is 
stored, and a XXX_getfd() would return it.
So my point is, I doubt such functionalities are really needed, and I also 
argue that the kernel is the best place for such wrapper code to go.



- Davide


