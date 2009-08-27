Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZH0Ise@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZH0Ise (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 04:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbZH0Isd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 04:48:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:65138 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZH0Isc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 04:48:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,284,1249282800"; 
   d="scan'208";a="487855965"
Subject: Re: acpi_ex_system_memory_space_handler oops
From: Lin Ming <ming.m.lin@intel.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090827082927.GD3536@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
	 <1250498613.28336.68.camel@minggr.sh.intel.com>
	 <20090817113059.GA3245@localdomain.by>
	 <d3f22a0908170622x7dd9ce73m5c3ea86406cc9935@mail.gmail.com>
	 <20090818071359.GA3713@localdomain.by>
	 <1250579915.13743.8.camel@minggr.sh.intel.com>
	 <20090827075253.GB3536@localdomain.by>
	 <1251359994.3282.11.camel@minggr.sh.intel.com>
	 <20090827082927.GD3536@localdomain.by>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 16:44:17 +0800
Message-Id: <1251362657.3282.19.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 16:29 +0800, Sergey Senozhatsky wrote:
> On (08/27/09 15:59), Lin Ming wrote:
> > > rc7-git5 (patched)
> > > 
> > > [    0.178628] ACPI: EC: Look up EC in DSDT
> > > [    0.196480] ACPI: Interpreter enabled
> > > [    0.196575] ACPI: (supports S0 S1 S3 S4 S5)
> > > [    0.197184] ACPI: Using IOAPIC for interrupt routing
> > > [    0.197352] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> > > [    0.203511] ACPI Error (dswload-0790): [PCFG] Namespace lookup failure, AE_ALREADY_EXISTS
> > > [    0.203738] ACPI Exception: AE_ALREADY_EXISTS, During name lookup/catalog 20090521 psloop-227
> > > [    0.203964] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.RBPE] (Node f7017678), AE_ALREADY_EXISTS
> > > [    0.204256] ACPI: Marking method RBPE as Serialized because of AE_ALREADY_EXISTS error
> > > [    0.204510] ACPI Error (psparse-0537): Method parse/execution failed [\_GPE._L01] (Node f701d198), AE_ALREADY_EXISTS
> > > [    0.204803] ACPI: Marking method _L01 as Serialized because of AE_ALREADY_EXISTS error
> > > [    0.205063] ACPI Exception: AE_ALREADY_EXISTS, while evaluating GPE method [_L01] 20090521 evgpe-568
> > 
> > Do you mean rc7-git5 sometime boot fails even with the patch applied?
> >
> No. Patched kernel boots ok. Even successfully booted kernel sometimes has the given lines in dmesg.
> (I'll watch more.)

Thanks for the info.
So the patch only fixes the oops, 
we also need to fix the AE_ALREADY_EXISTS error.

>  
> > > 
> > > 
> > > [...]
> > > +		if (!(region_obj->region.node->flags & ANOBJ_TEMPORARY)) {
> > > +			acpi_ex_exit_interpreter();
> > > +		}
> > > [...]
> > > Does it explain successful boot with delay (vga=791, prink delay, etc.)?
> > 
> > Sorry, could you explain the question a bit more?
> > 
> Sorry,
> We had successful boots with small delays (like vga=791, prinTk delays and so on) and oopses otherwise.

Got it.

> 
> On (08/12/09 20:18), Len Brown wrote:
> >The fact that boot_delay=10 makes the problem go away
> >suggests some sort of race condition.  Is 10 the smallest
> >value of printk_time that works, or is it a random value?
> >
> 
> 
> >Currently, we exit the interpreter when setup region, because it may
> >execute control methods, such as _REG.
> >
> >The attached debug kernel patch (region-debug.patch) don't exit the
> >interpreter if the region is temporary, namely, it is defined inside a
> >method.
> Ok, we don't exit in case of temporary region. How is it possible that we had 'normal' 
> boots with delays? 

Not sure. Maybe the delays avoid some sort of race condition.

I will continue to investigate ...

Thanks,
Lin Ming

