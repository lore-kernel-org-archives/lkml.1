Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZBDFO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZBDFO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZBDFOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:14:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbZBDFOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:14:18 -0500
Date: Tue, 3 Feb 2009 21:13:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Roland Dreier <rdreier@cisco.com>, Eli Cohen <eli@mellanox.co.il>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
Message-Id: <20090203211329.d6190a08.akpm@linux-foundation.org>
In-Reply-To: <1233712248.16867.131.camel@pasglop>
References: <20090203164930.GA10101@mtls03>
	<ada8wonnh3t.fsf@cisco.com>
	<1233712248.16867.131.camel@pasglop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Feb 2009 12:50:48 +1100 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2009-02-03 at 17:08 -0800, Roland Dreier wrote:
> > Forwarding Eli's patch below, since PowerPC guys may have missed it.  I
> > guess the question for Ben et al is whether there is any issue with
> > exporting HPAGE_SHIFT for modules (can be EXPORT_SYMBOL_GPL if you feel
> > it's an internal detail).  It would probably make sense to roll this
> > change into the mlx4 change that Eli alludes to below and merge through
> > my tree (with ppc maintainer acks of course), rather than splitting this
> > patch out and introducing cross-tree dependencies (and also separating
> > the rationale for the change from the change itself).
> > 
> > Thanks,
> >   Roland
> > 
> > 
> > Drivers may want to take advantage of the large pages used for memory obtained
> > from hugetlbfs. One example is mlx4_ib which can use much less MTT entries (in
> > the order of HPAGE_SIZE / PAGE_SIZE) when registering such memory, thus scale
> > significantly better when registering larger memory regions. Other drivers
> > could also benefit from this.
> 
> Except that we support multiple large page sizes nowadays ... I think
> the size can be specified per mountpoint of hugetlbfs no ? Thus things
> like mellanox would have to query the page size used for a given
> mapping.
> 
> Do the generic hugetlbfs code provides such an API ? If not, we may need
> to add one.
> 

I think it's something like

	huge_page_size(page_hstate(page))

