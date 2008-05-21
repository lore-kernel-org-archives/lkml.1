Return-Path: <linux-kernel-owner+w=401wt.eu-S937722AbYEUVOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937722AbYEUVOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937401AbYEUVMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:12:08 -0400
Received: from relay2.sgi.com ([192.48.171.30]:44367 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937537AbYEUVMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:12:05 -0400
Date: Wed, 21 May 2008 14:12:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, dhowells@redhat.com
Subject: Re: [RFC/PATCH 3/3] SLOB: make ksize() more strict for page allocator
 pass-through
In-Reply-To: <483473EA.40901@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0805211411050.17853@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805212125570.22291@sbz-30.cs.Helsinki.FI>
 <1211396840.18026.276.camel@calx> <483473EA.40901@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Pekka Enberg wrote:

> Matt Mackall wrote:
> > We already know users (ie nommu memory usage reporting) are abusing this
> > interface. Making them blow up is unnecessary. Just give them wrong
> > answers. Issuing a warning might be a good idea for debugging.
> 
> But kobjsize() never calls ksize() with SLOB as it doesn't set PageSlab. Or
> are you talking about something else here?
> 
> Matt Mackall wrote:
> > Second, I'd prefer to keep this sort of debugging code out of SLOB.
> > SLUB is much better suited to debugging allocator abuse.
> 
> Fair enough. I'll drop the patch.

I also would prefer to keep this out of SLUB. Set/Clear PageSlab dirties 
the cacheline and it forces the unlining of kmalloc_large.

