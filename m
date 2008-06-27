Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYF0Coh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYF0Coh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 22:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYF0Co1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 22:44:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:27392 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbYF0Co1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 22:44:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,713,1204531200"; 
   d="scan'208";a="300081395"
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
From: "Huang, Ying" <ying.huang@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440806261922n3f13b454o5e543e28d9a34e8e@mail.gmail.com>
References: <1214461978.10809.6.camel@caritas-dev.intel.com>
	 <86802c440806260025v3fc1970aq682b568cccba4b4e@mail.gmail.com>
	 <1214466513.11346.30.camel@caritas-dev.intel.com>
	 <86802c440806260247p19f5b850r8757c51280912ae9@mail.gmail.com>
	 <86802c440806261922n3f13b454o5e543e28d9a34e8e@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Jun 2008 10:48:14 +0800
Message-Id: <1214534894.10865.6.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 27 Jun 2008 02:44:23.0857 (UTC) FILETIME=[B54F6210:01C8D7FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 19:22 -0700, Yinghai Lu wrote:
> On Thu, Jun 26, 2008 at 2:47 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Thu, Jun 26, 2008 at 12:48 AM, Huang, Ying <ying.huang@intel.com> wrote:
> >> On Thu, 2008-06-26 at 00:25 -0700, Yinghai Lu wrote:
> >> [...]
> >>> >                if (pfn >= limit_pfn)
> >>> > @@ -977,7 +978,7 @@ u64 __init early_reserve_e820(u64 startt
> >>> >                return 0;
> >>> >
> >>> >        addr = round_down(start + size - sizet, align);
> >>> > -       e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);
> >>> > +       e820_update_range(addr, sizet, E820_RAM, E820_RESVD_KERN);
> >>>
> >>> this line is not needed.
> >>
> >> Why? Memory reserved by early_rserved_e820 should not be saved during
> >> hibernation? shoudl not be saved by kdump?
> >>

Can you tell me why this line is not needed?

[...]
> some like the attach patch...
> 
> you still can merge parse_setup_data parse_e820_ext
> also entries in parse_e820_ext is not initialized..., __copy_e820_map
> will do nothing.

﻿OK. Because some E820 entries are available after parse_setup_data(),
it is better to call reserve_setup_data() after calling
parse_setup_data() if update_e820_range() is used instead of
reserve_early().

Best Regards,
Huang Ying

