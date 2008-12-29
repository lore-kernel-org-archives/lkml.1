Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYL2Vvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYL2Vvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYL2Vv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:51:26 -0500
Received: from mga12.intel.com ([143.182.124.36]:51832 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754399AbYL2VvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:51:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,297,1228118400"; 
   d="scan'208";a="94870842"
Message-ID: <4959466F.5030205@linux.intel.com>
Date: Mon, 29 Dec 2008 22:51:43 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
References: <20081227155019.GA15493@elte.hu>
In-Reply-To: <20081227155019.GA15493@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------090305060501090001080505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090305060501090001080505
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:

> today i (belatedly ...) started looking into the status of the tip/x86/mce 
> branch, and merged it into tip/master as a first step.
> 
> firstly there's a small complication, it triggers this crash with the 
> attached config:
> 

I tested the config on a couple of different systems. Unfortunately I
wasn't able to reproduce the problem. It booted always fine even on multiple
tries.

I had to adapt the configuration slightly to boot in my setup.

The configuration also was not complete, i had
to press return a few times (are you sure you sent me the correct file?)

One merging issue I noted is that you put the perfctrs and mce self
on the same vector. The attached patch fixes that.

-Andi




--------------090305060501090001080505
Content-Type: text/plain;
 name="mce-merge"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mce-merge"

commit c736d118dcad93929dfc21cb72f33bc94c1b314a
Author: Andi Kleen <ak@linux.intel.com>
Date:   Sun Dec 28 14:16:43 2008 +0100

    Avoid conflict of apic error and local perfmon vector
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 73957a2..0fcb682 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -88,7 +88,7 @@
 /*
  * Performance monitoring interrupt vector:
  */
-#define LOCAL_PERF_VECTOR	0xee
+#define LOCAL_PERF_VECTOR	0xed
 
 /*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we

--------------090305060501090001080505--
