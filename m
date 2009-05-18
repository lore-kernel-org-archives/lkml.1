Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZERTWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZERTWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZERTWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:22:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:4545 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbZERTWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:22:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,211,1241420400"; 
   d="scan'208";a="144180879"
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap
 allocator
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Tejun Heo <tj@kernel.org>
Cc: "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A0F672A.3000309@kernel.org>
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
	 <1242436626.27006.8623.camel@localhost.localdomain>
	 <4A0ED8D8.2010303@kernel.org>
	 <1242500964.27006.8636.camel@localhost.localdomain>
	 <4A0F672A.3000309@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 18 May 2009 12:20:44 -0700
Message-Id: <1242674444.27006.8691.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-16 at 18:23 -0700, Tejun Heo wrote:
> Units in
> a single chunk should be contiguous and of the same size such that
> unit_addr_for_cpu_N == chunk_addr + N * unit_size whereas chunks don't
> need to have any special address relation to other chunks. 

And the size of the unit is same across chunks.

This is what I was missing :)

Can we don't use PERCPU_DYNAMIC_RESERVE in the first chunk and for
dynamic per_cpu_ptr's we can use some other offset such as
per_cpu_ptr_offset() or some such thing?

Then we can separate the static and dynamic chunks. And use large page
kernel-direct mappings for fast access for critical common things and
use small page accesses for dynamic and not so common accesses.

Just checking to see if we can reduce the complexity of setting up the
percpu areas (different versions for embed, non-embed etc) and handling
all these aliases with simple code, rather than making it complex.

thanks,
suresh

