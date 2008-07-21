Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYGUIkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYGUIkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbYGUIjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:39:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:51283 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbYGUIjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=m3jxPwyY9oqYdAo9h7Qex+CLxPUcL9fvyAcT748b+reF7IFz3GM0KAmFbmB1rZe/64
         +XSdxCG/3u9afv3+lTtDG0A9NstmolxFGUqGD8iP5qnUb0X9EagCPSkcsxCIEAzs/Cgr
         C5P8IeKeq3GwHv3T21JgRHujfohIo/H5bU0sI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: remove extra calling to get ext cpuid level
Date: Mon, 21 Jul 2008 01:39:03 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807210138.15054.yhlu.kernel@gmail.com>
In-Reply-To: <200807210138.15054.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807210139.03635.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/common_64.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6/arch/x86/kernel/cpu/common_64.c
@@ -303,7 +303,6 @@ static void __cpuinit early_identify_cpu
 			c->x86_capability[2] = cpuid_edx(0x80860001);
 	}
 
-	c->extended_cpuid_level = cpuid_eax(0x80000000);
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
