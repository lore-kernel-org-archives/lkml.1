Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbYEWWvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbYEWWvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbYEWWvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:51:35 -0400
Received: from [195.113.26.193] ([195.113.26.193]:34703 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758896AbYEWWve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:51:34 -0400
Date: Sat, 24 May 2008 00:51:33 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Pagecache usage optimization on pagesize !=blocksize environment
Message-ID: <20080523225133.GB30591@atrey.karlin.mff.cuni.cz>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2> <20080521001930.202446eb.akpm@linux-foundation.org> <6.0.0.20.2.20080522160939.051ca938@172.19.0.2> <20080522010355.32590474.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522010355.32590474.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 22 May 2008 16:31:15 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:
> 
> One other thing we should think about here is the `nobh' mode which the
> extX filesystems support (although I have a feeling that Nick might
> have broken this ;)) We also have data=ordered, data=writeback and
> data=journal to think about.  This optimisation might not be
> appropriate at all to data=journal mode, but I haven't looked into
> that.
  Why do you think so? We mess with buffer_dirty bits in data=journal
mode but as far as I understand the patch, it only does not read the
page if the part we need is marked as uptodate in buffers. And this
should be safe.
  But I'm slightly confused that the patch helps because I've always
thought that mpage_readpage() (which is what we end up calling from
do_generic_mapping_read()) always reads the whole page. Thus either all
buffers in the page or none of them are uptodate... So what do I miss
here?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
