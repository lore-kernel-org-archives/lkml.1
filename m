Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbZFSHwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbZFSHwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZFSHwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:52:13 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15073 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbZFSHwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:52:12 -0400
Message-Id: <4A3B5FCD0200007800006AC0@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 19 Jun 2009 08:52:13 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Len Brown" <lenb@kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs
	 justbecause there's no local APIC
References: <4A329CF8.4050502@goop.org>
 <alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
 <4A3A9220.4070807@goop.org> <m1zlc5jqac.fsf@fess.ebiederm.org>
 <4A3A99FB.7070807@goop.org> <m1vdmtgtt2.fsf@fess.ebiederm.org>
 <4A3AC0C4.6060508@goop.org>
 <86802c440906182232r31088e4fh3613a8da6f8903f7@mail.gmail.com>
In-Reply-To: <86802c440906182232r31088e4fh3613a8da6f8903f7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Yinghai Lu <yhlu.kernel@gmail.com> 19.06.09 07:32 >>>
>doesn't XEN support per cpu irq vector?

No.

>got sth from XEN 3.3 / SLES 11
>
>igb 0000:81:00.0: PCI INT A -> GSI 95 (level, low) -> IRQ 95
>igb 0000:81:00.0: setting latency timer to 64
>igb 0000:81:00.0: Intel(R) Gigabit Ethernet Network Connection
>igb 0000:81:00.0: eth9: (PCIe:2.5Gb/s:Width x4) 00:21:28:3a:d8:0e
>igb 0000:81:00.0: eth9: PBA No: ffffff-0ff
>igb 0000:81:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
>vendor=8086 device=3420
>(XEN) irq.c:847: dom0: invalid pirq 94 or vector -28
>igb 0000:81:00.1: PCI INT B -> GSI 94 (level, low) -> IRQ 94
>igb 0000:81:00.1: setting latency timer to 64
>(XEN) physdev.c:87: dom0: map irq with wrong vector -28
>map irq failed
>(XEN) physdev.c:87: dom0: map irq with wrong vector -28
>map irq failed
>
>the system need a lot of MSI-X normally.. with current mainline tree
>kernel, it will need about 360 irq...

Do you mean 360 connected devices, or just 360 IO-APIC pins (most of
which are usually unused)? In the latter case, devices using MSI (i.e. not
using high numbered IO-APIC pins) should work, while devices connected
to IO-APIC pins numbered 256 and higher won't work in SLE11 as-is.
This limitation got fixed recently in the 3.5-unstable tree, though. The
256 active vectors limit, however, continues to exist, so the former case
would still not be supported by Xen.

Jan

