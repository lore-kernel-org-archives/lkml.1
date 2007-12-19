Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbXLSFyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbXLSFyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbXLSFym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:54:42 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45929 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751233AbXLSFyl (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:54:41 -0500
Date: Wed, 19 Dec 2007 16:54:30 +1100
From: David Chinner <dgc@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org
Subject: [ia64] BUG: sleeping in atomic
Message-ID: <20071219055430.GV4396912@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just saw this again:

[ 5667.086055] BUG: sleeping function called from invalid context at kernel/fork.c:401
[ 5667.087314] in_atomic():1, irqs_disabled():0
[ 5667.088210]
[ 5667.088212] Call Trace:
[ 5667.089104]  [<a000000100015e00>] show_stack+0x80/0xa0
[ 5667.089106]                                 sp=e0000038f6507a00 bsp=e0000038f6500f48
[ 5667.116025]  [<a000000100015e50>] dump_stack+0x30/0x60
[ 5667.116028]                                 sp=e0000038f6507bd0 bsp=e0000038f6500f30
[ 5667.118317]  [<a0000001000af8a0>] __might_sleep+0x1e0/0x200
[ 5667.118320]                                 sp=e0000038f6507bd0 bsp=e0000038f6500f08
[ 5667.142316]  [<a0000001000c55a0>] mmput+0x20/0x220
[ 5667.142319]                                 sp=e0000038f6507bd0 bsp=e0000038f6500ee0
[ 5667.164201]  [<a000000100033ae0>] sys_ptrace+0x460/0x15c0
[ 5667.164203]                                 sp=e0000038f6507bd0 bsp=e0000038f6500dd0
[ 5667.175488]  [<a00000010000b4a0>] ia64_ret_from_syscall+0x0/0x20
[ 5667.175490]                                 sp=e0000038f6507e30 bsp=e0000038f6500dd0
[ 5667.199324]  [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
[ 5667.199327]                                 sp=e0000038f6508000 bsp=e0000038f6500dd0
[ 5682.626704] BUG: sleeping function called from invalid context at kernel/fork.c:401

When stracing a process on 2.6.24-rc3 on ia64. commandline to reproduce:

# strace ls -l /mnt/scratch/test

ISTR reporting this some time ago (maybe 2.6.22?)....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
