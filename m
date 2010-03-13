Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0CMCGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:06:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:29848 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab0CMCGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:06:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,629,1262592000"; 
   d="scan'208";a="254209269"
Subject: Re: [Patch] x86,pat Update the page flags for memtype atomically
 instead of using memtype_lock.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <alpine.LFD.2.00.1003130250540.22855@localhost.localdomain>
References: <20100311161700.GC5685@sgi.com>
	 <1268439313.2793.148.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.1003130204560.22855@localhost.localdomain>
	 <1268444762.2793.197.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.1003130250540.22855@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 12 Mar 2010 18:05:23 -0800
Message-Id: <1268445923.2793.206.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 17:52 -0800, Thomas Gleixner wrote:
> On Fri, 12 Mar 2010, Suresh Siddha wrote:
> > Just wanted to make sure that we address the perf aspect even for non
> > RAM pages by converting the memtype_lock into rwlock before some one
> > else reports a similar issue for non RAM pages.
> 
> Care to explain why a rwlock is a good solution and which problem is
> solved by the conversion of a spinlock to a rwlock ?

Thomas, This is the original posting from Robin.

http://marc.info/?l=linux-kernel&m=126720623119649&w=2

lookup_memtype() currently takes the memtype spinlock. Changing this to
a readlock will allow multiple folks to go through this in parallel.

thanks,
suresh

