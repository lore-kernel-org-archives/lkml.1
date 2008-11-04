Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYKDWZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYKDWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYKDWZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:25:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:16098 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbYKDWZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:25:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,545,1220252400"; 
   d="scan'208";a="70959862"
Date: Tue, 4 Nov 2008 14:25:10 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       venkatesh.pallipadi@intel.com
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
Message-ID: <20081104222509.GA12358@linux-os.sc.intel.com>
References: <20081030185322.GE17822@elte.hu> <20081030202322.GM30573@linux-os.sc.intel.com> <490A9337.6090504@goop.org> <20081031093924.GG30317@elte.hu> <490AE820.1010301@goop.org> <20081031165334.GA10468@linux-os.sc.intel.com> <490B6AE8.3040700@goop.org> <20081103101736.GI13671@elte.hu> <490F8DC9.9000005@goop.org> <20081104091956.GI23790@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104091956.GI23790@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 02:19:56AM -0700, Ingo Molnar wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Ingo Molnar wrote:
> >> ok - so that makes it a v2.6.28 item i guess.
> >>   
> >
> > The case Suresh is talking about was a fix to Xen itself, rather 
> > than on the kernel side, so it doesn't need to be a .28 issue on 
> > Xen's account.
> 
> ok - but still the portion of the fix that strengthens barriers looks 
> obvious to have and there's little downside that i can see.
> 
> Suresh, you might want to split the patch(es) in two: get the barrier 
> strengthening changes into v2.6.28 (to fix the x2apic bug), while the 
> aspects that _weaken_ barriers can wait for v2.6.29.
> 
> With that it would be a 100% safe change for v2.6.28-rc4.

Ok. I just posted three patches (including the x86 specific change).

[patch 1/3] generic-ipi: add smp_mb() before sending the IPI
[patch 2/3] x86: Add smp_mb() before sending INVALIDATE_TLB_VECTOR
[patch 3/3] generic-ipi: fix the smp_mb() usage

First two patches are safe to go into v2.6.28. Third patch can wait for v2.6.29.

thanks,
suresh
