Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbYBZPmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbYBZPmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760554AbYBZPmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:42:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47626 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762862AbYBZPmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:42:12 -0500
Subject: Re: [PATCH 00/28] Swap over NFS -v16
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: neilb@suse.de, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no
In-Reply-To: <E1JU1kk-0001t9-25@pomaz-ex.szeredi.hu>
References: <20080220144610.548202000@chello.nl>
	 <20080223000620.7fee8ff8.akpm@linux-foundation.org>
	 <18371.43950.150842.429997@notabene.brown>
	 <1204023042.6242.271.camel@lappy>  <E1JU1kk-0001t9-25@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 16:41:57 +0100
Message-Id: <1204040517.6242.324.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-26 at 16:29 +0100, Miklos Szeredi wrote:
> > > mm-page_file_methods.patch
> > > 
> > >     This makes page_offset and others more expensive by adding a
> > >     conditional jump to a function call that is not usually made.
> > > 
> > >     Why do swap pages have a different index to everyone else?
> > 
> > Because the page->index of an anonymous page is related to its (anon)vma
> > so that it satisfies the constraints for vm_normal_page().
> > 
> > The index in the swap file it totally unrelated and quite random. Hence
> > the swap-cache uses page->private to store it in.
> 
> Yeah, and putting the condition into page_offset() will confuse code
> which uses it for finding the offset in the VMA 

Right, do we do that anywhere?

> or in a tmpfs file.

Good point. I really should go read tmpfs some day, its really a blind
spot for me.

> So why not just have a separate page_swap_offset() function, used
> exclusively by swap_in/out()?

That would require duplicating quite a lot of NFS code from what I can
see.

