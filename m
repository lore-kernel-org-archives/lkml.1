Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbXAWDLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbXAWDLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 22:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbXAWDLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 22:11:49 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2060 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932715AbXAWDLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 22:11:48 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jeff.chua.linux@gmail.com (Jeff Chua)
Subject: Re: Linux v2.6.20-rc5
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org, akpm@osdl.org
Organization: Core
In-Reply-To: <Pine.LNX.4.64.0701131404520.22948@boston.corp.fedex.com>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1H9C4X-0006aD-00@gondolin.me.apana.org.au>
Date: Tue, 23 Jan 2007 14:11:45 +1100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> 
> 
> From: Jeff Chua <jchua@fedex.com>
> 
>>   CC [M]  drivers/kvm/vmx.o
>> {standard input}: Assembler messages:
>> {standard input}:3257: Error: bad register name `%sil'
>> make[2]: *** [drivers/kvm/vmx.o] Error 1
>> make[1]: *** [drivers/kvm] Error 2
>> make: *** [drivers] Error 2
> 
> I'm not using the kernel profiler, so here's a patch to make it work without 
> CONFIG_PROFILING.

Actually that only happens to work by chance (by making one of al/bl/cl/dl
available).  This patch should fix it properly.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index ce219e3..0aa2659 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1824,7 +1824,7 @@ again:
 #endif
 		"setbe %0 \n\t"
 		"popf \n\t"
-	      : "=g" (fail)
+	      : "=q" (fail)
 	      : "r"(vcpu->launched), "d"((unsigned long)HOST_RSP),
 		"c"(vcpu),
 		[rax]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RAX])),
