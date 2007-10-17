Return-Path: <linux-kernel-owner+w=401wt.eu-S1760369AbXJQM2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369AbXJQM2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 08:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbXJQM2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 08:28:44 -0400
Received: from mx1.suse.de ([195.135.220.2]:33817 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbXJQM2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 08:28:43 -0400
Date: Wed, 17 Oct 2007 14:28:42 +0200
From: Nick Piggin <npiggin@suse.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: mikulas@artax.karlin.mff.cuni.cz, arjan@infradead.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
Message-ID: <20071017122842.GB14401@wotan.suse.de>
References: <20071016002229.GA5851@wotan.suse.de> <E1Ii1oL-0005I3-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ii1oL-0005I3-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 01:51:17PM +0800, Herbert Xu wrote:
> Nick Piggin <npiggin@suse.de> wrote:
> >
> > Also, for non-wb memory. I don't think the Intel document referenced
> > says anything about this, but the AMD document says that loads can pass
> > loads (page 8, rule b).
> > 
> > This is why our rmb() is still an lfence.
> 
> BTW, Xen (in particular, the code in drivers/xen) uses mb/rmb/wmb
> instead of smp_mb/smp_rmb/smp_wmb when it accesses memory that's
> shared with other Xen domains or the hypervisor.
> 
> The reason this is necessary is because even if a Xen domain is
> UP the hypervisor might be SMP.
> 
> It would be nice if we can have these adopt the new SMP barriers
> on x86 instead of the IO ones as they currently do.

That's a good point actually. Something like raw_smp_*mb, which
always orders memory, but only for regular WB operatoins. I could
put that on the todo list...

