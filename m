Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYGDM41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYGDM41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYGDM4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:56:19 -0400
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:1203 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbYGDM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:56:18 -0400
Subject: [PATCH] x86: cacheline_align tss_struct
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <20080703113925.GA5594@elte.hu>
References: <1215082049.3026.15.camel@castor.localdomain>
	 <20080703113925.GA5594@elte.hu>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 13:56:16 +0100
Message-Id: <1215176176.3144.5.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The manual padding to align on cacheline size only worked in 32 bit
In 64 bit the structure was not aligned and contained wasted space.
    
use the compiler ____cachline_aligned to save space & properly align
this structure.
    
x86_64_default size goes from 9136 -> 8960
x86_64_AMD     size goes from 9136 -> 8896
    
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---

Hi Ingo
here's the patch.
built & running on 2.6.26-rc8.

Richard



diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 5591052..4ab2ede 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -263,15 +263,11 @@ struct tss_struct {
 	struct thread_struct	*io_bitmap_owner;
 
 	/*
-	 * Pad the TSS to be cacheline-aligned (size is 0x100):
-	 */
-	unsigned long		__cacheline_filler[35];
-	/*
 	 * .. and then another 0x100 bytes for the emergency kernel stack:
 	 */
 	unsigned long		stack[64];
 
-} __attribute__((packed));
+} ____cacheline_aligned;
 
 DECLARE_PER_CPU(struct tss_struct, init_tss);
 


