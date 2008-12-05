Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbYLEMro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbYLEMro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYLEMrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:47:36 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:23198 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbYLEMrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:47:36 -0500
Message-ID: <493922E1.4050501@msgid.tls.msk.ru>
Date: Fri, 05 Dec 2008 15:47:29 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [trivial] fix missing space in printk
References: <4939139C.8090806@msgid.tls.msk.ru> <20081205121046.GA28662@elte.hu>
In-Reply-To: <20081205121046.GA28662@elte.hu>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------090100080007080905010901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090100080007080905010901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> * Michael Tokarev <mjt@tls.msk.ru> wrote:
> 
>> Just come across this when booting on an old hw.. Looks somewhat ugly, 
>> that single missing space ;)
>>
>> And oh,
>>
>> Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>
>>
>> ;)
> 
> applied to tip/x86/cleanups.
> 
>> --- a/arch/x86/kernel/smpboot.c	2008-10-10 02:13:53.000000000 +0400
>> +++ b/arch/x86/kernel/smpboot.c	2008-12-05 14:39:29.608353301 +0300
>> @@ -1084,7 +1084,7 @@ static int __init smp_sanity_check(unsig
>>  #endif
>>  
>>  	if (!physid_isset(hard_smp_processor_id(), phys_cpu_present_map)) {
>> -		printk(KERN_WARNING "weird, boot CPU (#%d) not listed"
>> +		printk(KERN_WARNING "weird, boot CPU (#%d) not listed "
>>  				    "by the BIOS.\n", hard_smp_processor_id());
> 
> btw., the reason for that bug was the incorrect line break in the middle 
> of a string - we humans just dont notice a missing space in that context. 
> 
> So in the final commit i've moved the string to a single line, see it 
> attached below.

Oh well.  Thanks.  There's another very similar thing in
arch/x86/kernel/pci-dma.c, via_no_dac() (attached).

By the way, where such tiny/trivial things should go?

Thanks!

/mjt

--------------090100080007080905010901
Content-Type: text/x-patch;
 name="viadac.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="viadac.diff"

--- a/arch/x86/kernel/pci-dma.c	2008-10-10 02:13:53 +0400
+++ b/arch/x86/kernel/pci-dma.c	2008-12-05 15:45:56 +0300
@@ -409,8 +409,8 @@ fs_initcall(pci_iommu_init);
 static __devinit void via_no_dac(struct pci_dev *dev)
 {
 	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
-		printk(KERN_INFO "PCI: VIA PCI bridge detected."
-				 "Disabling DAC.\n");
+		printk(KERN_INFO
+			"PCI: VIA PCI bridge detected. Disabling DAC.\n");
 		forbid_dac = 1;
 	}
 }

--------------090100080007080905010901--
