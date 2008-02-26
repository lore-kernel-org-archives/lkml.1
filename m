Return-Path: <linux-kernel-owner+w=401wt.eu-S1762764AbYBZPaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762764AbYBZPaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYBZPaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:30:16 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41203 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYBZPaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:30:14 -0500
To: a.p.zijlstra@chello.nl
CC: neilb@suse.de, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no
In-reply-to: <1204023042.6242.271.camel@lappy> (message from Peter Zijlstra on
	Tue, 26 Feb 2008 11:50:42 +0100)
Subject: Re: [PATCH 00/28] Swap over NFS -v16
References: <20080220144610.548202000@chello.nl>
	 <20080223000620.7fee8ff8.akpm@linux-foundation.org>
	 <18371.43950.150842.429997@notabene.brown> <1204023042.6242.271.camel@lappy>
Message-Id: <E1JU1kk-0001t9-25@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 26 Feb 2008 16:29:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > mm-page_file_methods.patch
> > 
> >     This makes page_offset and others more expensive by adding a
> >     conditional jump to a function call that is not usually made.
> > 
> >     Why do swap pages have a different index to everyone else?
> 
> Because the page->index of an anonymous page is related to its (anon)vma
> so that it satisfies the constraints for vm_normal_page().
> 
> The index in the swap file it totally unrelated and quite random. Hence
> the swap-cache uses page->private to store it in.

Yeah, and putting the condition into page_offset() will confuse code
which uses it for finding the offset in the VMA or in a tmpfs file.

So why not just have a separate page_swap_offset() function, used
exclusively by swap_in/out()?

Miklos
