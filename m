Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbXL2Dnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbXL2Dnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 22:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXL2Dn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 22:43:28 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:59657 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbXL2Dn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 22:43:27 -0500
To: serue@us.ibm.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: TOMOYO Linux Security Goal
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071226164230.GA14210@sergelap.austin.ibm.com>
	<200712272200.IIJ73936.OHOFFLMOQJVFtS@I-love.SAKURA.ne.jp>
	<20071227145431.GB5161@sergelap.austin.ibm.com>
	<200712282332.EGC57888.OFFQHJOLVSMtFO@I-love.SAKURA.ne.jp>
	<20071228151221.GA12548@sergelap.austin.ibm.com>
In-Reply-To: <20071228151221.GA12548@sergelap.austin.ibm.com>
Message-Id: <200712291243.HFE05726.MFOJOVLQFFOtSH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 29 Dec 2007 12:43:24 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Serge E. Hallyn wrote:
> > > >   * namespace manipulation. (i.e. mount()/umount()/pivot_root())
> > > 
> > > do you track mounts namespace cloning?
> > > 
> > Yes. TOMOYO can recognize mount operation with the following flags.
> > 
> >   --bind --move --remount
> >   --make-unbindable --make-private --make-slave --make-shared
> 
> No, I mean clone(CLONE_NEWNS) and unshare(CLONE_NEWNS).  Without
> tracking those, it seems like a convoluted sequence of mounting,
> unmonting, and mount sharing and unsharing could potentially confuse
> your policy or your admins...
Oh, I see. TOMOYO doesn't track clone() and unshare().

> I haven't fully thought it through.  But at least if an admin makes a
> policy update with an expectation that all processes have the same mount
> trees the result could be unsafe.
TOMOYO doesn't expect that all processes have the same mount trees.
But TOMOYO expects that the mount trees won't change unless one of mount()/
umount()/pivot_root() are called.
Does a process get different mount trees by just calling clone() or unshare()?
My understanding is that clone() or unshare() disables propergation of
mount tree changes when somebody calls mount() or umount() or pivot_root().

> > Speak of bind mounts, there comes vfsmount problem.
> > AppArmor has been proposing patches to pass "struct vfsmount" parameter to
> > VFS helper functions and LSM hooks so that AppArmor/TOMOYO can determine
> > which pathname was requested in the bind-mounted environment.
> > Without the vfsmount patches, we can't calculate pathname without the risk of
> > AB-BA deadlock (if namespace_sem held) or crash (if namespace_sem not held).
> > I think we should start discussing how the vfsmount patches can be merged.
> > I'm sad to see no response for AppArmor's posting
> > at http://lkml.org/lkml/2007/12/20/182 .
> 
> If the patches solve your problem, and you respond saying "TOMOYO needs
> these patches too", it just might get the thread going.
> 
I'll say it when I submit patches.

Regards.
