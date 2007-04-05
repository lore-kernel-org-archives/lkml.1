Return-Path: <linux-kernel-owner+w=401wt.eu-S965896AbXDEJkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965896AbXDEJkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 05:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965913AbXDEJkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 05:40:18 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:37139 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965896AbXDEJkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 05:40:17 -0400
To: a.p.zijlstra@chello.nl
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-to: <1175765760.6483.93.camel@twins> (message from Peter Zijlstra on
	Thu, 05 Apr 2007 11:36:00 +0200)
Subject: Re: [patch 2/2] only allow nonlinear vmas for ram backed
	filesystems
References: <E1HZOHe-0000RL-00@dorka.pomaz.szeredi.hu>
	 <E1HZOIr-0000Rv-00@dorka.pomaz.szeredi.hu> <1175765760.6483.93.camel@twins>
Message-Id: <E1HZORc-0000UZ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Apr 2007 11:39:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		/*
> > +		 * page_mkclean doesn't work on nonlinear vmas, so if dirty
> > +		 * pages need to be accounted, emulate with linear vmas.
> > +		 */
> > +		if (mapping_cap_account_dirty(mapping)) {
> 
> Perhaps this should read:
> 
> 		if (vma_wants_writenotify(vma)) {
> 

I looked at that, but IIRC vma_wants_writenotify() doesn't work after
mmap(), because of the updated protection bits.

> That way we would even allow read only non-linear mappings of 'real'
> filesystem files.

Well, we could do that, but is it really worth the hassle?  The real
question is whether anyone would want to use non-linear
shared-read-only mappings or not.

Thanks,
Miklos
