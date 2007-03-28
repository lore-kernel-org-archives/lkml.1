Return-Path: <linux-kernel-owner+w=401wt.eu-S965635AbXC1Sgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbXC1Sgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965640AbXC1Sgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:36:50 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:60695 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965635AbXC1Sgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:36:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=aAQgfos/7vtKQXpJ4IeOuF/mpBKqRliqmQe6lh/Zi0QIcS8Yy39DOy/Z7MHYy
	2/tfGa8vMdck+hyZHzRqcg6wQ==
Date: Wed, 28 Mar 2007 20:36:47 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: I/O memory barriers vs SMP memory barriers
Message-ID: <20070328183647.GB18351@xi.wantstofly.org>
References: <20070303111427.GB16944@xi.wantstofly.org> <20070303113305.GB10515@flint.arm.linux.org.uk> <20070321221134.GA22497@xi.wantstofly.org> <tnxlkhpgslz.fsf@arm.com> <16051.1174657433@redhat.com> <20070325211542.GD3593@linux.vnet.ibm.com> <20070325213843.GE22126@xi.wantstofly.org> <20070326032418.GA14557@linux.vnet.ibm.com> <20070326084639.GA30291@xi.wantstofly.org> <20070326200711.GA31296@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326200711.GA31296@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 01:07:11PM -0700, Paul E. McKenney wrote:

> > > > Does everybody agree on these semantics, though?  At least David
> > > > seems to think that mb/rmb/wmb aren't required to order normal
> > > > memory accesses against each other..
> > > 
> > > Not on UP.  On SMP, ordering is (almost certainly) required.
> > 
> > 'almost certainly'?  That sounds like there is a possibility that it
> > wouldn't have to?  What does this depend on?
> 
> The underlying memory model of the CPU.  For sequentially consistent
> systems, only compiler barriers are required.  There are very few such
> systems -- MIPS and PA-RISC, if I remember correctly.  Performance
> dictates otherwise.
> 
> I believe that MIPS is -not- sequentially consistent, but have not yet
> purchased an architecture reference manual.

ARM Normal memory (RAM) accesses are weakly ordered, so on SMP, you
need barriers.  (SMP ARM systems are the definite minority, though.)

(For ARM UP, we generally don't care, since most have virtual caches
and are not I/O coherent, and so DMA coherent mappings will be done
as uncached mappings, and uncached mappings are strongly ordered --
except on XScale V3, which supports I/O coherency, and so you need to
use barriers when operating on DMA coherent memory because DMA coherent
mappings are done as Normal memory (which is weakly ordered) when I/O
coherency is enabled.)


> Given that ARM device drivers are accessing MMIO locations, which are
> often slow anyway, how much is ARM really gaining by dropping memory
> barriers when only I/O accesses need be ordered?  Is it measurable?

No idea -- I assume Catalin has looked at this.
