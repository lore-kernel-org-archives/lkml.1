Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbZEFGt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbZEFGt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZEFGts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:49:48 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:45508 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbZEFGtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q02/FHmnknwhfUCp2IRseAVOn8J3K+EDCvA88nxGKY9wFGxxmGozqnDDGRsWL2SGlJ
         OT2paBYl5IWWS8TY0hHBgMb18kCCbvk3/OLqoU6v/T6Kw6YsMCe6cy9OoM2IHrelz8K4
         iXr/GAS4aaa0YMCEDcNb/goWio0lAxZs/ZBfg=
Date: Wed, 6 May 2009 10:44:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LMMML <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mmotm] mm: init_per_zone_pages_min - get rid of sqrt
	call on small machines
Message-ID: <20090506064410.GB4865@lenovo>
References: <20090506061953.GA16057@lenovo> <alpine.DEB.2.00.0905052334391.9824@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905052334391.9824@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Rientjes - Tue, May 05, 2009 at 11:36:38PM -0700]
| On Wed, 6 May 2009, Cyrill Gorcunov wrote:
| 
| > Index: linux-2.6.git/mm/page_alloc.c
| > =====================================================================
| > --- linux-2.6.git.orig/mm/page_alloc.c
| > +++ linux-2.6.git/mm/page_alloc.c
| > @@ -4610,11 +4610,15 @@ static int __init init_per_zone_pages_mi
| >  
| >  	lowmem_kbytes = nr_free_buffer_pages() * (PAGE_SIZE >> 10);
| >  
| > -	min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
| > -	if (min_free_kbytes < 128)
| > +	/* for small values we may eliminate sqrt operation completely */
| > +	if (lowmem_kbytes < 1024)
| >  		min_free_kbytes = 128;
| > -	if (min_free_kbytes > 65536)
| > -		min_free_kbytes = 65536;
| > +	else {
| > +		min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
| > +		if (min_free_kbytes > 65536)
| > +			min_free_kbytes = 65536;
| > +	}
| > +
| >  	setup_per_zone_pages_min();
| >  	setup_per_zone_lowmem_reserve();
| >  	setup_per_zone_inactive_ratio();
| 
| For a function that's called once, this just isn't worth it.  int_sqrt() 
| isn't expensive enough to warrant the assault on the readability of the 
| code.
| 

ok, then we could just drop it.

	-- Cyrill
