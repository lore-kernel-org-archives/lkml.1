Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbXDEJuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbXDEJuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 05:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXDEJuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 05:50:06 -0400
Received: from amsfep19-int.chello.nl ([62.179.120.14]:52455 "EHLO
	amsfep19-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbXDEJuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 05:50:05 -0400
Subject: Re: [patch 2/2] only allow nonlinear vmas for ram backed
	filesystems
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <E1HZORc-0000UZ-00@dorka.pomaz.szeredi.hu>
References: <E1HZOHe-0000RL-00@dorka.pomaz.szeredi.hu>
	 <E1HZOIr-0000Rv-00@dorka.pomaz.szeredi.hu> <1175765760.6483.93.camel@twins>
	 <E1HZORc-0000UZ-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 11:50:00 +0200
Message-Id: <1175766600.6483.100.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 11:39 +0200, Miklos Szeredi wrote:
> > > +		/*
> > > +		 * page_mkclean doesn't work on nonlinear vmas, so if dirty
> > > +		 * pages need to be accounted, emulate with linear vmas.
> > > +		 */
> > > +		if (mapping_cap_account_dirty(mapping)) {
> > 
> > Perhaps this should read:
> > 
> > 		if (vma_wants_writenotify(vma)) {
> > 
> 
> I looked at that, but IIRC vma_wants_writenotify() doesn't work after
> mmap(), because of the updated protection bits.

Right, bother, that again. I fudged it in mprotect by setting the pgprot
bits to what was expected although I had a parametrised version earlier.
But that was disliked.

> > That way we would even allow read only non-linear mappings of 'real'
> > filesystem files.
> 
> Well, we could do that, but is it really worth the hassle?  The real
> question is whether anyone would want to use non-linear
> shared-read-only mappings or not.

Hmm, yeah, I thought that was the case with that code snippet Andrew
pulled of the interweb, but on second inspection they do map it writable
too. I was led astray by the fact that they map the same file twice.

Oh well, lets just keep the patch as is then.

