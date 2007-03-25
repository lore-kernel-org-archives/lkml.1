Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbXCYLfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbXCYLfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 07:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXCYLfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 07:35:45 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:41508 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXCYLfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 07:35:31 -0400
To: a.p.zijlstra@chello.nl
CC: akpm@linux-foundation.org, dgc@sgi.com, linux-kernel@vger.kernel.org
In-reply-to: <E1HVQe9-0007ga-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Sun, 25 Mar 2007 13:12:25 +0200)
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu> <1174816995.5149.4.camel@lappy> <E1HVQe9-0007ga-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HVQzy-0007jO-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 25 Mar 2007 13:34:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Please have a look at this:
> >   http://lkml.org/lkml/2007/3/19/220
> 
> 
> 
> > +			if (bdi_nr_reclaimable + bdi_stat(bdi, BDI_WRITEBACK) <=
> > +			     	bdi_thresh)
> > +				break;
> > 
> 
> Yes, this will resolve the deadlock as well, where balance_dirty_pages()
> is currently looping forever with:

Almost.

This

> -		if (nr_reclaimable) {
> +		if (bdi_nr_reclaimable) {
>  			writeback_inodes(&wbc);

still makes it loop forever if bdi_nr_reclaimable == 0, since the exit
condition is not checked. 

Shouldn't it break out of the loop if bdi_stat(bdi, BDI_WRITEBACK) <=
bdi_thresh in this case?

Thanks,
Miklos
