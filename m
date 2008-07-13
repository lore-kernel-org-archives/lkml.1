Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbYGMBBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbYGMBBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 21:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYGMBBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 21:01:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:1331 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbYGMBBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 21:01:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,352,1212390000"; 
   d="scan'208";a="357780840"
Date: Sat, 12 Jul 2008 18:01:00 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Message-ID: <20080713010059.GB1678@linux-os.sc.intel.com>
References: <20080711203151.GU1678@linux-os.sc.intel.com> <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com> <20080711204521.GA15689@elte.hu> <20080711212418.GV1678@linux-os.sc.intel.com> <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com> <86802c440807112016k38c8161aq143463ee57b24c35@mail.gmail.com> <m163rb4v3j.fsf@frodo.ebiederm.org> <86802c440807112317h23118e29j51113a052720d8db@mail.gmail.com> <m1y7471t5t.fsf@frodo.ebiederm.org> <86802c440807120049t2aaec131l4c735712f2befb2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807120049t2aaec131l4c735712f2befb2@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 12:49:53AM -0700, Yinghai Lu wrote:
> On Sat, Jul 12, 2008 at 12:02 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> > "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> >
> >> On Fri, Jul 11, 2008 at 8:52 PM, Eric W. Biederman
> >> <ebiederm@xmission.com> wrote:
> >>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> >>>
> >>>> 1. wonder if x2apic can be use with uniprocessor.
> >>>>
> >>>> in APIC_init_uniprocessor, it will try to enable x2apic, but later
> >>>>
> >>>> apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
> >>>>
> >>>> but SET_APIC_ID is still for xapic version. so need to GET_APIC_ID,
> >>>> SET_APIC_ID for different
> >>>> genapic like 32bit.
> >>>>
> >>>> 2 check_x2apic is called in setup_arch, but it only set apic_ops,
> >>>> and genapic still not changed, aka apic_flat...
> >>>> wonder if you need to call setup_apic_routing to set genapic.
> >>>>
> >>>> otherwise read_apic_id could have use the one from apic_flat....need
> >>>> to shift......
> >>>>
> >>>> 3.or move read_apic_id to apic_ops intead...together with GET_APIC_ID too.
> >>>> but 32bit version seems like to put GET_APIC_ID with genapic...
> >>>>
> >>>> which one is better? 2 or 3
> >>>
> >>> Z finish untangle SMP support from apic initialization and move the apic
> >>> initialization up into init_IRQ.
> >>>
> >>> That is better but is likely the wrong short term approach.
> >>
> >> plan to add get_apic_id(x) into 64bit genapic, and will use
> >> #define GET_APIC_ID(x) genapic->get_apic_id(x)
> >> #define read_apic_id() GET_APIC_ID(apic_read(APIC_ID))
> >>
> >> so it is identical to 32bit, and we smooth the merging of 32/64 apic code
> >>
> >> also read the x2APIC spec pdf, it doesn't say anything about interrupt
> >> remapping...need to be used with x2apic...
> >
> > Clustered logical mode won't work as it requires > 16 bits of apicid.
> > So only flat physical mode will work.
> 
> current read_apic_id in genx2apic_cluster and genx2apic_phys is the same...

read_apic_id() corresponds to physical apic id and it is same
irrespective of whether we use logical cluster mode or physical mode.

thanks,
suresh
