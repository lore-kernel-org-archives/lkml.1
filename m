Return-Path: <linux-kernel-owner+w=401wt.eu-S1761461AbXGLWmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461AbXGLWmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 18:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbXGLWlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 18:41:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38325 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756099AbXGLWlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 18:41:52 -0400
Date: Fri, 13 Jul 2007 00:41:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 01/61] Rules on how to use sysfs in userspace programs
Message-ID: <20070712224114.GE3374@elf.ucw.cz>
References: <20070711233021.GA5253@kroah.com> <11841967403365-git-send-email-gregkh@suse.de> <20070712084846.GA1882@elf.ucw.cz> <20070712221402.GA30182@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712221402.GA30182@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +The kernel exported sysfs exports internal kernel implementation-details
> > > +and depends on internal kernel structures and layout. It is agreed upon
> > > +by the kernel developers that the Linux kernel does not provide a stable
> > > +internal API. As sysfs is a direct export of kernel internal
> > > +structures, the sysfs interface can not provide a stable interface eighter,
> > > +it may always change along with internal kernel changes.
> > 
> > It is also agreed upon by the kernel developers that the Linux kernel
> > does have a stable user<->kernel API... so we have a small problem
> > here. 
> 
> I agree, that is why we have described the proper ways to use /sys in a
> manner that is acceptable to future changes in it.
> 
> > Maybe solution is to declare /sys unstable, but... perhaps /sys can
> > stop mirroring internal structures? I do not think we should codify
> > our failure to keep /sys stable here.
> 
> I think that /sys is to valuable to say it can just never be used by
> userspace programs.  With these suggestions, do you see any problems
> with any potential future changes in the layout that you can come up
> with?

I'm afraid that userland programmers just will not read/follow
this... and we will not know.

[Perhaps CONFIG_STRESS_SYSFS_PARSERS would be useful? Move stuff
randomly to expose broken /sys users?]

Then, we'll get binary-only applications working okay relying on
specific /sys structure, and soon, we'll be unable to change /sys.

[Perhaps we can make large parts of sysfs superuser-only, so that
"normal" application can not rely on it?]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
