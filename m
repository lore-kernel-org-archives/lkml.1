Return-Path: <linux-kernel-owner+w=401wt.eu-S1751590AbZL1Lvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbZL1Lvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZL1Lvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:51:52 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:65469 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZL1Lvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:51:52 -0500
To: Valdis.Kletnieks@vt.edu
Cc: serge@hallyn.com, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: A basic question about the security_* hooks
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091225055034.GA374@us.ibm.com>
	<20091226195043.GA1945@heat>
	<20091227031631.GA17629@hallyn.com>
	<200912271302.JBH64754.JtLMFQVOSOFFHO@I-love.SAKURA.ne.jp>
	<22669.1261911374@localhost>
In-Reply-To: <22669.1261911374@localhost>
Message-Id: <200912282051.BIF64080.VOMtFOOLSHJFFQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 28 Dec 2009 20:51:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your opinion.

Valdis.Kletnieks@vt.edu wrote:
> Usually, the right answer is to fix XYZ, not try to load ZQW on top of it.

Yes, to fix SELinux is the right answer if we can integrate TOMOYO into
SELinux. But SELinux had been advertised as label based access control and had
been rejecting pathname based access control. I doubt SELinux wants to
integrate pathname based access control.

Screwed up due to improper policy configurations / conflicts and unable to
recover cannot be reasons to reject enabling multiple LSM modules.
Such situations do happen even single LSM module.
There are lots of access control mechanisms outside LSM.

Executing SELinux's restorecon can fail due to ENOMEM.
The restorecon may not be executed due to "mount -o noexec".
The restorecon may be replaced by "mount --bind /bin/true /sbin/restorecon".
The restorecon may not work as expected due to improper LD_PRELOAD environment.
Changing xattr of an inode may fail due to EIO.

Note that SELinux or TOMOYO is not the only factor that makes operations fail.
For SELinux, TOMOYO is one of factors that make operations for SELinux fail.
For TOMOYO, SELinux is one of factors that make operations for TOMOYO fail.
SELinux and TOMOYO have to prepare for bad consequence when failures like
ENOMEM, EIO, EACCES, EPERM occurred outside SELinux or TOMOYO.

People enable SELinux and/or TOMOYO by accepting the risk shown above.
Those who think the benefit of enabling SELinux is larger than the risk of
enabling SELinux enable SELinux. Those who think the risk of enabling SELinux
is larger than the benefit of enabling SELinux don't enable SELinux.
Those who think the benefit of enabling both SELinux and TOMOYO is larger than
the risk of enabling both enable both. Those who think the risk of enabling
both is larger than the benefit of enabling both don't enable both.
It is Linux users who evaluate, not Linux kernel developers. Keeping SELinux
and TOMOYO mutually exclusive deprives Linux users of chances to evaluate, and
prevents Linux kernel developers from coming up with new ideas/implementations.
Why not to give Linux users choice for enabling both?

Serge E. Hallyn wrote:
> Why do you compose the two?  I assume you went to the trouble because
> you have a specific use case, a definite advantage?

SELinux is useful for protecting daemons as ready made policy is distributed,
but console/ssh sessions are not protected (unconfined_t) for most systems.
TOMOYO is useful for restricting console/ssh sessions as administrators can
develop policy by their own.

Both SELinux and TOMOYO have ability to cover all processes (from /sbin/init
till /sbin/poweroff) or targeted processes (e.g. only daemons). But SELinux is
not widely used for protecting all processes. TOMOYO can provide some
protection for processes which SELinux doesn't protect.

Also, people know we sometimes need to restrict string parameters for avoiding
unwanted consequence. TOMOYO can pay attention to string parameters whereas
SELinux can't.

Regards.
