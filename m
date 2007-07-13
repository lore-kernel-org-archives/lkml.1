Return-Path: <linux-kernel-owner+w=401wt.eu-S1761849AbXGMCPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761849AbXGMCPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 22:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbXGMCPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 22:15:22 -0400
Received: from ns1.suse.de ([195.135.220.2]:42103 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbXGMCPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 22:15:22 -0400
Date: Thu, 12 Jul 2007 19:14:45 -0700
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 01/61] Rules on how to use sysfs in userspace programs
Message-ID: <20070713021445.GB27045@suse.de>
References: <20070711233021.GA5253@kroah.com> <11841967403365-git-send-email-gregkh@suse.de> <20070712084846.GA1882@elf.ucw.cz> <20070712221402.GA30182@suse.de> <20070712224114.GE3374@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712224114.GE3374@elf.ucw.cz>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 12:41:14AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > +The kernel exported sysfs exports internal kernel implementation-details
> > > > +and depends on internal kernel structures and layout. It is agreed upon
> > > > +by the kernel developers that the Linux kernel does not provide a stable
> > > > +internal API. As sysfs is a direct export of kernel internal
> > > > +structures, the sysfs interface can not provide a stable interface eighter,
> > > > +it may always change along with internal kernel changes.
> > > 
> > > It is also agreed upon by the kernel developers that the Linux kernel
> > > does have a stable user<->kernel API... so we have a small problem
> > > here. 
> > 
> > I agree, that is why we have described the proper ways to use /sys in a
> > manner that is acceptable to future changes in it.
> > 
> > > Maybe solution is to declare /sys unstable, but... perhaps /sys can
> > > stop mirroring internal structures? I do not think we should codify
> > > our failure to keep /sys stable here.
> > 
> > I think that /sys is to valuable to say it can just never be used by
> > userspace programs.  With these suggestions, do you see any problems
> > with any potential future changes in the layout that you can come up
> > with?
> 
> I'm afraid that userland programmers just will not read/follow
> this... and we will not know.

Yes we will, when things break on their side due to normal movements
around within sysfs.

Is there any other way you can imagine to get the word out on how to use
this properly?  I'm working with the LSB, so perhaps we can add it to
their next spec for compliance testing of applications...

> [Perhaps CONFIG_STRESS_SYSFS_PARSERS would be useful? Move stuff
> randomly to expose broken /sys users?]

Right now that is CONFIG_SYSFS_DEPRECATED :)

> Then, we'll get binary-only applications working okay relying on
> specific /sys structure, and soon, we'll be unable to change /sys.
> 
> [Perhaps we can make large parts of sysfs superuser-only, so that
> "normal" application can not rely on it?]

Like those big "binary-only applications" don't already run as root...

thanks,

greg k-h
