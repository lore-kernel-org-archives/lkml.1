Return-Path: <linux-kernel-owner+w=401wt.eu-S933784AbYA3VW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbYA3VW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932744AbYA3VRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:17:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:53289 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932746AbYA3VRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:17:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,280,1199692800"; 
   d="scan'208";a="510723071"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Date: Wed, 30 Jan 2008 13:15:21 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC758076@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080130205915.GA4562@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Thread-Index: AchjgwwT+Vd3uaCjRc2frc6p5ctgqAAAQNgA
References: <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <47A0CD4B.5040706@sgi.com> <1FE6DD409037234FAB833C420AA843EC757F12@orsmsx424.amr.corp.intel.com> <20080130194616.GA19426@elte.hu> <1FE6DD409037234FAB833C420AA843EC757F7C@orsmsx424.amr.corp.intel.com> <20080130200221.GA28073@elte.hu> <1FE6DD409037234FAB833C420AA843EC757FC2@orsmsx424.amr.corp.intel.com> <20080130205915.GA4562@elte.hu>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Mike Travis" <travis@sgi.com>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       <linux-ia64@vger.kernel.org>, <sparclinux@vger.kernel.org>
X-OriginalArrivalTime: 30 Jan 2008 21:15:23.0370 (UTC) FILETIME=[39ED1CA0:01C86385]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this i believe builds an implicit dependency between the mca_asm.o 
> position within the image and the ia64_mca_data percpu variable it 
> accesses - it relies on the immediate 22 addressing mode that has 4MB of 
> scope. Per chance, the .config you sent creates a 14MB image, and the 
> percpu variables moved too far away for the linker to be able to fulfill 
> this constraint.

Sounds very plausible.

> The workaround is to define PER_CPU_ATTRIBUTES to link percpu variables 
> back into the .percpu section on UP too - which ia64 links specially 
> into its vmlinux.lds. But ultimately i think the better solution would 
> be to remove this dependency between arch/ia64/kernel/mca_asm.S and the 
> position of the percpu data.

Yup.  That fixes the build ... the resulting binary doesn't boot though :-(
I just realized that it has been a while since I tried booting a UP
kernel ... so the problem may be unrelated bitrot elsewhere.

Overall you are right that the mca_asm.S code should not be dependent on
the relative location of the data objects.

I'll start digging on why this doesn't boot ... but you might as well
send the fixes so far upstream to Linus so that the SMP fix is available
(which is all anyone really cares about ... there are very, very few
UP ia64 systems in existence).

Acked-by: Tony Luck <tony.luck@intel.com>


-Tony
