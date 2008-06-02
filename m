Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYFBJKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYFBJKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYFBJKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:10:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYFBJKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:10:02 -0400
Date: Mon, 2 Jun 2008 11:09:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Add PCI extended config space access for AMD
	Barcelona
Message-ID: <20080602090947.GA22060@elte.hu>
References: <20080526180616.GB2752@erda.amd.com> <20080528165813.8D8E5814C@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528165813.8D8E5814C@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> This patch implements PCI extended configuration space access for 
> AMD's Barcelona CPUs. It extends the method using CF8/CFC IO 
> addresses. An x86 capability bit has been introduced that is set for 
> CPUs supporting PCI extended config space accesses.

applied to -tip for more testing, thanks Robert. It needed some porting 
(64-bit setup code got restructured in -tip) and the trivial build fix 
below.

	Ingo

------------->
commit fe8aef82b5040c39fb3bee28047db5c896421382
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jun 2 10:54:16 2008 +0200

    fix build bug in "x86: add PCI extended config space access for AMD Barcelona"
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-x86/mmconfig.h b/include/asm-x86/mmconfig.h
index 95beda0..46d6bb1 100644
--- a/include/asm-x86/mmconfig.h
+++ b/include/asm-x86/mmconfig.h
@@ -9,4 +9,6 @@ static inline void fam10h_check_enable_mmcfg(void) { }
 static inline void check_enable_amd_mmconf_dmi(void) { }
 #endif
 
+extern void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c);
+
 #endif
