Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbXJGTUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbXJGTUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXJGTU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:20:29 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50340 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbXJGTU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:20:28 -0400
Date: Sun, 7 Oct 2007 15:20:19 -0400
Message-Id: <200710071920.l97JKJX5018871@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Cc: "Ryan Finnie" <ryan@finnie.org>, Colin Watson <cjwatson@ubuntu.com>
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

According to vfs.txt, ->writepage() may return AOP_WRITEPAGE_ACTIVATE back
to the VFS/VM.  Indeed some filesystems such as tmpfs can return
AOP_WRITEPAGE_ACTIVATE; and stackable file systems (e.g., Unionfs) also
return AOP_WRITEPAGE_ACTIVATE if the lower f/s returned it.

Anyway, some Ubuntu users of Unionfs reported that msync(2) sometimes
returns AOP_WRITEPAGE_ACTIVATE (decimal 524288) back to userland.
Therefore, some user programs fail, esp. if they're written such as this:

     err = msync(...);
     if (err != 0)
	// fail

They temporarily fixed the specific program in question (apt-get) to check

     if (err < 0)
	// fail

Is this a bug indeed, or are user programs supposed to handle
AOP_WRITEPAGE_ACTIVATE (I hope not the latter).  If it's a kernel bug, what
should the kernel return: a zero, or an -errno (and which one)?

Thanks,
Erez.
