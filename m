Return-Path: <linux-kernel-owner+w=401wt.eu-S1759890AbZKLBTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbZKLBTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 20:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759770AbZKLBTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 20:19:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:1934 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759718AbZKLBTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 20:19:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,726,1249282800"; 
   d="scan'208";a="746131294"
Subject: Re: [PATCH] x86: make sure wakeup code is below 1M -v2
From: ykzhao <yakui.zhao@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <4AFB0B02.4050306@kernel.org>
References: <4AF7D820.5040503@kernel.org> <200911091315.13151.rjw@sisk.pl>
	 <4AFA210B.3020207@kernel.org>
	 <1257930767.31183.113.camel@localhost.localdomain>
	 <4AFB0B02.4050306@kernel.org>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Thu, 12 Nov 2009 09:17:12 +0800
Message-Id: <1257988632.31183.134.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 03:05 +0800, Yinghai Lu wrote:
> ykzhao wrote:
> > On Wed, 2009-11-11 at 10:27 +0800, Yinghai Lu wrote:
> >> try to find_e820_area/reserve_early, and call acpi_reserve_memory early
> >>
> >> to get area is below 1M
> >>
> >> -v2: change function name to acpi_reserve_wakeup_memory according to Rafael
> > It seems that the function of find_e820_area is called in several
> > places.
> >    >Initmem_init: bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT,
> > bootmap_size, PAGE_SIZE);
> >    
> > If we also call it in the acpi_reserve_wakeup_memory, do we get the same
> > base address as that obtained in initmem_init?
> 
> no. find_e820_area will check the reserve res array that could be updated by reserve_early.
It will check the reserved region array when calling the function of
find_e820_area. 
But it seems that the array is not updated when the find_e820_area is
called in the function of initmem_init.

At the same time the  acpi_reserve_bootmem is called after initializing
the boot mem allocator. Can we continue to reserve some region by using
find_e820_area?

thanks.
> 
> YH

