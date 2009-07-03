Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZGCI32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZGCI32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZGCI3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:29:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54542 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbZGCI3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:29:13 -0400
Date: Fri, 3 Jul 2009 10:29:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Gleb Natapov <gleb@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH v5] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090703082905.GF21833@elte.hu>
References: <20090701133007.GC27539@redhat.com> <1246482017.27006.10670.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246482017.27006.10670.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Wed, 2009-07-01 at 06:30 -0700, Gleb Natapov wrote:
> > KVM would like to provide x2APIC interface to a guest without emulating
> > interrupt remapping device. The reason KVM prefers guest to use x2APIC
> > is that x2APIC interface is better virtualizable and provides better
> > performance than mmio xAPIC interface:
> >     
> > - msr exits are faster than mmio (no page table walk, emulation)
> > - no need to read back ICR to look at the busy bit
> > - one 64 bit ICR write instead of two 32 bit writes
> > - shared code with the Hyper-V paravirt interface
> >     
> > Included patch changes x2APIC enabling logic to enable it even if IR
> > initialization failed, but kernel runs under KVM and no apic id is
> > greater than 255 (if there is one spec requires BIOS to move to x2apic
> > mode before starting an OS).
> > 
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

Now, since this affects core x86 APIC code non-trivially so should 
submitted to and go via the x86 tree. (Can prepare a special branch 
with just this change if KVM tree wants/needs to pull it before 
v2.6.32.)

	Ingo
