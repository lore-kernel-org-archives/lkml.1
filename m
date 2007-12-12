Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbXLLP5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbXLLP5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbXLLP45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:56:57 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2775 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbXLLP44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:56:56 -0500
Date: Wed, 12 Dec 2007 10:55:15 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Andi Kleen <ak@suse.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ben Woodard <woodard@redhat.com>,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071212155515.GA29735@hmsendeavour.rdu.redhat.com>
References: <20071211034349.GA3635@localhost.localdomain> <m1ejdt25x0.fsf@ebiederm.dsl.xmission.com> <20071211143910.GA10999@hmsreliant.think-freely.org> <m1ve75z1v3.fsf@ebiederm.dsl.xmission.com> <20071211182254.GB10999@hmsreliant.think-freely.org> <m1ejdtysqd.fsf@ebiederm.dsl.xmission.com> <20071211192434.GD10999@hmsreliant.think-freely.org> <86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com> <20071211205955.GF10999@hmsreliant.think-freely.org> <20071212142132.GC4889@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212142132.GC4889@bingen.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 03:21:32PM +0100, Andi Kleen wrote:
> > +	htcfg = read_pci_config(num, slot, func, 0x68);
> > +	if (htcfg & (1 << 18)) {	
> > +		printk(KERN_INFO "Detected use of extended apic ids on hypertransport bus\n");
> > +		if ((htcfg & (1 << 17)) == 0) {
> > +			printk(KERN_INFO "Enabling hypertransport extended apic interrupt broadcast\n");
> > +			printk(KERN_INFO "Note this is a bios bug, please contact your hw vendor\n");
> 
> I'm not convinced the message is correct. e.g. on a system with only a dual core not enabling
> that is fine, but the extended IDs might be still set.
> 
I'm not sure that would be fine.  In the situation you describe, not setting
this bit means the second core won't receive interrupts.  If we crash on that
core and boot the kdump kernel with it, we get exactly the same problem that we
currently see.


> >  #endif /* CONFIG_ACPI */
> >  
> > -static void __init nvidia_bugs(void)
> > +static void __init nvidia_bugs(int num, int slot, int func)
> >  {
> > +	static int fix_applied = 0;
> > +
> > +	if (fix_applied++)
> > +		return;
> 
> This looks like the wrong place to do this. Better add a flag or something
> in the structure. Dito others.
> 
I suppose I can, but I'm not sure what benefit that provides.  Can you
elaborate?


> Also while not a problem here in general it's bad style to add potential
> wrapping bugs like this. Never use ++ for flags.
> 
I can fix that up.  I'll hold off though until ben redoes all his testing.  He
mentioned earlier this morning, that some of the results he was getting may have
been caused by a kexec utility bug.  He's re-confirming that this patch solves
the reported problem.  Once he does, I'll repost.

Thanks & Regards
Neil

> -Andi

-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
