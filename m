Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYCUJQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYCUJQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYCUJQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:16:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56974 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbYCUJQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:16:05 -0400
Date: Fri, 21 Mar 2008 10:15:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       shai@scalex86.org
Subject: Re: [patch 4/4] x86: apic_is_clustered_box to indicate unsynched
	TSC's on multiboard vSMP systems
Message-ID: <20080321091542.GE20420@elte.hu>
References: <20080320073740.GA9414@localdomain> <20080320074508.GE9414@localdomain> <86802c440803200053m1b0928a9q6567d8c619fa7a2f@mail.gmail.com> <20080320190240.GB6085@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320190240.GB6085@localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> >>  -       if (!is_vsmp_box() && (boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
> >>  +       if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !is_vsmp_box())
> >>                 return 0;

> Yes.  The first call is to state that TSC's are synced if it is an AMD 
> box and if it is _not_ a vSMPowered box (for the apic id lifting case 
> on Sun boxes), the second call is for _any_ vSMPowered system with 
> more than one board -- TSC's are not guaranteed to be synched in that 
> case.  Both these calls are needed.

i suspect there are two questions here: firstly, your change only flips 
the condition around which should not have any effect _normally_. But 
the thing is that is_vsmp_box() has side-effects: it reads the PCI 
config space and sets a flag. It would be cleaner if there was a 
separate, explicit detect_vsmp_box() call early during bootup which did 
the PCI config space access, and is_vsmp_box() would only return the 
current state of the vsmp flag. Then your above change would be 
unnecessary.

	Ingo
