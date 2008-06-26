Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYFZIgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYFZIgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYFZIfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:35:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:9007 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbYFZIfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:35:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,707,1204531200"; 
   d="scan'208";a="345752875"
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
From: "Huang, Ying" <ying.huang@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440806260025v3fc1970aq682b568cccba4b4e@mail.gmail.com>
References: <1214461978.10809.6.camel@caritas-dev.intel.com>
	 <86802c440806260025v3fc1970aq682b568cccba4b4e@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Jun 2008 15:48:33 +0800
Message-Id: <1214466513.11346.30.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 26 Jun 2008 07:44:46.0666 (UTC) FILETIME=[81540AA0:01C8D760]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 00:25 -0700, Yinghai Lu wrote:
[...]
> >                if (pfn >= limit_pfn)
> > @@ -977,7 +978,7 @@ u64 __init early_reserve_e820(u64 startt
> >                return 0;
> >
> >        addr = round_down(start + size - sizet, align);
> > -       e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);
> > +       e820_update_range(addr, sizet, E820_RAM, E820_RESVD_KERN);
> 
> this line is not needed.

Why? Memory reserved by early_rserved_e820 should not be saved during
hibernation? shoudl not be saved by kdump?

> >        printk(KERN_INFO "update e820 for early_reserve_e820\n");
> >        update_e820();
> >
> > @@ -1191,6 +1192,7 @@ void __init e820_reserve_resources(void)
> >        res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
> >        for (i = 0; i < e820.nr_map; i++) {
> >                switch (e820.map[i].type) {
> > +               case E820_RESVD_KERN:
> >                case E820_RAM:  res->name = "System RAM"; break;
> >                case E820_ACPI: res->name = "ACPI Tables"; break;
> >                case E820_NVS:  res->name = "ACPI Non-volatile Storage"; break;
> >
> > --
> 
> please  move reserve_setup_data() from head.c/head64.c to setup32/64.c
> or merged setup.c

OK.

> also need to change reserve_early in reserve_setup_data to
> e820_update_range(,,E820_RAM, E820_RESEVED_EXTRA).

﻿Does this means reserve_early() should be replaced by
e820_update_range()?

> calling reserve_setup_data() should around early_reserve_e820_mpc_new.

I think reserve_xxx should be called before first find_e820_area() to
minimize the possibility of conflict.

> we don't need early_res_to_e820.

Best Regards,
Huang Ying

