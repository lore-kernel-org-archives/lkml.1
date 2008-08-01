Return-Path: <linux-kernel-owner+w=401wt.eu-S1762586AbYHAVRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762586AbYHAVRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760972AbYHAVKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:10:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42013 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760693AbYHAVKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:10:45 -0400
Date: Fri, 1 Aug 2008 14:10:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Miklos Szeredi <miklos@szeredi.hu>, peterz@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com, Larry.Finger@lwfinger.net,
       kaber@trash.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080801211043.GW14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1216890648.7257.258.camel@twins> <200807242038.36693.nickpiggin@yahoo.com.au> <E1KLyUI-0006ZS-Cg@pomaz-ex.szeredi.hu> <200807242106.52672.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807242106.52672.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 09:06:51PM +1000, Nick Piggin wrote:
> On Thursday 24 July 2008 20:55, Miklos Szeredi wrote:
> > On Thu, 24 Jul 2008, Nick Piggin wrote:
> > > Hey, something kind of cool (and OT) I've just thought of that we can
> > > do with ticket locks is to take tickets for 2 (or 64K) nested locks,
> > > and then wait for them both (all), so the cost is N*lock + longest spin,
> > > rather than N*lock + N*avg spin.
> >
> > Isn't this deadlocky?
> >
> > E.g. one task takes ticket x=1, then other task comes in and takes x=2
> > and y=1, then first task takes y=2.  Then neither can actually
> > complete both locks.
> 
> Oh duh of course you still need mutual exclusion from the first lock
> to order the subsequent :P
> 
> So yeah it only works for N > 2 locks, and you have to spin_lock the
> first one... so unsuitable for scheduler.

Or sort the locks by address or some such.

							Thanx, Paul
