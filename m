Return-Path: <linux-kernel-owner+w=401wt.eu-S1763087AbXFRLmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763087AbXFRLmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761640AbXFRLmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:42:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:24302 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761571AbXFRLmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:42:31 -0400
Date: Mon, 18 Jun 2007 13:42:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Denis Cheng <crquan@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: the memset operation on a automatic array variable can be removed
 by data Initialization
In-Reply-To: <467637b0.16be600a.377c.ffff8c04@mx.google.com>
Message-ID: <Pine.LNX.4.64.0706181341070.5731@fbirervta.pbzchgretzou.qr>
References: <467637b0.16be600a.377c.ffff8c04@mx.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 18 2007 00:43, Denis Cheng wrote:
>Subject: the memset operation on a automatic array variable can be removed by
>    data Initialization
>
>--- arch/x86_64/mm/init.c	2007-06-07 10:08:04.000000000 +0800
>+++ /tmp/init.c	2007-06-18 14:43:15.000000000 +0800
>@@ -406,8 +406,7 @@ void __cpuinit zap_low_mappings(int cpu)
> #ifndef CONFIG_NUMA
> void __init paging_init(void)
> {
>-	unsigned long max_zone_pfns[MAX_NR_ZONES];
>-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
>+	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0, };

The cost is the same. "= {0}" is transformed into a bunch of movs,
or a rep mov, (At least for x86), so is equivalent to memset (which
will get transformed to __builtin_memset anyway). So I wonder
what this really buys.

And, you do not even need the zero. Just write
	...[MAX_NR_ZONES] = {};

> 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
> 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
> 	max_zone_pfns[ZONE_NORMAL] = end_pfn;


	Jan
-- 
