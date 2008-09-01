Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYIAFAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYIAFAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 01:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYIAFAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 01:00:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41633 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYIAFAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 01:00:09 -0400
Date: Sun, 31 Aug 2008 22:00:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, jwboyer@linux.vnet.ibm.com,
       tnt@246tNt.com, grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       manfred@colorfullife.com, akpm@linux-foundation.org
Subject: Re: [PATCH] prevent powerpc from invoking irq handlers on offline
	CPUs
Message-ID: <20080901050003.GN7015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080831173127.GA15296@linux.vnet.ibm.com> <1220229284.13162.411.camel@pasglop> <20080901020640.GM7015@linux.vnet.ibm.com> <1220238880.13010.4.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220238880.13010.4.camel@pasglop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 01:14:40PM +1000, Benjamin Herrenschmidt wrote:
> On Sun, 2008-08-31 at 19:06 -0700, Paul E. McKenney wrote:
> > On Mon, Sep 01, 2008 at 10:34:44AM +1000, Benjamin Herrenschmidt wrote:
> > > On Sun, 2008-08-31 at 10:31 -0700, Paul E. McKenney wrote:
> > > > Make powerpc refrain from clearing a given to-be-offlined CPU's bit in the
> > > > cpu_online_mask until it has processed pending irqs.  This change
> > > > prevents other CPUs from being blindsided by an apparently offline CPU
> > > > nevertheless changing globally visible state.
> > > > 
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > ---
> > > 
> > > Sounds reasonable... the only possible worry here is if somebody tries
> > > an IPI ... The IPI code will and the target CPU mask with the online
> > > map, so it may try to send to the to-be-offlined CPU and timeout, no ?
> > 
> > OK.  Do we need separate IPI and online masks?
> 
> Shouldn't we already have routed all interrupts to other CPUs anyway ?
> 
> IE. The affinity of all interrupts should have been updated. So the
> only thing we're going to get here are possibly IPIs and decrementer, 
> I don't see it being a big deal making sure we test we are online when
> receiving it.

It did look to me that the CPU removed itself from the interrupt queue
before re-enabling interrupts, so makes sense to me...

							Thanx, Paul
