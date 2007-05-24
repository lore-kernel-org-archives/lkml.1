Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbXEXMwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbXEXMwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbXEXMvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:51:50 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:63169 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbXEXMvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:51:48 -0400
To: jmorris@namei.org, agruen@suse.de
Cc: viro@ftp.linux.org.uk, jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, tonyj@suse.de
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSMhook
From: Tetsuo Handa <penguin-fsdevel@I-love.SAKURA.ne.jp>
References: <20070412090809.917795000@suse.de>
	<20070412090836.207973000@suse.de>
	<20070412101236.GD4095@ftp.linux.org.uk>
	<200705232106.28260.agruen@suse.de>
	<Line.LNX.4.64.0705232109030.3178@d.namei>
In-Reply-To: <Line.LNX.4.64.0705232109030.3178@d.namei>
Message-Id: <200705242151.HAD83735.OOFEFMVJFWGQtHT@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Thu, 24 May 2007 21:51:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I think bind mounts were discussed when shared subtree
( http://lwn.net/Articles/159092/ ) was introduced.

For systems that allow users mount their CD/DVDs freely,
bind mounts are used and labeling files is a convenient way
to deny accessing somebody else's files.

But systems that don't allow users mount their CD/DVDs freely,
bind mounts needn't to be used and using pathnames is a convenient way
to deny accessing somebody else's files.

Pathname based access control/auditing system
works if the system doesn't use bind mounts.

However, there are distributions (e.g. Debian Etch)
that always use bind mounts. In such distributions,
pathname based access control/auditing system doesn't work.

This is not the fault of distributions nor
pathname based access control/auditing system.
It is possible to solve by passing vfsmount to VFS and LSM functions.

SELinux users are having a lot of trouble because pathnames in audit logs
are not always complete.
AppArmor users are having a lot of trouble because pathnames which
a process requested are ambiguous when bind mounts are used.

Being able to report pathnames that a process requested is not surprising
when considering user friendliness.
I beleive passing vfsmount makes both users happy.

Thanks.
