Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbYFZBHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbYFZBHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbYFZBBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:2779 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733AbYFZBBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=sJFhelYmTbRrHqHCI0k0pPunRQ7TGP4CGabFDIcz221xQdOSjQdw4HIQq0UIuCa92Q
         kwdYefsSAFjH3F3Iq5+HKuGCJY0tIm/fe8eUKJrT7MT1IcJBmuvH3cVbMSfuzdjTjR+7
         Y9BwXdCUgyd2FpbBfhoOwoRu9yS431UdTD3bk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 16/16] x86: we only have init_pg_tables_end for 32bit
Date: Wed, 25 Jun 2008 18:02:06 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251802.06185.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>


---
 arch/x86/kernel/setup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -120,12 +120,6 @@ struct boot_params __initdata boot_param
 struct boot_params boot_params;
 #endif
 
-/* This value is set up by the early boot code to point to the value
-   immediately after the boot time page tables.  It contains a *physical*
-   address, and must not be in the .bss segment! */
-unsigned long init_pg_tables_start __initdata = ~0UL;
-unsigned long init_pg_tables_end __initdata = ~0UL;
-
 /*
  * Machine setup..
  */
@@ -152,6 +146,12 @@ static struct resource bss_resource = {
 
 
 #ifdef CONFIG_X86_32
+/* This value is set up by the early boot code to point to the value
+   immediately after the boot time page tables.  It contains a *physical*
+   address, and must not be in the .bss segment! */
+unsigned long init_pg_tables_start __initdata = ~0UL;
+unsigned long init_pg_tables_end __initdata = ~0UL;
+
 static struct resource video_ram_resource = {
 	.name	= "Video RAM area",
 	.start	= 0xa0000,
