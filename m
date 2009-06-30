Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbZF3AH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbZF3AH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbZF3AHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:07:19 -0400
Received: from waste.org ([66.93.16.53]:38964 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758663AbZF3AHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:07:18 -0400
Subject: Re: [PATCH RFC] fix RCU-callback-after-kmem_cache_destroy problem
 in sl[aou]b
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       penberg@cs.helsinki.fi, jdb@comx.dk
In-Reply-To: <alpine.DEB.1.10.0906291910130.32637@gentwo.org>
References: <20090625193137.GA16861@linux.vnet.ibm.com>
	 <alpine.DEB.1.10.0906291827050.21956@gentwo.org>
	 <1246315553.21295.100.camel@calx>
	 <alpine.DEB.1.10.0906291910130.32637@gentwo.org>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 19:06:34 -0500
Message-Id: <1246320394.21295.105.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 19:19 -0400, Christoph Lameter wrote:
> On Mon, 29 Jun 2009, Matt Mackall wrote:
> 
> > This is a reasonable point, and in keeping with the design principle
> > 'callers should handle their own special cases'. However, I think it
> > would be more than a little surprising for kmem_cache_free() to do the
> > right thing, but not kmem_cache_destroy().
> 
> kmem_cache_free() must be used carefully when using SLAB_DESTROY_BY_RCU.
> The freed object can be accessed after free until the rcu interval
> expires (well sortof, it may even be reallocated within the interval).
> 
> There are special RCU considerations coming already with the use of
> kmem_cache_free().
> 
> Adding RCU operations to the kmem_cache_destroy() logic may result in
> unnecessary RCU actions for slabs where the coder is ensuring that the
> RCU interval has passed by other means.

Do we care? Cache destruction shouldn't be in anyone's fast path.
Correctness is more important and users are more liable to be correct
with this patch.

-- 
http://selenic.com : development and support for Mercurial and Linux


