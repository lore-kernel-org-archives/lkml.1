Return-Path: <linux-kernel-owner+w=401wt.eu-S933727AbXJSTTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbXJSTTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbXJSTTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:19:07 -0400
Received: from lazybastard.de ([212.112.238.170]:37072 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbXJSTTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:19:06 -0400
Date: Fri, 19 Oct 2007 21:14:33 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [BLOCK2MTD] WARNING: at kernel/lockdep.c:2331 lockdep_init_map()
Message-ID: <20071019191433.GK26913@lazybastard.org>
References: <200710191753.l9JHreeS012064@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710191753.l9JHreeS012064@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 October 2007 13:53:40 -0400, Erez Zadok wrote:
>
> I've been having this problem for some time with mtd, which I use to mount
> jffs2 images (for unionfs testing).  I've seen it in several recent major
> kernels, including 2.6.24.  Here's the sequence of ops I perform:

Since when roughly?  2.6.20ish?  Before?

> # cp jffs2-empty.img /tmp/foo
> # losetup /dev/loop0 /tmp/foo
> # modprobe mtdblock
> # modprobe block2mtd block2mtd=/dev/loop0,128ki
> # mount -t jffs2 /dev/mtdblock0 /n/lower/b0

Side note: you don't need mtdblock:
# cp jffs2-empty.img /tmp/foo
# losetup /dev/loop0 /tmp/foo
# modprobe block2mtd block2mtd=/dev/loop0,128ki
# mount -t jffs2 mtd0 /n/lower/b0

It doesn't really hurt, 'tis just superfluous.

> The jffs2-empty.img is a small jffs2 image, of an empty directory, created
> w/ the jffs2 utils.  At the point I modprobe block2mtd, I get the following
> lockdep warning and a "BUG" message:
> 
> BUG: key f88e1340 not in .data!
> WARNING: at kernel/lockdep.c:2331 lockdep_init_map()
>  [<c0102bc2>] show_trace_log_lvl+0x1a/0x2f
>  [<c0103692>] show_trace+0x12/0x14
>  [<c01037b2>] dump_stack+0x15/0x17
>  [<c0125432>] lockdep_init_map+0x94/0x3e4
>  [<c0125001>] debug_mutex_init+0x2c/0x3c
>  [<c01210d4>] __mutex_init+0x38/0x40
>  [<f88e01d3>] 0xf88e01d3
>  [<c011dda7>] parse_args+0x123/0x200
>  [<c012b725>] sys_init_module+0xdd0/0x122c
>  [<c0102586>] sysenter_past_esp+0x5f/0x91
>  =======================
> block2mtd: mtd0: [d: /dev/loop0] erase_size = 128KiB [131072]
> block2mtd: version $Revision: 1.30 $

Could be my problem.  I'll see if I can reproduce it.  Can you send me
your .config or a link to it?

Jörn

-- 
/* Keep these two variables together */
int bar;
