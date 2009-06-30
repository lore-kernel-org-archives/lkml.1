Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbZF3GAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbZF3GAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZF3GAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:00:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45017 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbZF3GAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:00:22 -0400
Date: Mon, 29 Jun 2009 23:00:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, penberg@cs.helsinki.fi, jdb@comx.dk
Subject: Re: [PATCH RFC] fix RCU-callback-after-kmem_cache_destroy problem
	in sl[aou]b
Message-ID: <20090630060031.GL7070@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090625193137.GA16861@linux.vnet.ibm.com> <alpine.DEB.1.10.0906291827050.21956@gentwo.org> <1246315553.21295.100.camel@calx> <alpine.DEB.1.10.0906291910130.32637@gentwo.org> <1246320394.21295.105.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246320394.21295.105.camel@calx>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 07:06:34PM -0500, Matt Mackall wrote:
> On Mon, 2009-06-29 at 19:19 -0400, Christoph Lameter wrote:
> > On Mon, 29 Jun 2009, Matt Mackall wrote:
> > 
> > > This is a reasonable point, and in keeping with the design principle
> > > 'callers should handle their own special cases'. However, I think it
> > > would be more than a little surprising for kmem_cache_free() to do the
> > > right thing, but not kmem_cache_destroy().
> > 
> > kmem_cache_free() must be used carefully when using SLAB_DESTROY_BY_RCU.
> > The freed object can be accessed after free until the rcu interval
> > expires (well sortof, it may even be reallocated within the interval).
> > 
> > There are special RCU considerations coming already with the use of
> > kmem_cache_free().
> > 
> > Adding RCU operations to the kmem_cache_destroy() logic may result in
> > unnecessary RCU actions for slabs where the coder is ensuring that the
> > RCU interval has passed by other means.
> 
> Do we care? Cache destruction shouldn't be in anyone's fast path.
> Correctness is more important and users are more liable to be correct
> with this patch.

I am with Matt on this one -- if we are going to hand the users of
SLAB_DESTROY_BY_RCU a hand grenade, let's at least leave the pin in.

							Thanx, Paul
