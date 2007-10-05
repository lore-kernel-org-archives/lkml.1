Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbXJES3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbXJES3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 14:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbXJES3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 14:29:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:53503 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbXJES3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 14:29:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,233,1188802800"; 
   d="scan'208";a="229789551"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: nmi_watchdog fix for x86_64 to be more like i386
Date: Thu, 4 Oct 2007 21:37:41 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F501797305@scsmsx415.amr.corp.intel.com>
In-Reply-To: <alpine.LFD.0.9999.0710020815370.3348@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: nmi_watchdog fix for x86_64 to be more like i386
Thread-Index: AcgEvS7xuZ/Z+t6UQHCQQzCYfj0NmwCIixbg
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com> <200710020007.09864.ak@suse.de> <alpine.LFD.0.9999.0710020043450.20478@localhost.localdomain> <200710020751.42994.ak@suse.de> <alpine.LFD.0.9999.0710020815370.3348@localhost.localdomain>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Andi Kleen" <ak@suse.de>
Cc: "Arjan van de Ven" <arjan@infradead.org>, "David Bahi" <dbahi@novell.com>,
       "LKML" <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Gregory Haskins" <GHaskins@novell.com>
X-OriginalArrivalTime: 05 Oct 2007 04:37:43.0003 (UTC) FILETIME=[78093AB0:01C80709]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
>Thomas Gleixner
>Sent: Monday, October 01, 2007 11:19 PM
>To: Andi Kleen
>Cc: Arjan van de Ven; David Bahi; LKML; 
>linux-rt-users@vger.kernel.org; Andrew Morton; Ingo Molnar; 
>Gregory Haskins
>Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
>
>>
>> The only workaround for chipsets ignoring IRQ affinity would 
>be to keep
>> track on which CPU irq 0 happens and then restart APIC timer 
>interrupts
>> on the others (or send IPIs) as needed. But that would be 
>fairly ugly.
>
>The clock events code does handle this already. The broadcast 
>interrupt 
>can come in on any cpu. It's just the nmi watchdog which would 
>be affected 
>by that.
>

Probably we can workaround this by keeping track of IRQ0 count at percpu
level and
use local apic timer + this percpu counter in NMI. Or just increment
local
apic timer count in IRQ0 with nohz enabled.

Thanks,
Venki
