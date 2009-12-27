Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbZL0OmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbZL0OmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 09:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZL0OmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 09:42:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33698 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbZL0OmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 09:42:07 -0500
X-Authority-Analysis: v=1.0 c=1 a=igne1qBhNWMA:10 a=7nvsQjodx8uHge9pvuoA:9 a=ytaUk97X-0edWnrSCDiLxVgxuOkA:4
X-Cloudmark-Score: 0
X-Originating-IP: 70.124.57.33
Date: Sun, 27 Dec 2009 08:54:28 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Valdis.Kletnieks@vt.edu
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: A basic question about the security_* hooks
Message-ID: <20091227145428.GA19414@hallyn.com>
References: <20091225055034.GA374@us.ibm.com> <20091226195043.GA1945@heat> <20091227031631.GA17629@hallyn.com> <200912271302.JBH64754.JtLMFQVOSOFFHO@I-love.SAKURA.ne.jp> <22669.1261911374@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22669.1261911374@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu):
> On Sun, 27 Dec 2009 13:02:54 +0900, Tetsuo Handa said:
> > I believe TOMOYO can safely coexist with other security modules.
> > Why TOMOYO must not be used with SELinux or Smack or AppArmor?
> > What interference are you worrying when enabling TOMOYO with SELinux or Smack
> > or AppArmor?

...

> First, it's possible to totally screw up your box - consider 2 defective
> policies where each prevents a reload of the other's policy.  Now note that it
> doesn't even need to be the *policy* - if the Tomoyo policy files get
> mislabeled with the wrong SELinux context, then an SELinux component will
> probably prevent access to the policy and thus prevent the load.  Your system
> is now *at best* running SELinux-only (and now vulnerable to to any attacks you
> were depending on Tomoyo to stop). At worst, the wrecked Tomoyo policy will
> mean that Tomoyo will then reject the SELinux 'restorecon' command to correct
> the labels, leaving you in a situation where you can't recover your box.
> 
> Second, it's unclear what a combo of two different MAC systems would *mean*,
> and whether it creates corner cases that can be exploited - the "two systems
> block each other's reloads" mentioned above is but one example. If a system that
> depends on inode labeling is active at the same time as a path-based system,
> what happens if you manage to do an 'mv' command that changes the security
> context in the path-based system while leaving the inode label the same, or
> relabel an inode without rename it to match? The file has just experienced
> a security transition for one system, but not the other. Are there any
> files and transitions where the mismatch matters?
> 
> If the two systems load policies with the same semantics, why are you
> bothering?  And if they load different semantics, can the difference be
> leveraged by an attacker?

Agree with everything Valdis said (including after this part, which I cut).

Why do you compose the two?  I assume you went to the trouble because
you have a specific use case, a definite advantage?

-serge
