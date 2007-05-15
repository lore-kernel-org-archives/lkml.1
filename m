Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbXEOR2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbXEOR2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbXEOR2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:28:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43544 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbXEOR2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:28:37 -0400
Subject: select(0, ..) is valid ?
From: Badari Pulavarty <pbadari@us.ibm.com>
To: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 May 2007 10:29:18 -0700
Message-Id: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is select(0, ..) is a valid operation ?

I see that there is no check to prevent this or return
success early, without doing any work. Do we need one ?

slub code is complaining that we are doing kmalloc(0).

Thanks,
Badari

------------[ cut here ]------------
Badness at include/linux/slub_def.h:88
Call Trace:
[c0000001e4eb7640] [c00000000000e650] .show_stack+0x68/0x1b0
(unreliable)
[c0000001e4eb76e0] [c00000000029b854] .report_bug+0x94/0xe8
[c0000001e4eb7770] [c0000000000219f0] .program_check_exception
+0x12c/0x568
[c0000001e4eb77f0] [c000000000004a84] program_check_common+0x104/0x180
--- Exception: 700 at .get_slab+0x4c/0x234
    LR = .__kmalloc+0x24/0xc4
[c0000001e4eb7ae0] [c0000001e4eb7b80] 0xc0000001e4eb7b80 (unreliable)
[c0000001e4eb7b80] [c0000000000a7ff0] .__kmalloc+0x24/0xc4
[c0000001e4eb7c10] [c0000000000ea720] .compat_core_sys_select+0x90/0x240
[c0000001e4eb7d00] [c0000000000ec3a4] .compat_sys_select+0xb0/0x190
[c0000001e4eb7dc0] [c000000000014944] .ppc32_select+0x14/0x28
[c0000001e4eb7e30] [c00000000000872c] syscall_exit+0x0/0x40


