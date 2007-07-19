Return-Path: <linux-kernel-owner+w=401wt.eu-S1764313AbXGSVCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764313AbXGSVCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760137AbXGSVB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:01:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6492 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117AbXGSVBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:01:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=QRzhjQqK1DF9hOWjl5ZGoEMR30tbx4tOM+lqwH5CzN4wOg8NlTz1cG3L55BUXa5wy
	2XMl77pavdvvvRZZd1YGg==
Date: Thu, 19 Jul 2007 14:01:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/58] x86_64: various cleanups in NUMA scan node
In-Reply-To: <86802c440707191015u4c6b0e72u17c7674593fb1085@mail.gmail.com>
Message-ID: <alpine.DEB.0.99.0707191349380.16679@chino.kir.corp.google.com>
References: <200707191154.642492000@suse.de>  <20070719095451.3578E14E04@wotan.suse.de>
 <86802c440707191015u4c6b0e72u17c7674593fb1085@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Yinghai Lu wrote:

> > Index: linux/arch/x86_64/mm/srat.c
> > ===================================================================
> > --- linux.orig/arch/x86_64/mm/srat.c
> > +++ linux/arch/x86_64/mm/srat.c
> >  /* maps to convert between proximity domain and logical node ID */
> > -static int pxm_to_node_map[MAX_PXM_DOMAINS]
> > +static int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
> >                                 = { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL
> > };
> > -static int node_to_pxm_map[MAX_NUMNODES]
> > +static int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
> >                                 = { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
> > 
> do we need to put __initdata just before =?
> 

You mangled the quoting of this patch: the deltas above are actually in 
drivers/acpi/numa.c and not arch/x86_64/mm/srat.c.

The placement of __cpuinitdata as shown above is permitted by gcc for a 
section attribute.  I've been corrected by akpm before when I've written 
function declarations such as "static __init int foo()" in preference of 
using the attribute syntax following all type qualifiers, but it is also 
proper syntax.  It's simply a matter of coding style, the semantics of the 
construct are identical.

		David
