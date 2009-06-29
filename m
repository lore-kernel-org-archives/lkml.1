Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbZF2XT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbZF2XT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZF2XTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:19:20 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:58487 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753607AbZF2XTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:19:19 -0400
Date: Mon, 29 Jun 2009 19:19:05 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Matt Mackall <mpm@selenic.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       penberg@cs.helsinki.fi, jdb@comx.dk
Subject: Re: [PATCH RFC] fix RCU-callback-after-kmem_cache_destroy problem
 in sl[aou]b
In-Reply-To: <1246315553.21295.100.camel@calx>
Message-ID: <alpine.DEB.1.10.0906291910130.32637@gentwo.org>
References: <20090625193137.GA16861@linux.vnet.ibm.com>  <alpine.DEB.1.10.0906291827050.21956@gentwo.org> <1246315553.21295.100.camel@calx>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Matt Mackall wrote:

> This is a reasonable point, and in keeping with the design principle
> 'callers should handle their own special cases'. However, I think it
> would be more than a little surprising for kmem_cache_free() to do the
> right thing, but not kmem_cache_destroy().

kmem_cache_free() must be used carefully when using SLAB_DESTROY_BY_RCU.
The freed object can be accessed after free until the rcu interval
expires (well sortof, it may even be reallocated within the interval).

There are special RCU considerations coming already with the use of
kmem_cache_free().

Adding RCU operations to the kmem_cache_destroy() logic may result in
unnecessary RCU actions for slabs where the coder is ensuring that the
RCU interval has passed by other means.



