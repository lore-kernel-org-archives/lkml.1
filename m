Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbXJKRhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbXJKRhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 13:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXJKRgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 13:36:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51730 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752461AbXJKRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 13:36:53 -0400
Date: Thu, 11 Oct 2007 10:36:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
In-Reply-To: <961aa3350710111024jbcfd3e3q959bdb2d3c2828fe@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710111036090.31811@schroedinger.engr.sgi.com>
References: <20071009161328.GA6470@APFDCB5C> 
 <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com> 
 <20071010121853.GA3911@APFDCB5C>  <Pine.LNX.4.64.0710101037210.7158@schroedinger.engr.sgi.com>
  <20071011143656.GA3972@APFDCB5C>  <Pine.LNX.4.64.0710110944270.31423@schroedinger.engr.sgi.com>
 <961aa3350710111024jbcfd3e3q959bdb2d3c2828fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007, Akinobu Mita wrote:

> > > This means get_cpu_slab() always return NULL when CPU is being onlined.
> > > So I can't use get_cpu_slab to check whether kmem_cache_cpu_free
> > > initalization for the CPU has already been done or not.
> >
> > If you have set it to NULL then the earlier kmem_cache_cpu structures has
> > been freed. Why is it a problem to allocate another one when the cpu comes
> > up again?
> >
> 
> kmem_cache_cpu_free per-cpu singly list will be broken by calling
> init_alloc_cpu_cpu() twice. It happens when online/offlining CPU.
> All three patches I send attempt to make init_alloc_cpu_cpu()
> called only once for each cpu.

Ahhh.. Its the initialization of the kmem_cache_cpu pool that is the issue 
not the allocation of the kmem_cache_cpu() structure.

