Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbYCJM4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbYCJM4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 08:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYCJM4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 08:56:08 -0400
Received: from flatline.de ([80.190.243.144]:48408 "EHLO mail.flatline.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbYCJM4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 08:56:07 -0400
X-Greylist: delayed 2025 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 08:56:06 EDT
Date: Mon, 10 Mar 2008 13:22:16 +0100
From: Andreas Kotes <count-linux@flatline.de>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS internal error
Message-ID: <20080310122216.GG14256@slop.flatline.de>
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008001452.GX995458@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Score: 0.1 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

* David Chinner <dgc@sgi.com> [20080310 13:18]:
> Yes, but those previous corruptions get left on disk as a landmine
> for you to trip over some time later, even on a kernel that has the
> bug fixed.
> 
> I suggest that you run xfs_check on the filesystem and if that
> shows up errors, run xfs_repair onteh filesystem to correct them.

I seem to be having similiar problems, and xfs_repair is not helping :(

I always run into:

[  137.099267] Filesystem "sda2": XFS internal error xfs_trans_cancel at line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff80372156
[  137.106267]
[  137.106268] Call Trace:
[  137.113129]  [<ffffffff803692f0>] xfs_trans_cancel+0x100/0x130
[  137.116524]  [<ffffffff80372156>] xfs_create+0x256/0x6e0
[  137.119904]  [<ffffffff80341e09>] xfs_dir2_isleaf+0x19/0x50
[  137.123269]  [<ffffffff8037e145>] xfs_vn_mknod+0x195/0x250
[  137.126607]  [<ffffffff8028f32c>] vfs_create+0xac/0xf0
[  137.129920]  [<ffffffff80292b3c>] open_namei+0x5dc/0x700
[  137.133227]  [<ffffffff8022a443>] __wake_up+0x43/0x70
[  137.136477]  [<ffffffff802851bc>] do_filp_open+0x1c/0x50
[  137.139693]  [<ffffffff8028524a>] do_sys_open+0x5a/0x100
[  137.142838]  [<ffffffff80220a83>] sysenter_do_call+0x1b/0x67
[  137.145964]
[  137.149014] xfs_force_shutdown(sda2,0x8) called from line 1133 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8036930e
[  137.163485] Filesystem "sda2": Corruption of in-memory data detected.  Shutting down filesystem: sda2

directly after booting.

I'm using kernel 2.6.22.16 and xfs_repair version 2.9.7

How can I help finding the problem? I'd like xfs_repair to be able to
fix this.

Br,

   Andreas

-- 
flatline IT services - Andreas Kotes - Tailored solutions for your IT needs
