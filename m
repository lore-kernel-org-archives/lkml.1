Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbXH1TyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbXH1TyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbXH1TyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:54:04 -0400
Received: from lazybastard.de ([212.112.238.170]:45406 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbXH1TyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:54:01 -0400
Date: Tue, 28 Aug 2007 21:49:38 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: clameter@sgi.com
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [07/36] Use page_cache_xxx in mm/filemap_xip.c
Message-ID: <20070828194937.GA23020@lazybastard.org>
References: <20070828190551.415127746@sgi.com> <20070828190729.308864359@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070828190729.308864359@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 August 2007 12:05:58 -0700, clameter@sgi.com wrote:
>  
> -	index = *ppos >> PAGE_CACHE_SHIFT;
> -	offset = *ppos & ~PAGE_CACHE_MASK;
> +	index = page_cache_index(mapping, *ppos);
> +	offset = page_cache_offset(mapping, *ppos);

Part of me feels inclined to marge this patch now because it makes the
code more readable, even if page_cache_index() is implemented as
#define page_cache_index(mapping, pos) ((pos) >> PAGE_CACHE_SHIFT)

I know there is little use in yet another global search'n'replace
wankfest and Andrew might wash my mouth just for mentioning it.  Still,
hard to dislike this part of your patch.

Jörn

-- 
He who knows others is wise.
He who knows himself is enlightened.
-- Lao Tsu
