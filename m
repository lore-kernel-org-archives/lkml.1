Return-Path: <linux-kernel-owner+w=401wt.eu-S1750827AbXCYLN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750827AbXCYLN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 07:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXCYLN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 07:13:26 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:54559 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbXCYLN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 07:13:26 -0400
To: a.p.zijlstra@chello.nl
CC: akpm@linux-foundation.org, dgc@sgi.com, linux-kernel@vger.kernel.org
In-reply-to: <1174816995.5149.4.camel@lappy> (message from Peter Zijlstra on
	Sun, 25 Mar 2007 12:03:14 +0200)
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu> <1174816995.5149.4.camel@lappy>
Message-Id: <E1HVQe9-0007ga-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 25 Mar 2007 13:12:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 2007-03-24 at 22:55 +0100, Miklos Szeredi wrote:
> > This is a slightly different take on the fix for the deadlock in fuse
> > with dirty balancing.  David Chinner convinced me, that per-bdi
> > counters are too expensive, and that it's not worth trying to account
> > the number of pages under writeback, as they will be limited by the
> > queue anyway.
> > 
> 
> Please have a look at this:
>   http://lkml.org/lkml/2007/3/19/220



> +			if (bdi_nr_reclaimable + bdi_stat(bdi, BDI_WRITEBACK) <=
> +			     	bdi_thresh)
> +				break;
> 

Yes, this will resolve the deadlock as well, where balance_dirty_pages()
is currently looping forever with:

  bdi_nr_reclaimable + bdi_stat(bdi, BDI_WRITEBACK) == 0

Thanks,
Miklos
