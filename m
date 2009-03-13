Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZCMBp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZCMBp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZCMBpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:45:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:46362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZCMBpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:45:47 -0400
Message-ID: <49B9BA98.1080508@kernel.org>
Date: Thu, 12 Mar 2009 18:44:56 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: print out mtrr_range_state when user specify size
References: <49B87BE7.3040809@kernel.org> <20090313014052.GB6178@elte.hu>
In-Reply-To: <20090313014052.GB6178@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: print more info

so keep it consistent with autodetect version

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/mtrr/main.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -1424,6 +1424,8 @@ static int __init mtrr_cleanup(unsigned
 
 		if (!result[i].bad) {
 			set_var_mtrr_all(address_bits);
+			printk(KERN_DEBUG "New variable MTRRs\n");
+			print_out_mtrr_range_state();
 			return 1;
 		}
 		printk(KERN_INFO "invalid mtrr_gran_size or mtrr_chunk_size, "
