Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZIIPQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZIIPQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZIIPQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:16:14 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41280 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbZIIPQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:16:13 -0400
Date: Wed, 9 Sep 2009 08:09:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>,
       dhowells@redhat.com, lethal@linux-sh.org, kernel@wantstofly.org,
       mpm@selenic.com
Subject: Re: [PATCH] slub: fix slab_pad_check()
Message-ID: <20090909150945.GB6749@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090903231757.GP6761@linux.vnet.ibm.com> <alpine.DEB.1.10.0909041140040.9781@V090114053VZO-1> <20090904204335.GG6751@linux.vnet.ibm.com> <alpine.DEB.1.10.0909081555410.26382@V090114053VZO-1> <20090908222036.GM6753@linux.vnet.ibm.com> <alpine.DEB.1.10.0909081839090.7733@V090114053VZO-1> <20090908225937.GO6753@linux.vnet.ibm.com> <alpine.DEB.1.10.0909091002440.28070@V090114053VZO-1> <20090909144238.GA6749@linux.vnet.ibm.com> <alpine.DEB.1.10.0909091052380.28070@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909091052380.28070@V090114053VZO-1>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 10:53:22AM -0400, Christoph Lameter wrote:
> On Wed, 9 Sep 2009, Paul E. McKenney wrote:
> 
> > If the embedded guys are OK with an additional pointer in the slab data
> > structure, I have no objection to this approach.  I am assuming that we
> > would use the usual ops-style structure full of pointers to functions
> > in order to avoid a pair of extra pointers.
> 
> This would also allow us to get rid of the ctor pointer in
> kmem_cache_create(). We can put it into the same structure.

Sounds good -- that would result in no increase in size.  Could even
add a dtor if people want it.  ;-)  (Sorry, couldn't resist...)

						Thanx, Paul
