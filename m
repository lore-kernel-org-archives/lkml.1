Return-Path: <linux-kernel-owner+w=401wt.eu-S1765690AbXE2Urn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765690AbXE2Urn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758039AbXE2Urf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:47:35 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:51383 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbXE2Ure (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:47:34 -0400
To: agruen@suse.de
Cc: crispin@novell.com, cliffe@iinet.net.au, casey@schaufler-ca.com,
       mrmacman_g4@mac.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSMhook
From: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com>
	<465B57D7.2040101@novell.com>
	<200705291946.FDB72328.NtTGSNMP@I-love.SAKURA.ne.jp>
	<200705291907.29547.agruen@suse.de>
In-Reply-To: <200705291907.29547.agruen@suse.de>
Message-Id: <200705300547.AJG94871.SNTPGtMN@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Wed, 30 May 2007 05:47:36 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andreas Gruenbacher wrote:
> > But, from the pathname-based access control's point of view,
> > bind mount interferes severely with pathname-based access control
> > because it is impossible to determine which pathname was requested.
> Wrong. It is very well possible to determine the path of a particular dentry 
> (+ vfsmount) with bind mounts.
AppArmor can't determine which pathname (/tmp/public/file or /tmp/secret/file)
was requested by touch command if bound mount is used in the following way

# mkdir /tmp/public /tmp/secret
# mount -t tmpfs none /tmp/public
# mount --bind /tmp/public /tmp/secret
# touch /tmp/public/file

because security_inode_create() doesn't receive vfsmount, can it?
It is possible to determine that the requested pathname is either
/tmp/public/file or /tmp/secret/file by comparing address of vfsmount
available from current->namespace, but it is impossible to determine which one.

> the path being checked for the creat call must be "/tmp/b/f", even though 
> process A never explicitly used "b". If that's not what TOMOYO is doing, then 
> that's badly broken.
Yes, of course, TOMOYO checks "/tmp/b/f". What I meant PROCEDURE FOR REACHING is
"which directory does the process need to go through to reach the requested file
if the process's current directory is the root of the process's namespace".
And in this case, it is "/tmp/b/f".

Thanks.
