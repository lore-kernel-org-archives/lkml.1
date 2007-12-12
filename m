Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbXLLU0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbXLLU0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXLLU0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:26:25 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3561 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbXLLU0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:26:24 -0500
Date: Wed, 12 Dec 2007 15:22:15 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       hbabu@us.ibm.com, Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071212202215.GB29735@hmsendeavour.rdu.redhat.com>
References: <m1ve75z1v3.fsf@ebiederm.dsl.xmission.com> <20071211182254.GB10999@hmsreliant.think-freely.org> <m1ejdtysqd.fsf@ebiederm.dsl.xmission.com> <20071211192434.GD10999@hmsreliant.think-freely.org> <86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com> <20071211205955.GF10999@hmsreliant.think-freely.org> <20071212142132.GC4889@bingen.suse.de> <20071212155515.GA29735@hmsendeavour.rdu.redhat.com> <20071212160722.GD4889@bingen.suse.de> <m1prxbu2ah.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1prxbu2ah.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 12:43:34PM -0700, Eric W. Biederman wrote:
> Andi Kleen <ak@suse.de> writes:
> >
> > It could enable the extended APIC IDs but not use them? 
> 
> In which case complaining is still correct (the BIOS was out of sync),
> enabling bit 17 is still correct and we are just in overkill mode.
> 
> > Anyways I haven't got docs on that NV bridge so I might be wrong.
> 
> This has everything to do with how AMD coherent hypertransport works and
> little if anything to do with how the NV bridge operated.
> 
> Basically the NV bridge seems to be sending a standard hypertransport
> x86 legacy interrupt packet (that doesn't have any target information)
> and when that packet  hits the coherent hypertransport domain it isn't
> being converted into whatever would send it to all cpus. 
> 
> .....
> 
> The real practical problem is if somehow the BIOS goofs up this way
> and it then decides to ask us to boot on one of these cpus with
> an extended apic id.  We will hang in calibrate_delay.  So far
> this only seems to happen in the kdump case but in theory the BIOS
> could be completely crazy.
> 


I think this just leaves us with deciding on a mechanism for how to do
single-application quirks.  I take Andi's point that adding a flag set to the
quirk data structure is a fine solution, but I'm really ok with static integers
in individual functions.  Do we have consensus on how to handle that?  I'm happy
either way, but I'd rather have agreement on how to handle it before I post
another iteration of this patch.  

Thanks & Regards
Neil

> Eric

-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
