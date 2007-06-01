Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbXFAOzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbXFAOzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759943AbXFAOzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:55:49 -0400
Received: from gw.goop.org ([64.81.55.164]:60810 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759785AbXFAOzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:55:48 -0400
Message-ID: <46603371.50808@goop.org>
Date: Fri, 01 Jun 2007 07:55:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: clameter@sgi.com
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [RFC 0/4] CONFIG_STABLE to switch off development checks
References: <20070531002047.702473071@sgi.com>
In-Reply-To: <20070531002047.702473071@sgi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

clameter@sgi.com wrote:
> A while back we talked about having the capability of switching off checks
> like the one for kmalloc(0) for stable kernel releases. This is a first stab
> at such functionality. It adds #ifdef CONFIG_STABLE for now. Maybe we can
> come up with some better way to handle it later. There should alsol be some
> way to set CONFIG_STABLE from the Makefile.
>
> CONFIG_STABLE switches off
>
> - kmalloc(0) check in both slab allocators
> - SLUB banner
> - Makes SLUB tolerate object corruption like SLAB (not sure if we really want
>   to go down this route. See patch)
>   

Perhaps I missed it, but what's the rationale for complaining about
0-sized allocations?  They seem like a perfectly reasonable thing to me;
they turn up at the boundary conditions of many algorithms, and avoiding
them just cruds up the callsites to make them go through hoops to avoid
allocation. 

Why not just do a 1 byte allocation instead, and be done with it?  Any
non-constant-sized allocation will potentially have to deal with this
case, so it seems to me we could just put the fix in common code (and
use an inline wrapper to avoid it when dealing with constant non-zero
sized allocations).

    J
