Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZA2Jvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZA2Jvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZA2Jvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:51:37 -0500
Received: from gw.goop.org ([64.81.55.164]:54580 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZA2Jvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:51:37 -0500
Message-ID: <49817C26.2020503@goop.org>
Date: Thu, 29 Jan 2009 01:51:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 0 of 7] x86/paravirt: optimise pvop calls and register
 use
References: <patchbomb.1233182100@abulafia.goop.org> <49815764.6040809@kernel.org>
In-Reply-To: <49815764.6040809@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> The failing configuration was x86-64 "make allyesconfig".
>
> 	-hpa
>   
Subject: x86/paravirt: fix missing callee-save call on pud_val

Fix missed convertion to using callee-saved calls for pud_val, which
causes a compile error when CONFIG_PARAVIRT_DEBUG is enabled.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
diff -r 452b0aa6f629 arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h	Wed Jan 28 14:18:52 2009 -0800
+++ b/arch/x86/include/asm/paravirt.h	Thu Jan 29 01:49:37 2009 -0800
@@ -1321,11 +1321,11 @@
 	pudval_t ret;
 
 	if (sizeof(pudval_t) > sizeof(long))
-		ret =  PVOP_CALL2(pudval_t, pv_mmu_ops.pud_val,
-				  pud.pud, (u64)pud.pud >> 32);
+		ret =  PVOP_CALLEE2(pudval_t, pv_mmu_ops.pud_val,
+				    pud.pud, (u64)pud.pud >> 32);
 	else
-		ret =  PVOP_CALL1(pudval_t, pv_mmu_ops.pud_val,
-				  pud.pud);
+		ret =  PVOP_CALLEE1(pudval_t, pv_mmu_ops.pud_val,
+				    pud.pud);
 
 	return ret;
 }


