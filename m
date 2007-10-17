Return-Path: <linux-kernel-owner+w=401wt.eu-S1764774AbXJQJEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764774AbXJQJEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXJQJER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:04:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:54407 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbXJQJEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:04:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,289,1188802800"; 
   d="scan'208";a="249022487"
Subject: Re: [PATCH -mm -v5 0/3] i386/x86_64 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <p73odeyxi3u.fsf@crumb.suse.de>
References: <1192168345.17539.42.camel@caritas-dev.intel.com>
	 <1192586376.17856.26.camel@caritas-dev.intel.com>
	 <p73odeyxi3u.fsf@crumb.suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Oct 2007 17:05:47 +0800
Message-Id: <1192611948.17856.39.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 17 Oct 2007 09:03:20.0877 (UTC) FILETIME=[90B4CDD0:01C8109C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 10:25 +0200, Andi Kleen wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > Do you think it is a good idea to check the collision between setup data
> > and memory area used during kernel boot through bootmem allocator?
> 
> You can't solve this through bootmem because x86-64 allocates memory
> in several places before bootmem (using functions in e820.c) Right now
> this is quite hackish with hard coded areas to avoid conflicts.  But I
> recently had a need to allocate more memory that early too and changed
> the code to a generic early reservation interface. With that it would
> be relatively easy to reserve.

Can you tell me what that early reservation interface is? What I find in
x86_64 that does early memory allocation is alloc_low_page, which gets
non-conflict memory area through e820 map.

Because setup data is allocated by bootloader or kernel 16-bit setup
code, and the e820 map is created there too, the memory area used by
setup data can be made reserved memory area in e820 map by bootloader or
kernel 16-bit setup code. This way, they will not be overwritten by
kernel. Do you think this works.

Best Regards,
Huang Ying
