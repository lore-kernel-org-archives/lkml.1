Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbXKTWQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbXKTWQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757025AbXKTWQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:16:32 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:54854 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbXKTWQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:16:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=li1fWzXRhgsLez2QKRpykmoNoH2ALMQMkedkSY9KQAx8XIdXgpY89IYb67yR8NQN7rV762LKwE9E2DCyF+e8hZmd04ccaA5/iH1PxPHaIImv9H5rdD71EOC+oUSOk/GLl8d1vuMkj1hEp6TCS77WP4hwLscmfm+yWAOhiNiYIHo=
Message-ID: <d00698fb0711201416n30b54d26kd8d5887896d3da83@mail.gmail.com>
Date: Tue, 20 Nov 2007 23:16:29 +0100
From: noah <noah123@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Possibly SATA related freeze killed networking and RAID
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
In-Reply-To: <20071120220512.46b9e975@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com>
	 <20071120220512.46b9e975@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/20, Alan Cox <alan@lxorguk.ukuu.org.uk>:
> >  kernel: [734344.717844] irq 21: nobody cared (try booting with the
> > "irqpoll" option)
> >  kernel: [734344.717866]
>
> Your machine decided to emit interrupt 21 without an apparent reason.
> Whatever caused that made the kernel shut down IRQ 21 at which point the
> disk drives on that IRQ were no longer being serviced. Everything on IRQ
> 21 would have died - which may be why your networking failed too.
>
> What do you have on IRQ 21 and is this a one off ?

I've had other freezes before but this was the first time I was able
to see what was actually going on.
IRQ 21 appears to be shared between sata_nv and ethernet.

Does this mean my hardware/BIOS is broken somehow?
I'm running the latest BIOS available.

# cat /proc/interrupts            CPU0       CPU1
  0:      26497    3603163   IO-APIC-edge      timer
  1:          0          2   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
 9:          0          0   IO-APIC-fasteoi   acpi
 12:          0          6   IO-APIC-edge      i8042
 16:       4851     669159   IO-APIC-fasteoi   shpchp, libata
 20:          0          0   IO-APIC-fasteoi   sata_nv
 21:      36443    4775430   IO-APIC-fasteoi   sata_nv, eth0
 22:      31261    4531218   IO-APIC-fasteoi   ohci_hcd:usb1, sata_nv
 23:          4       1649   IO-APIC-fasteoi   HDA Intel, ehci_hcd:usb2
NMI:          0          0
LOC:    3629562    3629543
ERR:          0

  -- noah
