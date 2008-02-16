Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYBPI5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYBPI5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 03:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYBPI5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 03:57:48 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:13791 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbYBPI5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 03:57:46 -0500
Date: Sat, 16 Feb 2008 00:54:54 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080216085454.GA24570@ca-server1.us.oracle.com>
Mail-Followup-To: Jeremy Fitzhardinge <jeremy@goop.org>,
	Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mika Penttila <mika.penttila@kolumbus.fi>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org> <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org> <20080215202336.GE26034@mail.oracle.com> <47B64E0A.1020007@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47B64E0A.1020007@goop.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 01:44:26PM +1100, Jeremy Fitzhardinge wrote:
> Joel Becker wrote:
>
>> (XEN) mm.c:1825:d109 Bad type (saw 0000000028000001 != exp 
>> 00000000e0000000) for mfn 3a2f0f (pfn f0)
>> (XEN) mm.c:649:d109 Error getting mfn 3a2f0f (pfn f0) from L1 entry 
>> 00000003a2f0f063 for dom109
>> (XEN) mm.c:1825:d109 Bad type (saw 0000000028000001 != exp 
>> 00000000e0000000) for mfn 3a2f0f (pfn f0)
>> (XEN) mm.c:649:d109 Error getting mfn 3a2f0f (pfn f0) from L1 entry 
>> 00000003a2f0f063 for dom109
>> (XEN) mm.c:3331:d109 ptwr_emulate: could not get_page_from_l1e()
>>   
>
> Hm, I have a suspicion about what this might be.  I'll haven't tried 
> reproducing it yet though.
>
>> (XEN) Unhandled page fault in domain 109 on VCPU 0 (ec=0003)
>> (XEN) Pagetable walk from 00000000c01687f0:
>> (XEN)  L4[0x000] = 00000003a2933027 00000000000006cc
>> (XEN)  L3[0x003] = 000000039afea027 0000000000000005
>> (XEN)  L2[0x000] = 000000039bfb7067 0000000000001048 (XEN)  L1[0x168] = 
>> 00000003a2e97061 0000000000000168
>> (XEN) domain_crash_sync called from entry.S
>> (XEN) Domain 109 (vcpu#0) crashed on cpu#2:
>> (XEN) ----[ Xen-3.1.3-rc3  x86_64  debug=n  Not tainted ]----
>> (XEN) CPU:    2
>> (XEN) RIP:    e019:[<00000000c04040bd>]
>>   
>
> What does this EIP correspond to in your kernel?  Also:
>
> c01687f0 c0417ab6 c040288f c040299a c0403270
>
> (as guesses of potential callers to try and work out a stack trace).

	ksymoops is no help at all, but I got these from objdump of
vmlinux:

c04040bd xen_set_pte
c0417ab6 set_pte_present
c040288f set_bit
c040299a __raw_spin_unlock
c0403270 __set_64bit

Joel

-- 

Dort wo man Bücher verbrennt, verbrennt man am Ende auch Mensch.
(Wherever they burn books, they will also end up burning people.)
	- Heinrich Heine

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
