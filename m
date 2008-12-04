Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYLDMWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYLDMWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLDMWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:22:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50535 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYLDMWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:22:30 -0500
Date: Thu, 4 Dec 2008 13:33:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: 2.6.28-rc6: early panic with boot option "nosmp"
Message-ID: <20081204123335.GP6703@one.firstfloor.org>
References: <20081204022806.GA29293@localhost> <20081204101343.GO6703@one.firstfloor.org> <20081204120214.GA30833@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204120214.GA30833@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The exception raised on dereferencing mpf or mpf_found.

This obvious patch should fix it then. Does it?

--

Fix early exception in __get_smp_config with nosmp

Bail out early when there is no MP table.

Reported by Wu Fengguang
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/mpparse.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.28-rc4-test/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.28-rc4-test.orig/arch/x86/kernel/mpparse.c	2008-10-24 13:34:40.000000000 +0200
+++ linux-2.6.28-rc4-test/arch/x86/kernel/mpparse.c	2008-12-04 13:20:34.000000000 +0100
@@ -604,6 +604,9 @@
 		printk(KERN_INFO "Using ACPI for processor (LAPIC) "
 		       "configuration information\n");
 
+	if (!mpf)
+		return;
+
 	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
 	       mpf->mpf_specification);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)

