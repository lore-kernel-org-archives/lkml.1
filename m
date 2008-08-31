Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbYHaSC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbYHaSC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 14:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYHaSCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 14:02:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:4466 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbYHaSCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 14:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YemJr0sKTuRiZEMJzITObCjbutZQT1x19hsGt4fUi9hmuSu8fE5PENjUyTV6b8maYO
         nkiv22+482zSN+IyRXrahmb1WpcASTbo9ybP+UTeDy7bJUffJKGOU0Uu8nlJpZvk9wv7
         ETN5Isl4zl4Lo+bgco+RG7Ukoqv9GwMDjJN/c=
Message-ID: <86802c440808311102jffbaa48n4c5b46d8a9ba1d0@mail.gmail.com>
Date: Sun, 31 Aug 2008 11:02:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Tobias Diedrich" <ranma+kernel@tdiedrich.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [Bug #11358] net: forcedeth call restore mac addr in nv_shutdown path
In-Reply-To: <20080831130904.GA4070@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
	 <N8SeMoDzuxC.A.nFF.0ibuIB@albercik>
	 <20080831084135.GA2698@yamamaya.is-a-geek.org>
	 <20080831130904.GA4070@yamamaya.is-a-geek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 6:09 AM, Tobias Diedrich
<ranma+kernel@tdiedrich.de> wrote:
> Tobias Diedrich wrote:
>> I got around to try kexec and found that on 2.6.27-rc5, without
>> Yinghai Lu's patch, when I kexec while forecdeth is loaded I get the
>> following when the new kernel tries to load the module (on my Asus
>> M2N-SLI Deluxe):
>>
>> |Aug 31 10:10:42 melchior kernel: [   10.578053] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
>> |Aug 31 10:10:42 melchior kernel: [   10.578256] forcedeth 0000:00:08.0: BAR 0: error updating (0xfe02a000 != 0x000000)
>> |Aug 31 10:10:42 melchior kernel: [   10.580901] forcedeth 0000:00:08.0: enabling device (0000 -> 0003)
>> |Aug 31 10:10:42 melchior kernel: [   10.581405] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
>> |Aug 31 10:10:42 melchior kernel: [   10.581509] forcedeth 0000:00:08.0: PCI INT A -> Link[APCH] -> GSI 22 (level, low) -> IRQ 22
>> |Aug 31 10:10:42 melchior kernel: [   10.581699] forcedeth 0000:00:08.0: setting latency timer to 64
>> |Aug 31 10:10:42 melchior kernel: [   10.581748] forcedeth 0000:00:08.0: Invalid Mac address detected: ff:ff:ff:ff:ff:ff
>> |Aug 31 10:10:42 melchior kernel: [   10.581936] forcedeth 0000:00:08.0: Please complain to your hardware vendor. Switching to a random MAC.
>> |Aug 31 10:10:42 melchior kernel: [   15.981960] forcedeth 0000:00:08.0: open: Could not find a valid PHY.
>> |Aug 31 10:10:42 melchior kernel: [   15.982131] forcedeth 0000:00:08.0: PCI INT A disabled
>> |Aug 31 10:10:42 melchior kernel: [   15.982283] forcedeth: probe of 0000:00:08.0 failed with error -12
>> |Aug 31 10:10:42 melchior kernel: [   16.017545] forcedeth 0000:00:09.0: BAR 0: error updating (0xfe027000 != 0x000000)
>> |Aug 31 10:10:42 melchior kernel: [   16.017766] forcedeth 0000:00:09.0: enabling device (0000 -> 0003)
>> |Aug 31 10:10:42 melchior kernel: [   16.018720] ACPI: PCI Interrupt Link [AMC1] enabled at IRQ 21
>> |Aug 31 10:10:42 melchior kernel: [   16.018839] forcedeth 0000:00:09.0: PCI INT A -> Link[AMC1] -> GSI 21 (level, low) -> IRQ 21
>> |Aug 31 10:10:42 melchior kernel: [   16.019050] forcedeth 0000:00:09.0: setting latency timer to 64
>> |Aug 31 10:10:42 melchior kernel: [   16.019129] forcedeth 0000:00:09.0: Invalid Mac address detected: ff:ff:ff:ff:ff:ff
>> |Aug 31 10:10:42 melchior kernel: [   16.019339] forcedeth 0000:00:09.0: Please complain to your hardware vendor. Switching to a random MAC.
>> |Aug 31 10:10:42 melchior kernel: [   21.399400] forcedeth 0000:00:09.0: open: Could not find a valid PHY.
>> |Aug 31 10:10:42 melchior kernel: [   21.399572] forcedeth 0000:00:09.0: PCI INT A disabled
>> |Aug 31 10:10:42 melchior kernel: [   21.399723] forcedeth: probe of 0000:00:09.0 failed with error -12
>>
>> If I rmmod forcedeth before kexec, it loads fine later.
> [...]
>> Maybe also calling nv_restore_phy() and/or pci_release_regions() in
>> the shutdown hook would help.
>>
>> TODO:
>> Try with the patch, maybe try nv_restore_phy, test if WOL is
>> affected by the patch.
>
> I just tried with the patch and both options above in the shutdown
> path and the kexec'd kernel still had the same problems as above.
>
> Interestingly the message comes from drivers/pci/setup-res.c, where
> it updates the BAR register and reads it back to make sure it was
> updated and somehow reads back zeroes?
>
> I wonder what's going on there, that should never happen AFAIK...
> Maybe the pci device was not properly reenabled, but OTOH when I
> just rmmod before kexec it seems to work and nv_remove also calls
> pci_disable_device()...

in addition to this patch, you may need another patch from Rafael...,
that one fix the MSI...etc,

YH
