Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbXJWSoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbXJWSoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbXJWSoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:44:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8382 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbXJWSoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:44:24 -0400
Date: Tue, 23 Oct 2007 20:44:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.23-git18 Kernel oops in sg helpers
Message-ID: <20071023184419.GD14671@kernel.dk>
References: <471E110C.20404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471E110C.20404@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Kamalesh Babulal wrote:
> Hi,
> 
> Kernel oops is triggered while running fsx-linux test, followed by cpu softlock
> over the AMD box
> 
> Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
>  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> PGD 10185b067 PUD 10075b067 PMD 0 
> Oops: 0002 [1] SMP 
> CPU 3 
> Modules linked in:
> Pid: 18676, comm: fsx-linux Not tainted 2.6.23-git18-autokern1 #1
> RIP: 0010:[<ffffffff8021f2f6>]  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> RSP: 0000:ffff810181edf948  EFLAGS: 00010002

Can you check where gart_map_sg+0x26c is at? Make sure you have
CONFIG_DEBUG_INFO defined, then do:

$ gdb vmlinux
$ l *gart_map_sg+0x26c

Thanks!

-- 
Jens Axboe

