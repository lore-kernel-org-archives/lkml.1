Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbZEKPgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbZEKPgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZEKPgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:36:33 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:32138 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbZEKPgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:36:32 -0400
X-BigFish: VPS-26(zz1432R98dR1805M936fJzz1202hzzz32i6bh67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0KJHKOJ-01-CSR-01
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD SVM
Date: Mon, 11 May 2009 10:36:25 -0500
Message-ID: <6453C3CB8E2B3646B0D020C1126132730362094B@sausexmb4.amd.com>
In-Reply-To: <4A084426.2080604@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD SVM
Thread-Index: AcnSTU8/0AhPSOtQR1yY0p89WoaIQgAAGZIg
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <4A02FECC.6060609@redhat.com> <20090511141503.GC6175@elte.hu> <4A083539.407@redhat.com> <20090511143320.GE6175@elte.hu> <4A083B69.6010702@redhat.com> <20090511145903.GB737@elte.hu> <4A08405E.3070709@redhat.com> <20090511151823.GC9492@elte.hu> <4A084426.2080604@redhat.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Avi Kivity" <avi@redhat.com>, "Ingo Molnar" <mingo@elte.hu>
CC: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Roedel, Joerg" <Joerg.Roedel@amd.com>, <kvm@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 May 2009 15:36:26.0499 (UTC) FILETIME=[3F1E1D30:01C9D24E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ingo Molnar wrote:
> > * Avi Kivity <avi@redhat.com> wrote:
> >
> >   
> >>> I.e. the 3000 cycles value itself could be eliminated as well. 
> >>> (with just a common-sense max of say 100,000 cycles enforced)
> >>>       
> >> Yeah, though that has a much smaller effect as it's only 
> >> responsible for a few microseconds of spinning.
> >>     
> >
> > 3000 cycles would be 1-2 usecs. Isnt the VM exit+entry cost 
> > still in that range?

For the processors that support this feature, VM exit+entry is
a little over 2000 cycles.
> 
> It's 3000 executions of rep nop, so you need to account for 
> the entire 
> spinlock loop body.
> 
> The Linux spinlock is
> 
>              "1:\t"
>              "cmpl %0, %2\n\t"
>              "je 2f\n\t"
>              "rep ; nop\n\t"
>              "movzwl %1, %2\n\t"
>              /* don't need lfence here, because loads are in-order */
>              "jmp 1b\n"
> 
> 5 instructions, maybe 2-3 cycles, not counting any special rep nop 
> overhead.  Mark, any idea what the spin time is?

If I'm understanding the question right, the contested
spin locks are being held for 5K to 10K iterations of PAUSE.
So 10K to 30K cycles if your estimate of the spinlock
cycle time is correct.  

-Mark Langsdorf
Operating System Research Center
AMD

