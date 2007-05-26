Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbXEZMJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbXEZMJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 08:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbXEZMJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 08:09:19 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:51011 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXEZMJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 08:09:18 -0400
To: agruen@suse.de, mrmacman_g4@mac.com
Cc: casey@schaufler-ca.com, jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Pass struct vfsmount to the inode_create LSM hook
From: Tetsuo Handa <penguin-fsdevel@I-love.SAKURA.ne.jp>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com>
	<B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
	<200705261346.20712.agruen@suse.de>
In-Reply-To: <200705261346.20712.agruen@suse.de>
Message-Id: <200705262109.JJB99189.TFHFGQEOtVOMWJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Sat, 26 May 2007 21:09:16 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andreas Gruenbacher wrote:
> > exec { "/usr/bin/gunzip" } "gzip", "-9", "some/file/to.gz";
> The above Perl code executes /usr/bin/gunzip and sets argv[0] to "gzip", so 
> this confirms that the value of argv[0] is arbitrary. Well great, we already 
> knew.

> AppArmor does not look at argv[0] for anything, and doing so would be insane. 
> So please don't jump to the wrong conclusions.
I agree that argv[0] checking is different from pathname-based access control
or label-based access control, but I want to say argv[0] checking is still needed.

If you don't check argv[0], an attacker can request everything like

exec { "/bin/ls" } "/sbin/busybox", "cat", "/etc/shadow";
exec { "/bin/ls" } "/sbin/busybox", "rm", "/etc/shadow";

if /bin/ls and /bin/cat and /bin/rm are hardlinks of /sbin/busybox (e.g. embedded systems).

Therefore, TOMOYO Linux checks the combination of filename and argv[0] passed to execve().

Thanks.
