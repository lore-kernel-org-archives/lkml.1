Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYCRITK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYCRITK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 04:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYCRIS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 04:18:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbYCRISz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 04:18:55 -0400
Date: Tue, 18 Mar 2008 01:18:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 4/8] mm: allow not updating BDI stats in
 end_page_writeback()
Message-Id: <20080318011811.252c7c59.akpm@linux-foundation.org>
In-Reply-To: <E1JbWvF-0005Hr-Ur@pomaz-ex.szeredi.hu>
References: <20080317191908.123631326@szeredi.hu>
	<20080317191945.122011759@szeredi.hu>
	<20080317220431.a8507e29.akpm@linux-foundation.org>
	<E1JbWvF-0005Hr-Ur@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 09:11:49 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > 
> > Reason: bdi_cap_writeback_dirty() is kinda weirdly intrepreted to mean
> > various different things in different places and we really should separate
> > its multiple interpretations into separate flags.
> > 
> > Note that this becomes a standalone VFS cleanup patch, and the fuse code
> > can then just use it later on.  
> 
> Hmm, I can see two slightly different meanings of bdi_cap_writeback_dirty():
> 
>  1) need to call ->writepage (sync_page_range(), ...)
>  2) need to update BDI stats  (test_clear_page_writeback(), ...)
> 
> If these two were different flags, then fuse could set the
> NEED_WRITEPAGE flag, but clear the NEED_UPDATE_BDI_STATS flag, and do
> it manually.
> 
> Does that sound workable?

Yup, thanks.
