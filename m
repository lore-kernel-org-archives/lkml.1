Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbYFZIpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbYFZIpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbYFZIoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:44:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:13960 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbYFZIoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:44:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,707,1204531200"; 
   d="scan'208";a="345756194"
Subject: Re: [PATCH 2/2] x86 boot: early_res_to_e820
From: "Huang, Ying" <ying.huang@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440806260029l35b68e4fh89264e1796e7863b@mail.gmail.com>
References: <1214461980.10809.7.camel@caritas-dev.intel.com>
	 <86802c440806260013u447d15d8v94df7bb7bd00da19@mail.gmail.com>
	 <1214465232.11346.18.camel@caritas-dev.intel.com>
	 <86802c440806260029l35b68e4fh89264e1796e7863b@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Jun 2008 16:03:31 +0800
Message-Id: <1214467411.11346.34.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 26 Jun 2008 07:59:44.0564 (UTC) FILETIME=[98846740:01C8D762]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 00:29 -0700, Yinghai Lu wrote:
[...]
> >
> > For example, if EFI memory map is allocated in highmem area by
> > boot-loader, it need to be reserved in kernel. But on i386, bootmem can
> > only reserve memory area below max_low_pfn. So I think this is needed.
> >
> > In general, I think it is needed to provide a reservation mechanism for
> > highmem area on i386. Because some memory area from BIOS or boot-loader
> > may in highmem area.
> 
> I mean call reserve_setup_data right after finish_e820_parsing,  and
> it could call e820_update_range directly.

e820_update_range() can only be used after finish_e820_parsing()?

parse_setup_data() should be called before parse_early_param() to let
early_param override settings in setup_data. Which is before
finish_e820_parsing(). It seems a little wired to use the data before
reserve it.

And this means find_e820_area() should not be called before
e820_update_range()?

Best Regards,
Huang Ying

