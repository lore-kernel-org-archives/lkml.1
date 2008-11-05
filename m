Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbYKEJWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbYKEJWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYKEJWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:22:24 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:54682 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbYKEJWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:22:22 -0500
Date: Wed, 5 Nov 2008 10:20:52 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       venkatesh.pallipadi@intel.com
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
Message-ID: <20081105092052.GE21867@kernel.dk>
References: <20081030202322.GM30573@linux-os.sc.intel.com> <490A9337.6090504@goop.org> <20081031093924.GG30317@elte.hu> <490AE820.1010301@goop.org> <20081031165334.GA10468@linux-os.sc.intel.com> <490B6AE8.3040700@goop.org> <20081103101736.GI13671@elte.hu> <490F8DC9.9000005@goop.org> <20081104091956.GI23790@elte.hu> <20081104222509.GA12358@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104222509.GA12358@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04 2008, Suresh Siddha wrote:
> On Tue, Nov 04, 2008 at 02:19:56AM -0700, Ingo Molnar wrote:
> > 
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > 
> > > Ingo Molnar wrote:
> > >> ok - so that makes it a v2.6.28 item i guess.
> > >>   
> > >
> > > The case Suresh is talking about was a fix to Xen itself, rather 
> > > than on the kernel side, so it doesn't need to be a .28 issue on 
> > > Xen's account.
> > 
> > ok - but still the portion of the fix that strengthens barriers looks 
> > obvious to have and there's little downside that i can see.
> > 
> > Suresh, you might want to split the patch(es) in two: get the barrier 
> > strengthening changes into v2.6.28 (to fix the x2apic bug), while the 
> > aspects that _weaken_ barriers can wait for v2.6.29.
> > 
> > With that it would be a 100% safe change for v2.6.28-rc4.
> 
> Ok. I just posted three patches (including the x86 specific change).
> 
> [patch 1/3] generic-ipi: add smp_mb() before sending the IPI
> [patch 2/3] x86: Add smp_mb() before sending INVALIDATE_TLB_VECTOR
> [patch 3/3] generic-ipi: fix the smp_mb() usage
> 
> First two patches are safe to go into v2.6.28. Third patch can wait for v2.6.29.

I already have the combined 1+3 patch queued up...

-- 
Jens Axboe

