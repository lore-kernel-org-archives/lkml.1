Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbXF3J1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbXF3J1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbXF3J1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:27:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:55381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbXF3J1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:27:12 -0400
From: Andi Kleen <ak@suse.de>
To: linux@horizon.com
Subject: Re: 2.6.22-rcX Transmeta/APM regression
Date: Sat, 30 Jun 2007 11:26:40 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       bk@suse.de, hpa@zytor.com, michal.k.k.piotrowski@gmail.com
References: <20070630030343.31711.qmail@science.horizon.com>
In-Reply-To: <20070630030343.31711.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706301126.41179.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 June 2007 05:03, linux@horizon.com wrote:

> Anyway, the patch which introduces the problem is the aptly named 3ebad:
> 3ebad59056: [PATCH] x86: Save and restore the fixed-range MTRRs of the BSP
> when suspending
>
> 2.6.22-rc6 plus that one commit reverted successfully does APM suspend
> (and resume) for me.

Mr.Linux, Does that patch fix it? 

-Andi

i386: Check if CPU has MTRRs before trying to save them

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/main.c
+++ linux/arch/i386/kernel/cpu/mtrr/main.c
@@ -734,8 +734,11 @@ void mtrr_ap_init(void)
  */
 void mtrr_save_state(void)
 {
-	int cpu = get_cpu();
+	int cpu;
 
+	if (!cpu_has_mtrr)
+		return;
+	cpu  = get_cpu();
 	if (cpu == 0)
 		mtrr_save_fixed_ranges(NULL);
 	else


