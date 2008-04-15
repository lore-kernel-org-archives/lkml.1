Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbYDOLO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbYDOLO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYDOLOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:14:46 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49466 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107AbYDOLOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:14:45 -0400
To: casey@schaufler-ca.com, sds@tycho.nsa.gov, crispin@crispincowan.com,
       casey@schaufler-ca.com
Cc: serue@us.ibm.com, matthew@wil.cx, paul.moore@hp.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       linux-fsdevel@vger.kernel.org
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1208182620.18883.92.camel@moss-spartans.epoch.ncsc.mil>
	<484889.77284.qm@web36604.mail.mud.yahoo.com>
In-Reply-To: <484889.77284.qm@web36604.mail.mud.yahoo.com>
Message-Id: <200804152014.IAB35427.tFLHSMOQOFOFJV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 15 Apr 2008 20:14:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> The question of protections on the object named /etc/passwd came
> up time and time again. The notion that /etc/passwd could be a
> symlink to /home/smalley/heeheehee really gave evaluators the
> whillies. As did the chroot environment, where /roots/crispin/etc/passwd
> could magicly become /etc/passwd.
Why do people continue speaking symlinks and chroots?
To avoid the effect of symlinks and chroots, AppArmor and TOMOYO Linux
derive pathnames from dentry and vfsmount.
If /etc/passwd was a symlink, the derived pathname will be /home/smalley/heeheehee.
If accessed from inside a chroot, the derived pathname will be /roots/crispin/etc/passwd.

It is true that namespace may differ between processes,
but I think that that is the matter of how to restrict namespace manipulation operations.
As I said, a system can't survive if namespace is madly manipulated.
To keep the system workable, /bin/ must be the directory for binary programs,
/etc/ must be the directory for configuration files, and so on in all namespaces.

It is true that the pathname may change while traversing up the dentry/vfsmount trees.
But the change does not occur infinitely.
As I said, a system can't survive if files and directories are madly renamed.
The possible changes are bounded by the policy.

At least, I want people not to speak symlinks and chroots when talking about
AppArmor and TOMOYO Linux.

Regards.
