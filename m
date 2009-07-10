Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbZGJGyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbZGJGyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 02:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZGJGyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 02:54:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54419 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZGJGym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 02:54:42 -0400
Subject: Re: [patch v2] slub: add option to disable higher order debugging
 slabs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <alpine.DEB.2.00.0907091620470.16817@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <1246374095.8014.28.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906301114450.3879@gentwo.org>
	 <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0906301632570.22158@gentwo.org>
	 <alpine.DEB.2.00.0906301413460.24397@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0906301722280.17682@gentwo.org>
	 <alpine.DEB.2.00.0906301445070.26290@chino.kir.corp.google.com>
	 <84144f020906302253n2424d4a5k3aaf124838a041df@mail.gmail.com>
	 <alpine.DEB.2.00.0907021016380.30890@chino.kir.corp.google.com>
	 <84144f020907030023v2d09632bt13b6c25f96c0b803@mail.gmail.com>
	 <alpine.DEB.2.00.0907062252500.9699@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0907070013400.14978@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0907071150010.5124@gentwo.org>
	 <alpine.DEB.2.00.0907091620470.16817@chino.kir.corp.google.com>
Date: Fri, 10 Jul 2009 09:54:39 +0300
Message-Id: <1247208879.19026.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Christoph Lameter wrote:
> > > + * Debugging flags that require metadata to be stored in the slab, up to
> > > + * DEBUG_SIZE in size.
> > > + */
> > > +#define DEBUG_SIZE_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
> > > +#define DEBUG_SIZE (3 * sizeof(void *) + 2 * sizeof(struct track))
> > 
> > There is no need for DEBUG_SIZE since slub keeps both the size of the
> > object kmem_cache->objsize and the size with the metadata kmem_cache->size
> > 
> > If the order of both is different then the order would increase.

On Thu, 2009-07-09 at 16:26 -0700, David Rientjes wrote:
> Without DEBUG_SIZE_FLAGS, the only way to determine what flags have 
> increased the size is in calculate_sizes() and then disable them by 
> default if slub_debug=O is specified.  calculate_sizes() is used by 
> the `store', `poison', and `red_zone' callbacks, so the admin still has 
> the ability to enable these options even though slub_debug=O was used.
> 
> So we can either mask off the size-increasing debug bits when the cache is 
> created in kmem_cache_flags() like I did, or we can move the logic to 
> calculate_sizes() with an added formal to determine whether this is from 
> kmem_cache_open() or one of the attribute callbacks.
> 
> I think my solution is the cleanest and provides a single entity, 
> DEBUG_SIZE_FLAGS, which specifies the flags that slub_debug=O clears if 
> the minimum order increases.

Yup, agreed. I applied the patch, thanks everyone!

			Pekka

