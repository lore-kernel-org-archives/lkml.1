Return-Path: <linux-kernel-owner+w=401wt.eu-S1765843AbYDOQdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765843AbYDOQdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYDOQc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:32:56 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:20192 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756120AbYDOQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:32:54 -0400
X-YMail-OSG: 7jpQIGgVM1mM3nm1cVhUlgSbgdktDEaYJ5RubosaSVGlgy5Cd7AlC6MgXCfkYnrAVXo7djoMdQ--
X-RocketYMMF: rancidfat
Date: Tue, 15 Apr 2008 09:32:53 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, crispin@crispincowan.com
Cc: serue@us.ibm.com, matthew@wil.cx, paul.moore@hp.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200804152014.IAB35427.tFLHSMOQOFOFJV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <687382.36673.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Casey Schaufler wrote:
> > The question of protections on the object named /etc/passwd came
> > up time and time again. The notion that /etc/passwd could be a
> > symlink to /home/smalley/heeheehee really gave evaluators the
> > whillies. As did the chroot environment, where /roots/crispin/etc/passwd
> > could magicly become /etc/passwd.
>
> Why do people continue speaking symlinks and chroots?

Because on any given Linux system you could have an arbitrarily
large number of different things that might be accessed by the
name "/etc/passwd" and a different, but similarly large number
of names other than "/etc/passwd" that can be used to access them.

> To avoid the effect of symlinks and chroots, AppArmor and TOMOYO Linux
> derive pathnames from dentry and vfsmount.
> If /etc/passwd was a symlink, the derived pathname will be
> /home/smalley/heeheehee.
> If accessed from inside a chroot, the derived pathname will be
> /roots/crispin/etc/passwd.

Which doesn't hold up under hard links, which I had carefully
avoided and that both AppArmor and TOMOYO Linux have to place
restrictions on for the systems to make sense.

> It is true that namespace may differ between processes,
> but I think that that is the matter of how to restrict namespace manipulation
> operations.
> As I said, a system can't survive if namespace is madly manipulated.

That's hardly the viewpoint of those who would have every
user mount their own version of /tmp.

> To keep the system workable, /bin/ must be the directory for binary programs,
> /etc/ must be the directory for configuration files, and so on in all
> namespaces.

Only for general purpose shell access. General purpose shell access
is decreasing in popularity.

> It is true that the pathname may change while traversing up the
> dentry/vfsmount trees.
> But the change does not occur infinitely.
> As I said, a system can't survive if files and directories are madly renamed.
> The possible changes are bounded by the policy.
> 
> At least, I want people not to speak symlinks and chroots when talking about
> AppArmor and TOMOYO Linux.

The issues with links, symlinks, chroots and mounts in the
context of a name based access control scheme will always
need to be addressed, just as the issues of unlabeled filesystems
and /tmp will have to be in label based scheme.


Casey Schaufler
casey@schaufler-ca.com
