Return-Path: <linux-kernel-owner+w=401wt.eu-S1761026AbYEEW75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbYEEW75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760697AbYEEW6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:58:49 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:27765 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760638AbYEEW6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=H699UZ58ZQQMY53AWDCKgEQmkY4n9OI0UK4Cn/2GssgqnLalE/En0wkdLgBJ8FfQVEHcJrdYyrhoNJjbPkshHKkq/EIMB0YVIJPC46mWE/SQlRmVwmDizYRucpGudL91QJXvV7dYaQ3ZqiaC90JqlfqAPwoSHV2UhODvfVFoFw4=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: process fam 10h like k8 with fixed mtrr setting
Date: Mon, 5 May 2008 15:57:38 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051557.38556.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


otherwise fixed MTRR for family 10h may not be changed

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
@@ -342,7 +342,7 @@ static void set_fixed_range(int msr, boo
 
 	if (lo != msrwords[0] || hi != msrwords[1]) {
 		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-		    boot_cpu_data.x86 == 15 &&
+		    (boot_cpu_data.x86 >= 0x0f && boot_cpu_data.x86 <= 0x11) &&
 		    ((msrwords[0] | msrwords[1]) & K8_MTRR_RDMEM_WRMEM_MASK))
 			k8_enable_fixed_iorrs();
 		mtrr_wrmsr(msr, msrwords[0], msrwords[1]);
