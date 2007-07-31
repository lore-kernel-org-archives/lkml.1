Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbXGaHdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbXGaHdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXGaHdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:33:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:28354 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXGaHdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:33:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,201,1183359600"; 
   d="scan'208";a="256764416"
Subject: Re: [PATCH 1/5] x86_64 EFI support -v3: EFI base support
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1vec1tche.fsf@ebiederm.dsl.xmission.com>
References: <1185851572.23149.26.camel@caritas-dev.intel.com>
	 <m1vec1tche.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 15:33:11 +0800
Message-Id: <1185867191.23149.61.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 31 Jul 2007 07:33:21.0474 (UTC) FILETIME=[1230CA20:01C7D345]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 22:37 -0600, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > Changelog between v2 and v3:
> >
> > 1. The EFI callwrapper is re-implemented in assembler.
> >
> > ---
> >
> > This patch adds basic support for EFI x86_64 system. The main file of
> > the patch is the addition of efi.c for x86_64. This file is modeled
> > after the EFI IA32 avatar. EFI initialization are implemented in
> > efi.c. Some x86_64 specifics are worth noting here. On x86_64,
> > parameters passed to UEFI firmware services need to follow the UEFI
> > calling convention. For this purpose, a set of functions named
> > lin2win<x> (<x> is the number of parameters) are implemented. EFI
> > function calls are wrapped before calling the firmware service.
> 
> 
> Since the code to generate the e820 map from the efi memory map has
> been added to elilo (odd but ok) why does this patch continue to
> have code for playing with the efi memory map?

EFI memory map is used as the parameter to EFI runtime service call:
set_virtual_address_map. It conveys some information not suitable to be
described in E820 map, such as, memory region that is memory mapped IO
and is used by EFI runtime service.

Best Regards,
Huang Ying
