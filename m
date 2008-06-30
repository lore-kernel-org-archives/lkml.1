Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbYF3Jeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbYF3Jeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYF3JeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:34:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:17574 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbYF3JeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:34:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,727,1204531200"; 
   d="scan'208";a="4492227"
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
From: "Huang, Ying" <ying.huang@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440806300215w31abbcb3h6a42395e11701713@mail.gmail.com>
References: <1214461978.10809.6.camel@caritas-dev.intel.com>
	 <86802c440806260025v3fc1970aq682b568cccba4b4e@mail.gmail.com>
	 <1214466513.11346.30.camel@caritas-dev.intel.com>
	 <86802c440806260247p19f5b850r8757c51280912ae9@mail.gmail.com>
	 <86802c440806261922n3f13b454o5e543e28d9a34e8e@mail.gmail.com>
	 <1214534894.10865.6.camel@caritas-dev.intel.com>
	 <86802c440806271505n78275758re235ef6616d95b3d@mail.gmail.com>
	 <1214809434.2887.8.camel@caritas-dev.intel.com>
	 <86802c440806300034x5bb9b7a1s168bbeaee17e5124@mail.gmail.com>
	 <1214812303.3187.10.camel@caritas-dev.intel.com>
	 <86802c440806300215w31abbcb3h6a42395e11701713@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 30 Jun 2008 17:38:26 +0800
Message-Id: <1214818706.23677.8.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 30 Jun 2008 09:34:20.0164 (UTC) FILETIME=[79173C40:01C8DA94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-30 at 02:15 -0700, Yinghai Lu wrote:
[...]
> >
> > I mean memory area reserved with reserved_early() or e820_update_range()
> > before reserve_setup_data() is called.
> 
> before parse_setup_data, reserve_early is called for
> 1. kernel text/data/bss + initial pgt
> 2. ramdisk
> 3. ebda
> e820_update_range is not called.
> at this time early_res have RAM reserved by kernel.
> 
> then setup_memory_map is called, so e820 have some ranges...directly
> from e820 table
> 
> next need to call parse_setup_data
> it will add some entries in e820
> 
> then reserve_setup_data is called, it will use e820_update_range to
> reserve setup_data itself directly in e820
> 
> ...

Yes. There is no real conflict now. I think a better rule is:

- Reserve memory area (directly from BIOS or boot-loader, not from
find_e820_area) needed as early as possible.
- Don't touch reserved area until all possible reservation is made, that
is, before conflict check is done.

> >
> > And because there is no conflict check in e820_update_range(), what to
> > deal with potential conflict between setup_data and other memory area
> > regardless which one is reserved earlier?
> 
> find_e820_area will make sure it only find ram from e820 and it is not
> conflict with early_res

For find_e820_area, this is safe enough. But what about conflict between
setup_data and ebda or ramdisk?

Best Regards,
Huang Ying

