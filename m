Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbZJFSTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbZJFSTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932655AbZJFSTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:19:38 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:40083 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbZJFSTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:19:37 -0400
Date: Tue, 6 Oct 2009 11:18:59 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, David Howells <dhowells@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [Alacrityvm-devel] [PATCH v2 2/4] KVM: introduce "xinterface"
 API for external	interaction with guests
Message-ID: <20091006181859.GD6386@ovro.caltech.edu>
References: <20091002201159.4014.33268.stgit@dev.haskins.net>
 <20091002201927.4014.29432.stgit@dev.haskins.net>
 <4AC8780D.1060800@redhat.com>
 <4ACA87D7.1080206@gmail.com>
 <4ACB0F3C.1000705@redhat.com>
 <4ACB46AD.8010405@gmail.com>
 <4ACB6E21.8010109@redhat.com>
 <4ACB771E.8050404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACB771E.8050404@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 06 Oct 2009 11:19:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 12:58:06PM -0400, Gregory Haskins wrote:
> Avi Kivity wrote:
> > On 10/06/2009 03:31 PM, Gregory Haskins wrote:
> >>
> >>> slots would be one implementation, if you can think of others then you'd
> >>> add them.
> >>>      
> >> I'm more interested in *how* you'd add them more than "if" we would add
> >> them.  What I am getting at are the logistics of such a beast.
> >>    
> > 
> > Add alternative ioctls, or have one ioctl with a 'type' field.
> > 
> >> For instance, would I have /dev/slots-vas with ioctls for adding slots,
> >> and /dev/foo-vas for adding foos?  And each one would instantiate a
> >> different vas_struct object with its own vas_struct->ops?  Or were you
> >> thinking of something different.
> >>    
> > 
> > I think a single /dev/foo is sufficient, unless some of those address
> > spaces are backed by real devices.
> > 
> >>> If you can't, I think it indicates that the whole thing isn't necessary
> >>> and we're better off with slots and virtual memory.
> >>>      
> >> I'm not sure if we are talking about the same thing yet, but if we are,
> >> there are uses of a generalized interface outside of slots/virtual
> >> memory (Ira's physical box being a good example).
> >>    
> > 
> > I'm not sure Ira's case is not best supported by virtual memory.
> 
> Perhaps, but there are surely some cases where the memory is not
> pageable, but is accessible indirectly through some DMA controller.  So
> if we require it to be pagable we will limit the utility of the
> interface, though admittedly it will probably cover most cases.
> 

The limitation I have is that memory made available from the host system
(PCI card) as PCI BAR1 must not be migrated around in memory. I can only
change the address decoding to hit a specific physical address. AFAIK,
this means it cannot be userspace memory (since the underlying physical
page could change, or it could be in swap), and must be allocated with
something like __get_free_pages() or dma_alloc_coherent().

This is how all 83xx powerpc boards work, and I'd bet that the 85xx and
86xx boards work almost exactly the same. I can't say anything about
non-powerpc boards.

Ira
