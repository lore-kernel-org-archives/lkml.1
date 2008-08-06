Return-Path: <linux-kernel-owner+w=401wt.eu-S1763378AbYHFLKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763378AbYHFLKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbYHFLKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:10:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:54046 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661AbYHFLKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=x5YLV5VHdLMEx5trA4HMcNcu6ip2li/KoOy6CX7CxZ8ipOkWzTGKpOd42C4K94AK9u
         sgIgkvfFN6L92+vYjsHWRejr933yHiUNczTIiImh5/h5EZvC53fYphOtyA6kCkxZhiq5
         7M75kn4Dv1MEfGlkYUx+CIApEilIZrjuq002o=
Date: Wed, 6 Aug 2008 19:09:53 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: David Miller <davem@davemloft.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Message-ID: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Aug 6, 2008 at 5:42 PM, Jeff Chua <jeff.chua.linux@gmail.com> 
wrote:
>>> CONFIG_X86_GENERICARCH=y
>>> CONFIG_X86_BIGSMP=y
>>> 8 more cpu need bigsmp mode.

> Just found it under " Subarchitecture Type (Generic architecture)",
> and then it shows the CONFIG_X86_BIGSMP option.

It works. Booted with 16CPUs. 32GB RAM.

CPU0 L7345 1.86GHz  0C
CPU1 L7345 1.86GHz  0C
CPU2 L7345 1.86GHz  0C
CPU3 L7345 1.86GHz  0C
CPU4 L7345 1.86GHz  0C
CPU5 L7345 1.86GHz  0C
CPU6 L7345 1.86GHz  0C
CPU7 L7345 1.86GHz  0C
CPU8 L7345 1.86GHz  0C
CPU9 L7345 1.86GHz  0C
CPU10 L7345 1.86GHz  0C
CPU11 L7345 1.86GHz  0C
CPU12 L7345 1.86GHz  0C
CPU13 L7345 1.86GHz  0C
CPU14 L7345 1.86GHz  0C
CPU15 L7345 1.86GHz  0C


So, but setting the config not obvious. And should CONFIG_X86_PC be 
considered as well as CONFIG_X86_GENERICARCH?

With CONFIG_X86_PC, I can set CONFIG_SPARSEMEM=y.

With CONFIG_X86_GENERICARCH, CONFIG_SPARSEMEM depends on CONFIG_NUMA.

I'm using the patch below to enable sparsemem instead of flatmem, but 
don't know what impact it has. System booted and running.

It would be nice to automatically default CONFIG_X86_BIGSMP with CPUs > 8. 
But I don't know to do that.


Thanks,
Jeff.


--- linux/arch/x86/Kconfig.org	2008-08-06 18:41:08 +0800
+++ linux/arch/x86/Kconfig	2008-08-06 18:48:13 +0800
@@ -1035,7 +1035,7 @@

   config ARCH_FLATMEM_ENABLE
   	def_bool y
-	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC && !NUMA
+	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && !NUMA

   config ARCH_DISCONTIGMEM_ENABLE
   	def_bool y
@@ -1051,7 +1051,7 @@

   config ARCH_SPARSEMEM_ENABLE
   	def_bool y
-	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC)
+	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC) || X86_GENERICARCH
   	select SPARSEMEM_STATIC if X86_32
   	select SPARSEMEM_VMEMMAP_ENABLE if X86_64

