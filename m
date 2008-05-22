Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYEVQOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYEVQOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYEVQN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:13:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:65331 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbYEVQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jYslh5XSDnC53kyVcYow3znmktoAT7PYCyXtzQLopUIl8NLohpoxkgcdHetOnfpQzizeqRLlSL/vgU69MmF2JRQj0HTkwHSh/AIVYm84qHk6Rfxr9p/jwy76ntZGNSA3VHT7gCeJvC3t5TKL5f6h850PzWeBznYhzEgzN677gTQ=
Message-ID: <84144f020805220913g344baedaqb0996adecdadae99@mail.gmail.com>
Date: Thu, 22 May 2008 19:13:56 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Christoph Lameter" <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
In-Reply-To: <1211468502.18026.350.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI>
	 <20080521234555.GB32707@linux-sh.org>
	 <4834F2E2.3070806@cs.helsinki.fi>
	 <Pine.LNX.4.64.0805212116260.19431@schroedinger.engr.sgi.com>
	 <4834F4DC.3040009@cs.helsinki.fi> <20080522043410.GA4050@linux-sh.org>
	 <4834F9D6.7080706@cs.helsinki.fi> <1211468502.18026.350.camel@calx>
X-Google-Sender-Auth: 5d15c68dab93ed06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Thu, May 22, 2008 at 6:01 PM, Matt Mackall <mpm@selenic.com> wrote:
> As I've said several times, ksize() on kmem_cache_alloced objects
> -cannot work- on SLOB. Calling ksize() on something returned by
> kmem_cache_alloc is a categorical error.

Well, it's a historical fact that ksize() worked for both kmalloc()
and kmem_cache_alloc() (see the kernedoc comment in mm/slab.c).
However, I think we should just look at getting rid of ksize()
altogether as it's only (ab)used by the nommu code and few call-sites
that open-code krealloc().

                       Pekka
