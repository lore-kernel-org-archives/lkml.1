Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbZJSHf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbZJSHf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZJSHf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:35:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbZJSHf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:35:27 -0400
Date: Mon, 19 Oct 2009 09:35:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-m68k <linux-m68k@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH] [RFC] ataflop: remove buggy IRQ disable from
 do_fd_request()
In-Reply-To: <alpine.DEB.2.00.0910182126120.6395@zirkon.biophys.uni-duesseldorf.de>
Message-ID: <alpine.LSU.2.00.0910190932030.8582@wotan.suse.de>
References: <alpine.LSU.2.00.0910091141150.19284@wotan.suse.de> <10f740e80910100201n30367714uc57ec3c9c39b92af@mail.gmail.com> <alpine.DEB.2.00.0910110846420.20140@zirkon.biophys.uni-duesseldorf.de> <alpine.LSU.2.00.0910121106330.19284@wotan.suse.de>
 <alpine.DEB.2.00.0910182126120.6395@zirkon.biophys.uni-duesseldorf.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Oct 2009, Michael Schmitz wrote:

> > The patch is not removing any locking. It only
> > 
> > 1) removes the local_irq_disable() that has been commented out for many 
> >    years already anyway
> > 2) removes the saving and restoring of CPU flags around do_fd_request(), 
> >    which is rather clearly a nop than any kind of "locking"
> > 
> > > > [1] http://lkml.org/lkml/2002/12/27/58
> > > > 
> > > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > > 
> > > NAck for my part. 
> > 
> > Please elaborate a little bit more which of the two points above you base 
> > your NACK on.
> 
> The removal of local_irq_disable() (which should have been local_irq_enable()) 
> just raised a flag, and I didn't immediately see why the interrupt enable had 
> been commented out. 

Yes, it has been commented out in a very non-intuitive way.

> With a bit of further thought on the matter I am satisfied that this patch will 
> not impact on driver function at all, and do not wish to sustain my objection.
> 
> IOW: Ack, and my sincere apologies for wasting your time. 

Thanks, I have added

	Acked-by: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>

to the patch changelog in my tree.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
