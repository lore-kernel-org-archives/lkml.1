Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYC1SFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYC1SFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbYC1SFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:05:34 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4939 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257AbYC1SFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:05:33 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: tg3 bad performance, lots of hardware interrupts
From: "Michael Chan" <mchan@broadcom.com>
To: "Harald Hannelius" <harald@iki.fi>
cc: "Jiri Kosina" <jkosina@suse.cz>, "David Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0803281931060.5286@penti.org>
References: <alpine.DEB.1.00.0803271532570.30549@penti.org>
 <20080327.144925.196529669.davem@davemloft.net>
 <1206666100.5368.6.camel@dell>
 <alpine.DEB.1.00.0803281440460.23558@penti.org>
 <1206726560.6866.5.camel@dell>
 <Pine.LNX.4.64.0803281811420.32241@twin.jikos.cz>
 <alpine.DEB.1.00.0803281931060.5286@penti.org>
Date: Fri, 28 Mar 2008 11:06:51 -0800
Message-ID: <1206731211.6866.13.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6BF3ECEA60W18560861-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 19:37 +0200, Harald Hannelius wrote:
> # cat /proc/interrupts
>             CPU0       CPU1
>    0:        111          1   IO-APIC-edge      timer
>    1:          0          2   IO-APIC-edge      i8042
>    2:          0          0    XT-PIC-XT        cascade
>    5:          0          0   IO-APIC-fasteoi   sata_nv
>    7:        856         51   IO-APIC-fasteoi   ohci_hcd:usb2
>   10:          0          3   IO-APIC-fasteoi   sata_nv, ehci_hcd:usb1
>   11:       4305          7   IO-APIC-fasteoi   sata_nv
>   12:          0          4   IO-APIC-edge      i8042
> 216:       4217     128932   PCI-MSI-edge      eth2
> 217:     161107     685351   PCI-MSI-edge      eth0
> NMI:          0          0   Non-maskable interrupts
> LOC:    2380762    2619917   Local timer interrupts
> RES:       3000       3269   Rescheduling interrupts
> CAL:         16         31   function call interrupts
> TLB:         64        111   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> SPU:          0          0   Spurious interrupts
> ERR:          1
> MIS:          0
> 
> Well, shared or not, yes and no. I think that /proc/interrupts
> contains 
> soft-interrupts. The problem child is interface eth2.
> 
> As rapported by ifconfig the interface is on IRQ 5:

eth2 is using MSI.  When using MSI, the IRQ reported by ifconfig is not
accurate.  You said you have tried booting with nomsi, but have you
confirmed that by checking /proc/interrupts?

> 
> # ifconfig eth2
> eth2      Link encap:Ethernet  HWaddr 00:10:18:30:E6:D6
>            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>            RX packets:196898 errors:0 dropped:0 overruns:0 frame:0
>            TX packets:19 errors:0 dropped:0 overruns:0 carrier:0
>            collisions:0 txqueuelen:1000
>            RX bytes:69887991 (66.6 MiB)  TX bytes:1216 (1.1 KiB)
>            Interrupt:5
> 

