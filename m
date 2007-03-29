Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbXC2OyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbXC2OyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 10:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbXC2OyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 10:54:06 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:37318 "EHLO
	outbound4-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756AbXC2OyE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 10:54:04 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] i386: add command line option
 "local_apic_timer_c2_ok"
Date: Thu, 29 Mar 2007 09:53:44 -0500
Message-ID: <1449F58C868D8D4E9C72945771150BDFD967BB@SAUSEXMB1.amd.com>
In-Reply-To: <200703272218.50531.lenb@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] i386: add command line option
 "local_apic_timer_c2_ok"
Thread-Index: Acdw4K5k3dwjHLpeQ1GxtgxBTqoORABMHLMw
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703271430310.6730@woody.linux-foundation.org>
 <200703271816.33868.lenb@kernel.org>
 <200703272218.50531.lenb@kernel.org>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Len Brown" <lenb@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Morrow, William" <William.Morrow@amd.com>,
       "Crouse, Jordan" <jordan.crouse@ldcmail.amd.com>
cc: "Thomas Gleixner" <tglx@linutronix.de>, "Pavel Machek" <pavel@ucw.cz>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Mingming Cao" <cmm@us.ibm.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Sid Boyce" <g3vbv@blueyonder.co.uk>, "Nick Piggin" <npiggin@suse.de>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Renninger" <trenn@suse.de>
X-OriginalArrivalTime: 29 Mar 2007 14:53:45.0242 (UTC)
 FILETIME=[0CC2CFA0:01C77212]
X-WSS-ID: 6A150D733282582898-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > If we really care about using the LAPIC timer on systems with deeper
> > than C1 support, the only alternative seems to be to test
> > if it actually works or not at boot and run-time.
> > Otherwise, we wait for future hardware with guaranteed
> > not to break under any (BIOS) conditions ships, and check for that.
> > 
> > Based on what I read of the HP nx6325 where the LAPIC timer
> > is breaking C1, AMD is in the same boat.
> 
> The nx6325 (Turion 64 X2) exports only C1.
> I'm not sure how the conclusion was drawn that it has
> a broken lapic timer as reflected in the "nolapic_timer" patch:

If both cores goes into C1 at the same time, the chipset
can move the processor into a C3 like state called C1e.
 
> +               /*
> +                * BIOS exports only C1 state, but uses deeper power
> +                * modes behind the kernels back.
> +                */
> +                 .callback = lapic_check_broken_bios,
> +                 .ident = "HP nx6325",
> +                 .matches = {
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "HP 
> Compaq nx6325"),
> +                 },
> +        },
> 
> But if this is true, then I don't know how to determine on
> an AMD system if the LAPIC timer is guaranteed to work --
> even for systems with just C1.
> 
> Jordan, William, can you clarify?

For K7 and K8 through and including revision E, the LAPIC
timer is guaranteed to work in C1.

For K8 revisions F and G, and for upcoming family 0x10 and
0x11 parts, if either bit in MSRC001_0055[28:27] is set,
C1e is enabled and the LAPIC timer cannot be trusted in
C1.

AMD can craft a patch to sort this out as soon as we have
an idea what the framework is going to look like.

-Mark Langsdorf
Operating Systems Research Center
AMD, Inc.


