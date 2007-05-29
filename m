Return-Path: <linux-kernel-owner+w=401wt.eu-S1762712AbXE2RIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762712AbXE2RIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbXE2RIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:08:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:53381 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbXE2RIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:08:04 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Tetsuo Handa <from-lsm@i-love.sakura.ne.jp>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSMhook
Date: Tue, 29 May 2007 19:07:29 +0200
User-Agent: KMail/1.9.5
Cc: crispin@novell.com, cliffe@iinet.net.au, casey@schaufler-ca.com,
       mrmacman_g4@mac.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <465B57D7.2040101@novell.com> <200705291946.FDB72328.NtTGSNMP@I-love.SAKURA.ne.jp>
In-Reply-To: <200705291946.FDB72328.NtTGSNMP@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291907.29547.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007 12:46, Tetsuo Handa wrote:
> But, from the pathname-based access control's point of view,
> bind mount interferes severely with pathname-based access control
> because it is impossible to determine which pathname was requested.

Wrong. It is very well possible to determine the path of a particular dentry 
(+ vfsmount) with bind mounts.

> Although both pathnames point to the same object, TOMOYO focuses on the
> PROCEDURE FOR REACHING AN OBJECT and being able to know the procedure is
> very important.

This doesn't make sense, either. With the following sequence of syscalls of 
processes A and B (both of them in the namespace root),

	A:				B:
	mkdir("/tmp/a")
	chdir("/tmp/a")
					rename("/tmp/a", "/tmp/b")
	creat("f")

the path being checked for the creat call must be "/tmp/b/f", even though 
process A never explicitly used "b". If that's not what TOMOYO is doing, then 
that's badly broken.

Andreas
