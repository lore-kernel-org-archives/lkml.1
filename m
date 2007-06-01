Return-Path: <linux-kernel-owner+w=401wt.eu-S1764846AbXFAU7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764846AbXFAU7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763019AbXFAU72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:59:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50764 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762414AbXFAU71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:59:27 -0400
Date: Fri, 1 Jun 2007 13:59:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [RFC 0/4] CONFIG_STABLE to switch off development checks
In-Reply-To: <46606C71.9010008@goop.org>
Message-ID: <Pine.LNX.4.64.0706011357290.4664@schroedinger.engr.sgi.com>
References: <20070531002047.702473071@sgi.com> <46603371.50808@goop.org>
 <Pine.LNX.4.64.0706011126030.2284@schroedinger.engr.sgi.com>
 <46606C71.9010008@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Jeremy Fitzhardinge wrote:

> > An allocation of zero bytes usually indicates that the code is not dealing 
> > with a special case. Later code may operate on the allocated object. I 
> > think its clearer and cleaner if code would deal with that special case 
> > explicitly. We have seen a series of code pieces that do uncomfortably 
> > looking operations on structures with no objects.
> >   
> 
> I disagree.  There are plenty of boundary conditions where 0 is not
> really a special case, and making it a special case just complicates
> things.  I think at least some of the patches posted to silence this
> warning have been generally negative for code quality.  If we were
> seeing lots of zero-sized allocations then that might indicate something
> is amiss, but it seems to me that there's just a scattered handful.
> 
> I agree that it's always a useful debugging aid to make sure that
> allocated regions are not over-run, but 0-sized allocations are not
> special in this regard.

Still insisting on it even after the discovery of the cpuset kmalloc(0) issue?

