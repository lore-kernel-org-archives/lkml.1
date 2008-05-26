Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYEZLk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYEZLk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYEZLkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:40:52 -0400
Received: from styx.suse.cz ([82.119.242.94]:55520 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754213AbYEZLkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:40:51 -0400
Date: Mon, 26 May 2008 13:40:49 +0200
From: Jan Kara <jack@suse.cz>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Pagecache usage optimization on pagesize
	!=blocksize environment
Message-ID: <20080526114049.GA32407@duck.suse.cz>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2> <20080521001930.202446eb.akpm@linux-foundation.org> <6.0.0.20.2.20080522160939.051ca938@172.19.0.2> <20080522010355.32590474.akpm@linux-foundation.org> <20080523225133.GB30591@atrey.karlin.mff.cuni.cz> <6.0.0.20.2.20080526155336.058ed7b0@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20080526155336.058ed7b0@172.19.0.2>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26-05-08 16:20:10, Hisashi Hifumi wrote:
> 
> >  But I'm slightly confused that the patch helps because I've always
> >thought that mpage_readpage() (which is what we end up calling from
> >do_generic_mapping_read()) always reads the whole page. Thus either all
> >buffers in the page or none of them are uptodate... So what do I miss
> >here?
> >
> >								Honza
> 
> On ext3/4, a file is written through buffer/block. So if a page has multiple 
> buffers, buffers can be uptodate partially especially under random write workloads.
> See __block_prepare_write and __block_commit_write.
  Ah, I see. Thanks for explanation.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
