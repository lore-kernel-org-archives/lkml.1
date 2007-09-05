Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbXIEAIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbXIEAIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 20:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbXIEAId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 20:08:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:34042 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754023AbXIEAIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 20:08:32 -0400
Cc: rdunlap@xenotime.net, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, drepper@redhat.com, stable@kernel.org,
       hch@lst.de, jengelh@computergmbh.de, corbet@lwn.net,
       akpm@linux-foundation.org
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 05 Sep 2007 02:08:31 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0709041541500.7326@alien.or.mcafeemobile.com>
Message-ID: <20070905000831.313400@gmx.net>
MIME-Version: 1.0
References: <20070825064114.107820@gmx.net>
 <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
 <46DD116C.4040301@gmx.net>
 <20070904011800.762523a4.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
 <20070904204932.208520@gmx.net>
 <Pine.LNX.4.64.0709041541500.7326@alien.or.mcafeemobile.com>
Subject: Re: [PATCH] Revised timerfd() interface
To: Davide Libenzi <davidel@xmailserver.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/F9bZ+qpTFJcLQCHL7SCSoz1OLCRS3/E6PlrWcDt
 WEdVq0s3s5Uev5tSpPlBN53QmDoq72hZK1Cw== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: TcrufllOMmA6fc3zEGBnIfo5MjQ1N92q
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

> > As I think about this more, I see more problems with
> > your argument.  timerfd needs the ability to get and 
> > get-while-setting just as much as the earlier APIs.
> > Consider a library that creates a timerfd file descriptor that
> > is handed off to an application: that library may want
> > to modify the timer settings without having to create a
> > new file descriptor (the app mey not be able to be told about
> > the new fd).  Your argument just doesn't hold, AFAICS.
> 
> Such hypotethical library, in case it really wanted to offer such 
> functionality, could simply return an handle instead of the raw fd, and 
> take care of all that stuff in userspace.

Did I miss something?  Is it not the case that as soon as the
library returns a handle, rather than an fd, then the whole
advantage of timerfd() (being able to select/poll/epoll on 
the timer as well as other fds) is lost?  

> Again, mimicking POSIX APIs doesn't always take you in the right place.

POSIX may goof in places, but in general it is the result of
many smart people thinking about how to design/standardize APIs.
So the onus is on us to explain why they got this point wrong.
And it is not merely POSIX that did things things in the
way I've described: so did the earlier setitimer()/getitimer().

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

