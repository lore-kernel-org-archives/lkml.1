Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXI1XZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXI1XZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbXI1XZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:25:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:33193 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbXI1XZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:25:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,211,1188802800"; 
   d="scan'208";a="328162654"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH RFC] paravirt_ops: refactor struct paravirt_ops into smaller pv_*_ops
Date: Fri, 28 Sep 2007 16:25:11 -0700
Message-ID: <97D612E30E1F88419025B06CB4CF1BE10396C957@scsmsx412.amr.corp.intel.com>
In-Reply-To: <46FD4388.6000106@goop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH RFC] paravirt_ops: refactor struct paravirt_ops into smaller pv_*_ops
Thread-Index: AcgB+142mAWlYLhETQqOt1FMw6rjQgAJ3xaA
References: <46FD4388.6000106@goop.org>
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Andi Kleen" <ak@suse.de>,
       "Zachary Amsden" <zach@vmware.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Avi Kivity" <avi@qumranet.com>,
       "Glauber de Oliveira Costa" <glommer@gmail.com>,
       "Anthony Liguori" <anthony@codemonkey.ws>
Cc: "Virtualization Mailing List" <virtualization@lists.osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
X-OriginalArrivalTime: 28 Sep 2007 23:25:12.0547 (UTC) FILETIME=[D16A3330:01C80226]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> This patch refactors the paravirt_ops structure into groups of
> functionally related ops:
> 
> pv_info - random info, rather than function entrypoints
> pv_init_ops - functions used at boot time (some for module_init too)
> pv_misc_ops - lazy mode, which didn't fit well anywhere else
> pv_time_ops - time-related functions
> pv_cpu_ops - various privileged instruction ops
> pv_irq_ops - operations for managing interrupt state
> pv_apic_ops - APIC operations
> pv_mmu_ops - operations for managing pagetables
> 

Good. These make sense to me.

> +	.pv_irq_ops = {
> +		 .init_IRQ = native_init_IRQ,
> +		 .save_fl = native_save_fl,
> +		 .restore_fl = native_restore_fl,
> +		 .irq_disable = native_irq_disable,
> +		 .irq_enable = native_irq_enable,
> +		 .safe_halt = native_safe_halt,
> +		 .halt = native_halt,
> +	 },

I think the halt stuff should be moved to pv_cpu_ops?

> +	.pv_misc_ops = {
> +		 .set_lazy_mode = paravirt_nop,
> +	 },

Or you can split it to pv_cpu_ops and pv_mmu_ops, assuming that they
don't need to interact with each other in terms of the lazy handling.

Jun
---
Intel Open Source Technology Center
