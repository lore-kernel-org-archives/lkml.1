Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYFXTYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYFXTYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 15:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYFXTYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 15:24:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52191 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYFXTYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 15:24:32 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <alpine.LFD.1.10.0806241216350.2926@woody.linux-foundation.org>
	(message from Linus Torvalds on Tue, 24 Jun 2008 12:17:44 -0700 (PDT))
Subject: Re: [rfc patch 3/4] splice: remove confirm from
 pipe_buf_operations
References: <20080621154607.154640724@szeredi.hu> <20080621154726.494538562@szeredi.hu> <20080624080440.GJ20851@kernel.dk> <E1KB4Id-0000un-PV@pomaz-ex.szeredi.hu> <20080624111913.GP20851@kernel.dk> <E1KB6p9-0001Gq-Fd@pomaz-ex.szeredi.hu>
 <alpine.LFD.1.10.0806241022120.2926@woody.linux-foundation.org> <E1KBDBg-0002XZ-DG@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0806241129590.2926@woody.linux-foundation.org> <E1KBDpg-0002bR-3X@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0806241216350.2926@woody.linux-foundation.org>
Message-Id: <E1KBE7p-0002eT-CJ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Jun 2008 21:24:21 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Let's start with page_cache_pipe_buf_confirm().  How should we deal
> > with finding an invalidated page (!PageUptodate(page) &&
> > !page->mapping)?
> 
> I suspect we just have to use it. After all, it was valid when the read 
> was done. The fact that it got invalidated later is kind of immaterial.

Right.  But what if it's invalidated *before* becoming uptodate (if
you'd read my mail further, I discussed this).

Why does invalidate_complete_page2() do ClearPageUptodate()?  Dunno,
maybe it shoulnd't.  But that would need a rather thorough audit of
all code checking PageUptodate()...

> splice() is an optimized read+write. The read reads it into a temporary 
> buffer. The fact that it's a zero-copy buffer and basically just re-uses 
> the source doesn't really change that.

Agreed.

Miklos
