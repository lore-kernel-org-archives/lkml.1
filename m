Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZFCVuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZFCVuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZFCVut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:50:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40932 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbZFCVut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:50:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13306] hibernate slow on _second_ run
Date: Wed, 3 Jun 2009 23:51:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <200906032305.07551.rjw@sisk.pl> <1244064315.22576.5.camel@johannes.local>
In-Reply-To: <1244064315.22576.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906032351.01900.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 June 2009, Johannes Berg wrote:
> [can you please turn off html email?]

Yes, sorry.  I didn't notice that my mailer sneakily started to add HTML
"alternative" to every message.

> > Can you please send me /proc/interrupts from the affected box?
> 
> $ cat /proc/interrupts 
>             CPU0       CPU1       
>    0:    1820687          0   IO-APIC-edge      timer
>    7:          1          0   IO-APIC-edge    
>    9:      38721          0   IO-APIC-fasteoi   acpi
>   16:        940          0   IO-APIC-fasteoi   HDA Intel
>   17:        517          0   IO-APIC-fasteoi   ohci_hcd:usb4
>   18:     289829          0   IO-APIC-fasteoi   ohci_hcd:usb3
>   19:    2035671          0   IO-APIC-fasteoi   ehci_hcd:usb2
>   20:         32          0   IO-APIC-fasteoi   ehci_hcd:usb1
>   25:     515569          0   PCI-MSI-edge      ahci
>   26:          0          0   PCI-MSI-edge      eth0
>  NMI:          0          0   Non-maskable interrupts
>  LOC:     152936     638337   Local timer interrupts
>  SPU:          0          0   Spurious interrupts
>  RES:     317238     581858   Rescheduling interrupts
>  CAL:         43        128   Function call interrupts
>  TLB:      60645      53553   TLB shootdowns
>  TRM:          0          0   Thermal event interrupts
>  THR:          0          0   Threshold APIC interrupts
>  ERR:          1
>  MIS:          0

Hmm.  The patch shouldn't matter for this box, except for one thing:
check_irq_resend() on resume.  Interesting.

Rafael
