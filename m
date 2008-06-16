Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbYFPIvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbYFPIvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYFPIvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:51:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:11184 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbYFPIvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:51:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,651,1204531200"; 
   d="scan'208";a="578143079"
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
	memory ranges
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com, steiner@sgi.com,
       travis@sgi.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
In-Reply-To: <20080616032457.718f4d87.pj@sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	 <1213600062.11185.13.camel@caritas-dev.intel.com>
	 <20080616032457.718f4d87.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jun 2008 16:53:55 +0800
Message-Id: <1213606435.12968.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 Jun 2008 08:50:58.0270 (UTC) FILETIME=[187537E0:01C8CF8E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 03:24 -0500, Paul Jackson wrote:
> Huang wrote:
> >  I think it is better to change boot loader to avoid memory area of EBDA.
> 
> Would this require the bootloader to know the kernels rather arbitrary
> heuristics for inventing and placing an EBDA area, in reserve_ebda_region()?

I think it is sufficient for boot loader to avoid memory area from
0x9f000 to 0x100000. This can be seen as compatible code for legacy
BIOS.

> In general, I would think it better not to have to code into the EFI
> firmware or bootloader such knowledge.  But perhaps I am wrong here.
> 
> If the kernel is going to reserve an EBDA region even if no EBDA is
> requested by the BIOS, then I would think that the kernel should be
> more tolerant of BIOS's that put something else in that place.
> 
> > Or do not reserve EBDA on EFI system.
> 
> I suppose.  This would have been a bigger change than I could
> suggest.  For all I know, there are existing systems using EBDA
> and EFI together.  Would this change break them?
> 
> If you have good reason to know that's essentially impossible then
> I have no objections, so far as my needs go, to not reserving EBDA
> on EFI systems.

I think if EBDA area is used in EFI system, it should be reserved in EFI
memory map.

Best Regards,
Huang Ying

