Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbXL1OcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbXL1OcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 09:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbXL1OcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 09:32:14 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:63975 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbXL1OcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 09:32:13 -0500
To: serue@us.ibm.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: TOMOYO Linux Security Goal
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200712252133.JFF05267.FOMFtOLJHSOVFQ@I-love.SAKURA.ne.jp>
	<20071226164230.GA14210@sergelap.austin.ibm.com>
	<200712272200.IIJ73936.OHOFFLMOQJVFtS@I-love.SAKURA.ne.jp>
	<20071227145431.GB5161@sergelap.austin.ibm.com>
In-Reply-To: <20071227145431.GB5161@sergelap.austin.ibm.com>
Message-Id: <200712282332.EGC57888.OFFQHJOLVSMtFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 28 Dec 2007 23:32:09 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.


Serge E. Hallyn wrote:
> Auto-learning in itself doesn't seem novel, but so you're saying it's
> novel in ust how integrated it is - no mnual intervention necessary?

You can run your system with only policy collected by learning mode.
Thus, you basically don't need manual intervention.
But since there are randomly named files (i.e. temporary files),
you pay a little time to modify policy.

The learning mode is to save time for permitting commonly accessed resources.
Administrator reviews policy collected by learning mode. Thus the readability
of policy is important so that administrator can understand what he/she is
going to allow or reject.


> Does grsec's learning mode come closer to yours?  (I've never used
> grsec, just got the impression it did a lot of auto-learning stuff)
I looked at a glance. As far as I saw, it is not real-time policy generation.
It generates policy from logs like SELinux's audit2allow or AppArmor's
aa-genprof . Thus, I think grsec doesn't add domains in real-time like TOMOYO.
(I never used grsec too.)

It seems to me that grsec is designed for as fine grained access control
as SELinux's, while AppArmor and TOMOYO is designed for usability.
AppArmor's final implementation might come closer to grsec.


> >   * namespace manipulation. (i.e. mount()/umount()/pivot_root())
> 
> do you track mounts namespace cloning?
> 
Yes. TOMOYO can recognize mount operation with the following flags.

  --bind --move --remount
  --make-unbindable --make-private --make-slave --make-shared

Although pathname based access control is not good at handling complicated
mount operations like http://lwn.net/Articles/159077/ , many systems don't
require such complicated ones.

Speak of bind mounts, there comes vfsmount problem.
AppArmor has been proposing patches to pass "struct vfsmount" parameter to
VFS helper functions and LSM hooks so that AppArmor/TOMOYO can determine
which pathname was requested in the bind-mounted environment.
Without the vfsmount patches, we can't calculate pathname without the risk of
AB-BA deadlock (if namespace_sem held) or crash (if namespace_sem not held).
I think we should start discussing how the vfsmount patches can be merged.
I'm sad to see no response for AppArmor's posting
at http://lkml.org/lkml/2007/12/20/182 .


> Well I don't see how you could without a new lsm hook  :)  But it seems
> like something you'd need to really support this claim.  Any plans of
> it?
I'm ready to submit patches for 2.6.24-rc6-mm1, but it seems to me that many
developers are offline. So, I'll submit patches when they come back to online.


Regards.
