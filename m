Return-Path: <linux-kernel-owner+w=401wt.eu-S1764746AbXGaPPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764746AbXGaPPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759129AbXGaPP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:15:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:18180 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760344AbXGaPP0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:15:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,204,1183359600"; 
   d="scan'208";a="256907237"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Time Problems with 2.6.23-rc1-gf695baf2
Date: Tue, 31 Jul 2007 08:15:21 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5013588F6@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070731145456.GB25175@alice>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Time Problems with 2.6.23-rc1-gf695baf2
Thread-Index: AcfTgsVivCZXO9kFSvWgOjR6Lb0J+wAApLFQ
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Eric Sesterhenn / Snakebyte" <snakebyte@gmx.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: "Len Brown" <lenb@kernel.org>, <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       <linux-acpi@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 31 Jul 2007 15:15:25.0015 (UTC) FILETIME=[9EB56E70:01C7D385]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Eric Sesterhenn / Snakebyte [mailto:snakebyte@gmx.de] 
>Sent: Tuesday, July 31, 2007 7:55 AM
>To: Michal Piotrowski
>Cc: Eric Sesterhenn / Snakebyte; Len Brown; 
>linux-kernel@vger.kernel.org; IDE/ATA development list; 
>Bartlomiej Zolnierkiewicz; linux-acpi@vger.kernel.org; Ingo 
>Molnar; Thomas Gleixner; Pallipadi, Venkatesh
>Subject: Re: Time Problems with 2.6.23-rc1-gf695baf2
>
>* Michal Piotrowski (michal.k.k.piotrowski@gmail.com) wrote:
>> Hi Eric,
>> 
>> On 26/07/07, Eric Sesterhenn / Snakebyte <snakebyte@gmx.de> wrote:
>> > * Len Brown (lenb@kernel.org) wrote:
>> > > > > > > [   13.506890] ACPI Exception 
>(processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
>> > > > > > > [   13.507101] ACPI Exception 
>(processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
>> > >
>> > > Note that these are just noise -- new code being verbose 
>when looking for an optional feature.
>> > >
>> > > The fact that hitting the power button a bunch of times
>> > > to make the system move along suggests some sort of 
>missing interrupt problem --
>> > > most likely the timer itself.
>> > >
>> > > [   13.868574] Probing IDE interface ide0...
>> > > [  387.279576] Clocksource tsc unstable (delta = 370195339890 ns)
>> > >
>> > > 5-minutes -- a long probe:-)
>> > >
>> > > > CONFIG_NO_HZ=y
>> > >
>> > > does CONFIG_NO_HZ=n make a difference?
>> >
>> > [   41.007654] EXT3 FS on hda1, internal journal
>> > [  322.133656] Clocksource tsc unstable (delta = 276476174785 ns)
>> > Boot went fine but the system got pretty unresponsive 
>later, 2-3 seconds
>> > delay after keypresses on an idle system and a hang during 
>shutdown which i had to resolve by
>> > pressing the power button (not to switch it of the hard 
>way, but to keep it rebooting)
>> >
>> > > > CONFIG_HIGH_RES_TIMERS=y
>> > >
>> > > does CONFIG_HIGH_RES_TIMERS=n make a difference?
>> >
>> > doesnt change anything
>> >
>> > > does "irqpoll" make any difference?
>> > > does "notsc" make any difference?
>> > > does "idle=poll" make any difference?
>> >
>> > I tried these with the HIGH_RES_TIMERS=n, irqpoll and 
>notsc dont change
>> > a thing, idle=poll makes it boot normally
>> 
>> Please use git-bisect
>> 
>> git-bisect start
>> git-bisect bad
>> git-bisect good 7dcca30a32aadb0520417521b0c44f42d09fe05c
>
>
>took some time, but i got a scape goat, added venkatesh to the CC list,
>

Eric,

This means things should work fine with processor.max_cstate=2 boot
option
as well. Can you please double check that.

Also, please send in the acpidump from your system.

Thanks,
Venki 
