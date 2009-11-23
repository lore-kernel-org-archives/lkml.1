Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZKWTuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZKWTuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZKWTuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:50:12 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51358 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbZKWTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:50:09 -0500
Subject: Re: lockdep complaints in slab allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       linux-mm@kvack.org, mpm@selenic.com,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.DEB.2.00.0911231329560.5617@router.home>
References: <20091118181202.GA12180@linux.vnet.ibm.com>
	 <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>
	 <1258709153.11284.429.camel@laptop>
	 <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>
	 <1258714328.11284.522.camel@laptop>  <4B067816.6070304@cs.helsinki.fi>
	 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>
	 <alpine.DEB.2.00.0911231329560.5617@router.home>
Date: Mon, 23 Nov 2009 21:50:14 +0200
Message-Id: <1259005814.15619.14.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Pekka Enberg wrote:
> > That turns out to be _very_ hard. How about something like the following
> > untested patch which delays slab_destroy() while we're under nc->lock.

On Mon, 2009-11-23 at 13:30 -0600, Christoph Lameter wrote:
> Code changes to deal with a diagnostic issue?

OK, fair enough. If I suffer permanent brain damage from staring at the
SLAB code for too long, I hope you and Matt will chip in to pay for my
medication.

I think I was looking at the wrong thing here. The problem is in
cache_free_alien() so the comment in slab_destroy() isn't relevant.
Looking at init_lock_keys() we already do special lockdep annotations
but there's a catch (as explained in a comment on top of
on_slab_alc_key):

 * We set lock class for alien array caches which are up during init.
 * The lock annotation will be lost if all cpus of a node goes down and
 * then comes back up during hotplug

Paul said he was running CPU hotplug so maybe that explains the problem?

			Pekka

