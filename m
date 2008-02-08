Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbYBHXhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbYBHXhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYBHXhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:37:40 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58146 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753503AbYBHXhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:37:38 -0500
Message-Id: <20080208233738.108449000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 08 Feb 2008 15:37:38 -0800
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] NR_CPUS: non-x86 arch specific reduction of NR_CPUS usage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's another round of removing static allocations of arrays
using NR_CPUS to size the length.  The change is to use PER_CPU
variables in place of the static tables.

Based on linux-2.6.git + x86.git

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: cpufreq@lists.linux.org.uk
Cc: Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org
Cc: Philippe Elie <phil.el@wanadoo.fr>
Cc: oprofile-list@lists.sf.net

Signed-off-by: Mike Travis <travis@sgi.com>
---
(1 - if modules enabled, does not complete boot even
     without this patch)

x86_64 configs built and booted:

    ingo-stress-test(1)
    defconfi
    nonuma
    nosmp
    bigsmp (NR_CPUS=1024, 1024 possible, 8 real)

Other configs built:

    arm-default
    i386-default
    i386-single
    i386-smp
    ppc-pmac32
    ppc-smp
    sparc64-default
    sparc64-smp
    x86_64-8psmp
    x86_64-debug
    x86_64-default
    x86_64-numa
    x86_64-single
    x86_64-allmodconfig
    x86_64-allyesconfig
    x86_64-maxsmp (NR_CPUS=4096 MAXNODES=512)

Configs not built due to prior errors:

    ia64-sn2
    ia64-default
    ia64-nosmp
    ia64-zx1
    s390-default
    sparc-default

Memory effects using x86_64-maxsmp

    Removes 1MB from permanant data adding 440 bytes to percpu area.

4k-cpus-before                      4k-cpus-after
   3463036 .bss                         -98304 -2%
   6067456 .data.cacheline_alig       -1048576 -17%
     48712 .data.percpu                   +440 +0%
  14275505 .text                          +336 +0%

  14275505 Text                           +336 +0%
   8521495 Data                           -336 +0%
   3463036 Bss                          -98304 -2%
  10974520 OtherData                  -1048576 -9%
     48712 PerCpu                         +440 +0%
  39275796 Total                      -1146104 -2%

-- 
