Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYAOUlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYAOUlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYAOUkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:40:52 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58512 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbYAOUkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:40:51 -0500
To: a.p.zijlstra@chello.nl
CC: miklos@szeredi.hu, salikhmetov@gmail.com, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com
In-reply-to: <1200429167.26045.45.camel@twins> (message from Peter Zijlstra on
	Tue, 15 Jan 2008 21:32:47 +0100)
Subject: Re: [PATCH 0/2] Updating ctime and mtime for memory-mapped files
	[try #4]
References: <12004129652397-git-send-email-salikhmetov@gmail.com>
	 <E1JEsNJ-00026T-7B@pomaz-ex.szeredi.hu> <1200429167.26045.45.camel@twins>
Message-Id: <E1JEsaV-00028A-EB@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Jan 2008 21:40:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2008-01-15 at 21:27 +0100, Miklos Szeredi wrote:
> > > 1. Introduction
> > > 
> > > This is the fourth version of my solution for the bug #2645:
> > > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=2645
> > > 
> > > Changes since the previous version:
> > > 
> > > 1) the case of retouching an already-dirty page pointed out
> > >   by Miklos Szeredi has been addressed;
> > 
> > I'm a bit sceptical, as we've also pointed out, that this is not
> > possible without messing with the page tables.
> > 
> > Did you try my test program on the patched kernel?
> > 
> > I've refreshed the patch, where we left this issue last time.  It
> > should basically have equivalent functionality to your patch, and is a
> > lot simpler.  There might be performance issues with it, but it's a
> > good starting point.
> 
> It has the same problem as Anton's in that it won't get triggered again
> for an already dirty mapped page.

Yes, it's not better in this respect, than Anton's patch.  And it
might be worse performance-wise, since file_update_time() is sure to
be slower, than set_bit().  According to Andrew, this may not actually
matter in practice, but that would have to be benchmarked, I guess.

Miklos
