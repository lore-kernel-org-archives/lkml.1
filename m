Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbYEZHVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbYEZHVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 03:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYEZHVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 03:21:31 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60249 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYEZHVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 03:21:30 -0400
Message-Id: <6.0.0.20.2.20080526155336.058ed7b0@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Mon, 26 May 2008 16:20:10 +0900
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] VFS: Pagecache usage optimization on pagesize
  !=blocksize environment
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080523225133.GB30591@atrey.karlin.mff.cuni.cz>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
 <20080521001930.202446eb.akpm@linux-foundation.org>
 <6.0.0.20.2.20080522160939.051ca938@172.19.0.2>
 <20080522010355.32590474.akpm@linux-foundation.org>
 <20080523225133.GB30591@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  But I'm slightly confused that the patch helps because I've always
>thought that mpage_readpage() (which is what we end up calling from
>do_generic_mapping_read()) always reads the whole page. Thus either all
>buffers in the page or none of them are uptodate... So what do I miss
>here?
>
>								Honza

On ext3/4, a file is written through buffer/block. So if a page has multiple 
buffers, buffers can be uptodate partially especially under random write workloads.
See __block_prepare_write and __block_commit_write.

