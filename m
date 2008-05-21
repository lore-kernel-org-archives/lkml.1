Return-Path: <linux-kernel-owner+w=401wt.eu-S936974AbYEUTHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936974AbYEUTHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759477AbYEUTHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:07:12 -0400
Received: from waste.org ([66.93.16.53]:41324 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756483AbYEUTHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:07:11 -0400
Subject: Re: [RFC/PATCH 3/3] SLOB: make ksize() more strict for page
	allocator pass-through
From: Matt Mackall <mpm@selenic.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com, lethal@linux-sh.org,
       dhowells@redhat.com
In-Reply-To: <Pine.LNX.4.64.0805212125570.22291@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0805212125570.22291@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Date: Wed, 21 May 2008 14:07:20 -0500
Message-Id: <1211396840.18026.276.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-21 at 21:26 +0300, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch re-uses the PG_slab flag for marking SLOB bigblock pages so we can
> check that the pointer passed ksize() was really allocated by SLOB.

Ok, first, BUG_ON is wrong.

We already know users (ie nommu memory usage reporting) are abusing this
interface. Making them blow up is unnecessary. Just give them wrong
answers. Issuing a warning might be a good idea for debugging.

Second, I'd prefer to keep this sort of debugging code out of SLOB.
SLUB is much better suited to debugging allocator abuse.

-- 
Mathematics is the supreme nostalgia of our time.

