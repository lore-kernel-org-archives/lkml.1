Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZEWQxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZEWQxl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZEWQxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:53:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:57883 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbZEWQxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=D6eiDadIDcDLTyiiXqMRPGcsvK41CS3I9H25Ub0xAFensVLhzYVJf8PZf2dVrL3FI5
         f+cUtuswv2VNfUGEZEv0WhztYVYR4npzgmWshtFO8t3B1UMCdfMJwLEh0goQTHPgrN3p
         PY1AU/tNFY455PgHNZUYe6i/eItGIIbxOuI50=
Message-ID: <4A182A08.9050305@googlemail.com>
Date: Sat, 23 May 2009 18:53:28 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: David Dillow <dave@thedillows.org>
CC: Michael Buesch <mb@bu3sch.de>, Francois Romieu <romieu@fr.zoreil.com>,
       Rui Santos <rsantos@grupopie.com>,
       =?ISO-8859-15?Q?Michael_B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
References: <200903041828.49972.m.bueker@berlin.de>	 <4A0C7443.1010000@googlemail.com>	 <1243042174.3580.23.camel@obelisk.thedillows.org>	 <200905231124.28925.mb@bu3sch.de>  <4A1809B0.3030109@googlemail.com>	 <1243090308.4217.6.camel@obelisk.thedillows.org>	 <4A182066.9030201@googlemail.com> <1243097173.4217.7.camel@obelisk.thedillows.org>
In-Reply-To: <1243097173.4217.7.camel@obelisk.thedillows.org>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



David Dillow wrote:
> On Sat, 2009-05-23 at 18:12 +0200, Michael Riepe wrote:
> 
>>If I use two connections (iperf -P2) and nail iperf to both threads of a
>>single core with taskset (the program is multi-threaded, just in case
>>you wonder), I get this:
>>
>>CPU 0+2:  0.0-60.0 sec  4.65 GBytes    665 Mbits/sec
>>CPU 1+3:  0.0-60.0 sec  6.43 GBytes    920 Mbits/sec
>>
>>That's quite a difference, isn't it?
>>
>>Now I wonder what CPU 0 is doing...
> 
> 
> Where does /proc/interrupts say the irqs are going?

Oh well...

           CPU0       CPU1       CPU2       CPU3
  0:         66          0          0          0   IO-APIC-edge      timer
  1:          2          0          0          0   IO-APIC-edge      i8042
  7:          0          0          0          0   IO-APIC-edge
parport0
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          4          0          0          0   IO-APIC-edge      i8042
 14:          0          0          0          0   IO-APIC-edge
ata_piix
 15:          0          0          0          0   IO-APIC-edge
ata_piix
 16:          0          0          0          0   IO-APIC-fasteoi
uhci_hcd:usb4
 18:          0          0          0          0   IO-APIC-fasteoi
uhci_hcd:usb3
 19:       9696          0          0          0   IO-APIC-fasteoi
ata_piix, uhci_hcd:usb2
 22:        471          0          0          0   IO-APIC-fasteoi   HDA
Intel
 23:        100          0          0          0   IO-APIC-fasteoi
uhci_hcd:usb1, ehci_hcd:usb5
 27:   48463995          0          0          0   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:     460965     294620     324902     358771   Local timer interrupts
RES:      30111     286150     113295     268387   Rescheduling interrupts
CAL:       1140       1143         52         34   Function call interrupts
TLB:       2223        952       1184       2573   TLB shootdowns
SPU:          0          0          0          0   Spurious interrupts
ERR:          0
MIS:          0


-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
