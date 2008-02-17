Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbYBQGb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbYBQGb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 01:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYBQGbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 01:31:20 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:52738 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbYBQGbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 01:31:19 -0500
Date: Sat, 16 Feb 2008 22:29:58 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080217062958.GC26206@mail.oracle.com>
Mail-Followup-To: Jeremy Fitzhardinge <jeremy@goop.org>,
	Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mika Penttila <mika.penttila@kolumbus.fi>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org> <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org> <20080215202336.GE26034@mail.oracle.com> <47B64E0A.1020007@goop.org> <20080216085454.GA24570@ca-server1.us.oracle.com> <47B6CD0F.4020202@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B6CD0F.4020202@goop.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 10:46:23PM +1100, Jeremy Fitzhardinge wrote:
> Joel Becker wrote:
>> 	ksymoops is no help at all, but I got these from objdump of
>> vmlinux:
>>
>> c04040bd xen_set_pte
>> c0417ab6 set_pte_present
>> c040288f set_bit
>> c040299a __raw_spin_unlock
>> c0403270 __set_64bit
>
> (My usual technique is use "gdb vmlinux" and "x/i 0x...." to do the  
> lookup.) 

	Thanks for the tip!

> Unfortunately that doesn't narrow down what the kernel was actually  
> trying to do at the time.  Clearly a set_pte; looks like someone is  
> trying to create a writable mapping of an existing pte page.
>
> Does "console=hvc0 earlyprintk=xen" on the kernel command line give any  
> clue about how far it gets before crashing?

	Console is already hvc0, but earlyprintk gets us:

--8<-----------------------------------------------------------------
Reserving virtual address space above 0xf57fe000
Linux version 2.6.25-rc2-bisectme (jlbec@ca-build23.us.oracle.com) (gcc
version 4.1.2 20070626 (Red Hat 4.1.2-14)) #21 SMP Fri Feb 15 16:28:35
PST 2008
ACPI in unprivileged domain disabled
BIOS-provided physical RAM map:
 Xen: 0000000000000000 - 0000000078000000 (usable)
console [xenboot0] enabled
1192MB HIGHMEM available.
727MB LOWMEM available.
Started domain ca-test58
                        Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
NX (Execute Disable) protection: active
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   186366
  HighMem    186366 ->   491520
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   491520
-->8-----------------------------------------------------------------

That's it.

Joel

-- 

"The nearest approach to immortality on Earth is a government
 bureau."
	- James F. Byrnes

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
