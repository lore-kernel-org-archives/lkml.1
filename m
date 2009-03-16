Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbZCPNsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbZCPNsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZCPNsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:48:23 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:60471 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752391AbZCPNsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:48:22 -0400
Message-ID: <49BE58BA.1000907@pardus.org.tr>
Date: Mon, 16 Mar 2009 15:48:42 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG 2.6.29_rc8] BIOS Bug: CPU MTRRs don't cover all of memory, losing
 0MB of RAM.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just compiled and tried to boot it on an HP ProLiant DL580 G5. Here's the
interesting part:

..
-- last_pfn = 0x82ffff max_arch_pfn = 0x1000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 0MB of RAM.
------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1655 mtrr_trim_uncached_memory+0x2a9/0x2cd()
Hardware name: ProLiant DL580 G5
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.29_rc8-115 #1
Call Trace:
 [<c013134d>] warn_slowpath+0x71/0xa8
 [<c039971c>] ? _spin_unlock_irqrestore+0x19/0x1f
 [<c039971c>] ? _spin_unlock_irqrestore+0x19/0x1f
 [<c01319c4>] ? release_console_sem+0x185/0x1b2
 [<c0131e49>] ? vprintk+0x280/0x2a5
 [<c03973da>] ? printk+0xf/0x15
 [<c053423f>] mtrr_trim_uncached_memory+0x2a9/0x2cd
 [<c052f4bd>] setup_arch+0x439/0x99e
 [<c01319c4>] ? release_console_sem+0x185/0x1b2
 [<c0131e49>] ? vprintk+0x280/0x2a5
 [<c0531b37>] ? __reserve_early+0xe4/0xf8
 [<c03973da>] ? printk+0xf/0x15
 [<c052b5b6>] start_kernel+0x7b/0x345
 [<c052b085>] __init_begin+0x85/0x8d
---[ end trace 4eaa2a86a8e2da22 ]---
update e820 for mtrr
..

This is a quite generic x86 desktop kernel with only the
following differences for the server:

CONFIG_X86_GENERICARCH=y
CONFIG_X86_BIGSMP=y
CONFIG_MCORE2=y
CONFIG_HIGHMEM64G=y
# CONFIG_X86_GENERIC is not set

I didn't want to add full dmesg and config for not flooding the e-mail but
if you need them or other output/information, i can send them.

Thanks,


Ozan Çağlayan

