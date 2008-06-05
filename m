Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYFEQic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYFEQic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYFEQiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:38:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbYFEQiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:38:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080602072706.GB28268@linux-sh.org>
References: <20080602072706.GB28268@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB, v2.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 05 Jun 2008 17:26:25 +0100
Message-ID: <16911.1212683185@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul Mundt <lethal@linux-sh.org> wrote:

> kobjsize() has been abusing page->index as a method for sorting out
> compound order, which blows up both for page cache pages, and SLOB's
> reuse of the index in struct slob_page.
> 
> Presently we are not able to accurately size arbitrary pointers that
> don't come from kmalloc(), so the best we can do is sort out the
> compound order from the head page if it's a compound page, or default
> to 0-order if it's impossible to ksize() the object.
> 
> Obviously this leaves quite a bit to be desired in terms of object
> sizing accuracy, but the behaviour is unchanged over the existing
> implementation, while fixing the page->index oopses originally reported
> here:
> 
> 	http://marc.info/?l=linux-mm&m=121127773325245&w=2
> 
> Accuracy could also be improved by having SLUB and SLOB both set PG_slab
> on ksizeable pages, rather than just handling the __GFP_COMP cases
> irregardless of the PG_slab setting, as made possibly with Pekka's
> patches:
> 
> 	http://marc.info/?l=linux-kernel&m=121139439900534&w=2
> 	http://marc.info/?l=linux-kernel&m=121139440000537&w=2
> 	http://marc.info/?l=linux-kernel&m=121139440000540&w=2
> 
> This is primarily a bugfix for nommu systems for 2.6.26, with the aim
> being to gradually kill off kobjsize() and its particular brand of
> object abuse entirely.
> 
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

With this patch, SLOB now works on my FRV board.

Acked-by: David Howells <dhowells@redhat.com>
