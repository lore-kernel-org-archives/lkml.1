Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYH1OlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYH1OlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYH1OlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:41:08 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4216 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYH1OlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:41:07 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=07d9gI8wAAAA:8 a=DIIWZhNXA0nf1txHZe4A:9 a=EC4-vNYawUcFDPTog3cA:7 a=YENXGYfKsouC-YCHort9EoGbZT4A:4 a=_BtMs80tEfEA:10 a=g_Ufyo-v_YoA:10
Message-ID: <48B6B904.5070302@shaw.ca>
Date: Thu, 28 Aug 2008 08:41:08 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "Robert M. Stockmann" <stock@stokkie.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: libata, Sound on same IRQ : flaky sound
References: <fa.t59JCw5e/IAg/3vXyG2sheD1AnE@ifi.uio.no>
In-Reply-To: <fa.t59JCw5e/IAg/3vXyG2sheD1AnE@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert M. Stockmann wrote:
> Hi,
> 
> I have a couple of AMD64 machines with onboard sound devices running 
> and they all have one thing in common : flaky sound when one is 
> doing some heavy disk I/O on the SATA disks. Interesting enough 
> /proc/interrupts shows that libata is using the same IRQ as the sound 
> devices :
> 
> model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
> stepping        : 3
> cpu MHz         : 3014.679
> cache size      : 1024 KB
> 
> # cat /proc/interrupts 
>            CPU0       CPU1       
>   0:      55869  154467838    IO-APIC-edge  timer
>   8:          0          0    IO-APIC-edge  rtc
>   9:          0          0   IO-APIC-level  acpi
>  16:       1453     499686   IO-APIC-level  libata, NVidia CK8S
>  17:          0          0   IO-APIC-level  ehci_hcd:usb1
>  18:      27633   69978987   IO-APIC-level  eth0
> NMI:      10718      12112 
> LOC:  154533874  154533852 
> ERR:          0
> MIS:          0
> 
> model name      : AMD Opteron(tm) Processor 246
> stepping        : 10
> cpu MHz         : 1991.355
> cache size      : 1024 KB
> 
> # cat /proc/interrupts 
>            CPU0       CPU1       
>   0:      18108   19856365    IO-APIC-edge  timer
>   1:         16       7915    IO-APIC-edge  i8042
>   3:          0         56    IO-APIC-edge  serial
>   4:          0         56    IO-APIC-edge  serial
>   8:          0          0    IO-APIC-edge  rtc
>   9:          0          0   IO-APIC-level  acpi
>  12:        346      62269    IO-APIC-edge  i8042
>  14:          0        190    IO-APIC-edge  ide0
>  15:          1        189    IO-APIC-edge  ide1
>  16:        827     358917   IO-APIC-level  libata, AMD AMD8111
>  17:          0         18   IO-APIC-level  ohci_hcd:usb1, ohci_hcd:usb2
>  18:        555     231470   IO-APIC-level  HiSax, nvidia
>  19:      15179    3489796   IO-APIC-level  eth0
> NMI:        211        511 
> LOC:   19871720   19871628 
> ERR:          0
> MIS:          0
> 
> Kernel is 2.6.15,
> 
> Preemption Model is (Preemptible Kernel (Low-Latency Desktop)), Memory 
> model is (Flat Memory), [*] Preempt The Big Kernel Lock is switched on. 
> Timer frequency is (1000 HZ) or (100 HZ), but changing this value is 
> of no influence. One of the machines is a genuine dual Opteron machine
> but i'm rather disappointed with the NUMA capabilities of
> the 2.6.15 kernel. It does do NUMA, but thats all it does, it doesn't
> add anything compared to a SMP kernel with NUMA switched off.
> 
> Does one really need the PREEMPT_RT approach to get rock solid
> sound as described here ? :
> 
> "A realtime preemption overview"
>  by Paul McKenney, August 10, 2005
> http://lwn.net/Articles/146861/
> 
> How about giving your sound device a proper seperate IRQ number?
> At least libata should like eth0 have its own kernel resources.

That's an issue with the way the motherboard IRQ lines are wired. 
There's nothing the kernel can do about it.

Normally I wouldn't expect that to make a big difference though..

You'd really have to try a newer kernel first in order to get much help, 
though. That's a pretty ancient kernel. Quite likely the situation is 
improved in newer versions.

> 
> Regards,
> 
> Robert
> PS. please also cc: to my email address.

