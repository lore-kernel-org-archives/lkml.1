Return-Path: <linux-kernel-owner+w=401wt.eu-S1766921AbXDDUOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766921AbXDDUOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766924AbXDDUOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:14:11 -0400
Received: from amsfep15-int.chello.nl ([62.179.120.10]:64903 "EHLO
	amsfep15-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766921AbXDDUOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:14:09 -0400
Subject: Re: [S390] page_mkclean data corruption.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <461405F5.6010303@redhat.com>
References: <200704041759.l34HxCnm014838@hera.kernel.org>
	 <461405F5.6010303@redhat.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 22:14:04 +0200
Message-Id: <1175717644.6483.89.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > ---
> >  mm/rmap.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 22ed3f7..b82146e 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -498,9 +498,9 @@ int page_mkclean(struct page *page)
> >  		struct address_space *mapping = page_mapping(page);
> >  		if (mapping)
> >  			ret = page_mkclean_file(mapping, page);
> > +		if (page_test_and_clear_dirty(page))
> > +			ret = 1;
> >  	}
> > -	if (page_test_and_clear_dirty(page))
> > -		ret = 1;
> >  
> >  	return ret;
> >  }
> 
> This changes generic mm code. Is S390 really the only affected architecture?

Yeah, its the only arch where page_test_and_clear_dirty() is not 0

