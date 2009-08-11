Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZHKSKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZHKSKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbZHKSKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:10:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:55106 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341AbZHKSKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,361,1246863600"; 
   d="scan'208";a="482666424"
Subject: Re: [PATCH] hpet: hpet driver periodic timer setup bug fixes
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nils Carlson <nils.carlson@ericsson.com>,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <20090810210312.eb3bb57f.akpm@linux-foundation.org>
References: <20090810220503.GA29239@linux-os.sc.intel.com>
	 <20090810210312.eb3bb57f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 11:07:42 -0700
Message-Id: <1250014062.11545.39252.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 21:03 -0700, Andrew Morton wrote:
> On Mon, 10 Aug 2009 15:05:04 -0700 "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
> 
> > From: Nils Carlson <nils.carlson@ericsson.com>
> > 
> > The periodic interrupt from drivers/char/hpet.c does not work correctly,
> > both when using the periodic capability of the hardware and while
> > emulating the periodic interrupt (when hardware does not support
> > periodic mode).
> > 
> > With timers capable of periodic interrupts, the comparator field is first
> > set with the period value followed by set of hidden accumulator,
> > which has the side effect of overwriting the comparator value. This
> > results in wrong periodicity for the interrupts. For,
> > periodic interrupts to work, following steps are necessary, in that order.
> > * Set config with Tn_VAL_SET_CNF bit
> > * Write to hidden accumulator, the value written is the time when the
> >   first interrupt should be generated
> > * Write compartor with period interval for subsequent interrupts
> > (http://www.intel.com/hardwaredesign/hpetspec_1.pdf )
> > 
> > When emulating periodic timer with timers not capable of periodic
> > interrupt, driver is adding the period to counter value instead of
> > comparator value, which causes slow drift when using this emulation.
> > 
> > Also, driver seems to add hpetp->hp_delta both while setting up
> > periodic interrupt and while emulating periodic interrupts with timers
> > not capable of doing periodic interrupts. This hp_delta will result in
> > slower than expected interrupt rate and should not be used while setting
> > the interval.
> > 
> 
> Do you have any thoughts on which kernel versions this fix should be
> merged into, and when?
> 

Should be OK let this bake for a while and merge this in after .31.

Thanks,
Venki

