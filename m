Return-Path: <linux-kernel-owner+w=401wt.eu-S938384AbXGSOmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938384AbXGSOmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764388AbXGSOmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:42:38 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:52267 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765524AbXGSOmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:42:37 -0400
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <Pine.LNX.4.58.0707191442440.2138@be1.lrz>
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
	 <200707181754.05560.rob@landley.net>
	 <Pine.LNX.4.58.0707191442440.2138@be1.lrz>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 19 Jul 2007 10:41:28 -0400
Message-Id: <1184856088.17338.513.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 15:56 +0200, Bodo Eggert wrote:
> On Wed, 18 Jul 2007, Rob Landley wrote:
> > On Friday 13 July 2007 2:56:00 pm Bodo Eggert wrote:
> 
> > > I toyed with setting up a diskless system in initramfs. In the process, I
> > > came across some things:
> > >
> > > 1)  There is no way to have the kernel not mount a filesystem,
> > >     unless you use /init or rdinit=.
> > 
> > Er, yes.  By design.
> > 
> > The kernel has to run an init program in order to hand off control to 
> > userspace.  In initramfs, this is defined as /init.  It looks in exactly one 
> > documented place.
> > 
> > The older root= mechanism fell back to a half-dozen places (eventually trying 
> > things like /bin/sh if it couldn't find anything else).  This is because 
> > there wasn't a documented standard for what should be executed, like there is 
> > with initramfs.
> 
> Ever since I started using linux in 1997, the first program to run from an
> installed system was /sbin/init. (I might think about removing the other 
> paths.)
> 
> The ramfs' /init was intended for system setup, which is a separate job.
> It is not intended to be the program running the system. Mixing those two
> up just does not feel right. Setting root= in order to change the root
> directory is much more natural.
> 
> > > 1a) In the process of writing these patches, I found prepare_namespace not
> > > to be called if /init is present. prepare_namespace will call
> > >     security_sb_post_mountroot after mounting the root fs. I did not yet
> > > see a way to call this from /init, and grepping kinit for "security" did
> > > not help, too.
> > 
> > I don't use selinux.  I'm neither a Fortune 500 company nor the NSA.
> 
> That's no reason for keeping bugs in that part.
> 
> > However, if you don't trust your own initramfs, where everything starts out 
> > running as root, you have bigger problems.
> 
> Using that argument, you can deduce that nobody would need selinux at all.
> Obviously some people disagree, and maybe some of them are no fools,
> therefore we should try to DTRT for them and do the callback when it's
> supposed to happen.

Not wanting to get into any flamewars here about selinux, but just FYI:
security_sb_post_mountroot is obsolete and can be removed without harm
to selinux; it is a leftover of selinux before we moved the initial
policy load to userspace.  These days, initial policy load is done
by /sbin/init in most distros that support selinux, although I'd prefer
to do it earlier from the initramfs (the Fedora folks didn't like that
idea though at the time, so /sbin/init got patched instead - but that
was back in 2003, so maybe things have changed).

-- 
Stephen Smalley
National Security Agency

