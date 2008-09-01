Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbYIADVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbYIADVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 23:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYIADV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 23:21:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:45641 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYIADV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 23:21:27 -0400
Subject: Re: [PATCH] prevent powerpc from invoking irq handlers on offline
	CPUs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, jwboyer@linux.vnet.ibm.com,
       tnt@246tNt.com, grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       manfred@colorfullife.com, akpm@linux-foundation.org
In-Reply-To: <20080901020640.GM7015@linux.vnet.ibm.com>
References: <20080831173127.GA15296@linux.vnet.ibm.com>
	 <1220229284.13162.411.camel@pasglop>
	 <20080901020640.GM7015@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 13:14:40 +1000
Message-Id: <1220238880.13010.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-31 at 19:06 -0700, Paul E. McKenney wrote:
> On Mon, Sep 01, 2008 at 10:34:44AM +1000, Benjamin Herrenschmidt wrote:
> > On Sun, 2008-08-31 at 10:31 -0700, Paul E. McKenney wrote:
> > > Make powerpc refrain from clearing a given to-be-offlined CPU's bit in the
> > > cpu_online_mask until it has processed pending irqs.  This change
> > > prevents other CPUs from being blindsided by an apparently offline CPU
> > > nevertheless changing globally visible state.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > ---
> > 
> > Sounds reasonable... the only possible worry here is if somebody tries
> > an IPI ... The IPI code will and the target CPU mask with the online
> > map, so it may try to send to the to-be-offlined CPU and timeout, no ?
> 
> OK.  Do we need separate IPI and online masks?

Shouldn't we already have routed all interrupts to other CPUs anyway ?

IE. The affinity of all interrupts should have been updated. So the
only thing we're going to get here are possibly IPIs and decrementer, 
I don't see it being a big deal making sure we test we are online when
receiving it.

Ben.


