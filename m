Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbYBPCqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbYBPCqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 21:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYBPCqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 21:46:10 -0500
Received: from gw.goop.org ([64.81.55.164]:58116 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbYBPCqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 21:46:08 -0500
Message-ID: <47B64E0A.1020007@goop.org>
Date: Sat, 16 Feb 2008 13:44:26 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org> <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org> <20080215202336.GE26034@mail.oracle.com>
In-Reply-To: <20080215202336.GE26034@mail.oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Becker wrote:
> On Thu, Feb 14, 2008 at 06:50:52PM +1100, Jeremy Fitzhardinge wrote:
>   
>>> 	I'm seeing the same problem, with no messages at all from xen
>>> other than "domain crashed, restart disabled" in xend.log.  I got a
>>> different commit in my bisect, 0947b2f31ca1ea1211d3cde2dbd8fcec579ef395
>>> (i386 boot: replace boot_io    remap with enhanced bt_ioremap - enhance
>>> bt_ioremap).  I started from yesterday's
>>> 96b5a46e2a72dc1829370c87053e0cd558d58bc0 (WMI: initialize
>>> wmi_blocks.list even if ACPI is disabled) and a known good
>>> 9b73e76f3cf63379dcf45fcd4f112f5812418d0a (Merge
>>> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6).
>>>       
>> Is the domain ending up in the crashed state?  Do you get a register  
>> dump with xm dmesg?  That would be very useful in determining what went  
>> wrong.  You may need to compile Xen with debug=y in Config.mk.
>>     
>
> 	I didn't know xm dmesg existed :-)  Regarding debug=y, I'm using
> a prepackaged dom0 set.  Here's what I find in xm dmesg:
>
> Joel
>
> (XEN) mm.c:1825:d109 Bad type (saw 0000000028000001 != exp 00000000e0000000) for mfn 3a2f0f (pfn f0)
> (XEN) mm.c:649:d109 Error getting mfn 3a2f0f (pfn f0) from L1 entry 00000003a2f0f063 for dom109
> (XEN) mm.c:1825:d109 Bad type (saw 0000000028000001 != exp 00000000e0000000) for mfn 3a2f0f (pfn f0)
> (XEN) mm.c:649:d109 Error getting mfn 3a2f0f (pfn f0) from L1 entry 00000003a2f0f063 for dom109
> (XEN) mm.c:3331:d109 ptwr_emulate: could not get_page_from_l1e()
>   

Hm, I have a suspicion about what this might be.  I'll haven't tried 
reproducing it yet though.

> (XEN) Unhandled page fault in domain 109 on VCPU 0 (ec=0003)
> (XEN) Pagetable walk from 00000000c01687f0:
> (XEN)  L4[0x000] = 00000003a2933027 00000000000006cc
> (XEN)  L3[0x003] = 000000039afea027 0000000000000005
> (XEN)  L2[0x000] = 000000039bfb7067 0000000000001048 
> (XEN)  L1[0x168] = 00000003a2e97061 0000000000000168
> (XEN) domain_crash_sync called from entry.S
> (XEN) Domain 109 (vcpu#0) crashed on cpu#2:
> (XEN) ----[ Xen-3.1.3-rc3  x86_64  debug=n  Not tainted ]----
> (XEN) CPU:    2
> (XEN) RIP:    e019:[<00000000c04040bd>]
>   

What does this EIP correspond to in your kernel?  Also:

c01687f0 c0417ab6 c040288f c040299a c0403270

(as guesses of potential callers to try and work out a stack trace).

Thanks,
	J


