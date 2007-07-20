Return-Path: <linux-kernel-owner+w=401wt.eu-S936597AbXGTRCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936597AbXGTRCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933142AbXGTRBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:01:18 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:5546 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932644AbXGTRBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:01:14 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Fri, 20 Jul 2007 19:00:49 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [patches] [PATCH] [17/58] i386: Add L3 cache support to AMD
 CPUID4 emulation
Message-ID: <20070720170049.GA5995@alberich.amd.com>
References: <200707191154.642492000@suse.de>
 <20070719095502.1718214E0B@wotan.suse.de>
MIME-Version: 1.0
In-Reply-To: <20070719095502.1718214E0B@wotan.suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 20 Jul 2007 17:00:49.0083 (UTC)
 FILETIME=[859A60B0:01C7CAEF]
X-WSS-ID: 6ABE35C90X82129957-05-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 11:55:02AM +0200, Andi Kleen wrote:
> 
> With that an L3 cache is correctly reported in the cache information in /sys
> 
> With fixes from Andreas Herrmann and Dean Gaudet
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/i386/kernel/cpu/intel_cacheinfo.c |   74 ++++++++++++++++++++++++---------
>  arch/x86_64/kernel/setup.c             |    7 ++-
>  2 files changed, 60 insertions(+), 21 deletions(-)

Reporting of L3 cache information should also be enabled in 32bit mode.


Regards,

Andreas
--

Enable reporting of L3 cache info in 32 bit mode for family 0x10.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

diff --git a/arch/i386/kernel/cpu/amd.c b/arch/i386/kernel/cpu/amd.c
index 6f47eee..815a5f0 100644
--- a/arch/i386/kernel/cpu/amd.c
+++ b/arch/i386/kernel/cpu/amd.c
@@ -272,8 +272,12 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
-	if (cpuid_eax(0x80000000) >= 0x80000006)
-		num_cache_leaves = 3;
+	if (cpuid_eax(0x80000000) >= 0x80000006) {
+		if ((c->x86 == 0x10) && (cpuid_edx(0x80000006) & 0xf000))
+			num_cache_leaves = 4;
+		else
+			num_cache_leaves = 3;
+	}
 
 	if (amd_apic_timer_broken())
 		set_bit(X86_FEATURE_LAPIC_TIMER_BROKEN, c->x86_capability);



