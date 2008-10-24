Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbYJXEOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbYJXEOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYJXEN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:13:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:56798 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbYJXEN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:13:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,474,1220252400"; 
   d="scan'208";a="64704637"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Nick Piggin <npiggin@suse.de>
CC: "hugh@veritas.com" <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 23 Oct 2008 21:13:57 -0700
Subject: RE: [RFC] remap_pfn_range: store vm_pgoff for all
 linear_over_vma_region mappings
Thread-Topic: [RFC] remap_pfn_range: store vm_pgoff for all
 linear_over_vma_region mappings
Thread-Index: Ack1dQHYULMD8tdaQ2+AW6zKTNL35AAGXBZQ
Message-ID: <7E82351C108FA840AB1866AC776AEC4637DDFA48@orsmsx505.amr.corp.intel.com>
References: <20081023220913.GA20300@linux-os.sc.intel.com>
 <20081024010803.GB5004@wotan.suse.de>
In-Reply-To: <20081024010803.GB5004@wotan.suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Nick Piggin [mailto:npiggin@suse.de] 
>Sent: Thursday, October 23, 2008 6:08 PM
>To: Pallipadi, Venkatesh
>Cc: hugh@veritas.com; apkm@linux-os.sc.intel.com; Ingo Molnar; 
>linux-kernel
>Subject: Re: [RFC] remap_pfn_range: store vm_pgoff for all 
>linear_over_vma_region mappings
>
>On Thu, Oct 23, 2008 at 03:09:14PM -0700, Venki Pallipadi wrote:
>> 
>> While working on x86 PAT, we are having some hurdles with tracking
>> remap_pfn_range() regions, as later we do not have any 
>information to say
>> whether that PFNMAP mapping is linear for the entire vma range or
>> it is smaller granularity regions within the vma.
>> 
>> A simple solution to this is to use vm_pgoff as an indicator for
>> linear mapping over the vma region. Currently, remap_pfn_range
>> only sets vm_pgoff only for COW mappings. Below patch changes the
>> logic and sets the vm_pgoff irrespective of COW.
>> 
>> >From our understanding of the code, this should not break anyone.
>> Just sending it as an RFC to get feedback on whether it is OK to do
>> something like this or are there any corner cases that we may
>> break or watch out for.
>> 
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
>Hmm, I can'tthink of why it would break, but I would like to see an
>entire patch. Obviously you won't try to decode this vma stuff
>directly from the PAT code, but just call mm helpers... ?
>

Yes. We are thinking of it as a call similar to is_cow_mapping().
May be is_linear_vma_mapping() or something like that. We should
have the rest of the patches by next week.

Thanks,
Venki
