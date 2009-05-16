Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbZEPBTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbZEPBTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 21:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZEPBTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 21:19:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:31435 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbZEPBTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 21:19:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,202,1241420400"; 
   d="scan'208";a="143448071"
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
In-Reply-To: <1242305390-21958-1-git-send-email-tj@kernel.org>
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 15 May 2009 18:17:06 -0700
Message-Id: <1242436626.27006.8623.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 05:49 -0700, Tejun Heo wrote:
> Hello,
> 
> Upon ack, please pull from the following git tree.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-percpu-pageattr
> 
> This patchset fixes subtile bug in pageattr handling when remap percpu
> first chunk allocator is in use and implements percpu_alloc kernel
> parameter so that allocator can be selected from boot prompt.
> 
> This problem was spotted by Jan Beulich.
> 
> The remap allocator allocates a PMD page per cpu, returns whatever is
> unnecessary to the page allocator and remaps the PMD page into vmalloc
> area to construct the first percpu chunk.  This is to take advantage
> of large page mapping.  

Tejun, Can you please educate me why we need to map this first percpu
chunk (which is pre-allocated during boot and is physically contiguous)
into vmalloc area? Perhaps even for the other dynamically allocated
secondary chunks? (as far as I can see, all the chunk allocations seems
to be physically contiguous and later mapped into vmalloc area)..

That should simplify these things quite a bit(atleast for first percpu
chunk). I am missing something obvious I guess.

thanks,
suresh

