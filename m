Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbZF3J0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbZF3J0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZF3J0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:26:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56248 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZF3J0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:26:22 -0400
Date: Tue, 30 Jun 2009 12:26:23 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090630092623.GI20289@redhat.com>
References: <20090629132926.GB20289@redhat.com> <m1ocs6axca.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ocs6axca.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 02:24:05AM -0700, Eric W. Biederman wrote:
> Gleb Natapov <gleb@redhat.com> writes:
> 
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
> 
> 
> How common is hotplug hardware in kvm?  In particular hotplug cpus?
> 
It works for Linux guests.

> To support that seriously you need interrupt remapping.
> 
Can you explain why?

--
			Gleb.
