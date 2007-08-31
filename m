Return-Path: <linux-kernel-owner+w=401wt.eu-S1763655AbXHaBsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763655AbXHaBsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 21:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbXHaBru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 21:47:50 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46908 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751398AbXHaBrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 21:47:49 -0400
Date: Thu, 30 Aug 2007 18:47:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Dmitry Monakhov <dmonakhov@sw.ru>
cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [11/36] Use page_cache_xxx in fs/buffer.c
In-Reply-To: <Pine.LNX.4.64.0708301113170.7975@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0708301843280.13292@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828190730.220393749@sgi.com>
 <20070830092038.GD22586@dnb.sw.ru> <Pine.LNX.4.64.0708301113170.7975@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This may already be handled?

submit_bh() calls submit_bio() which calls __generic_make_request() and 
there we do:

                if (unlikely(bio_sectors(bio) > q->max_hw_sectors)) {
                        printk("bio too big device %s (%u > %u)\n",
                                bdevname(bio->bi_bdev, b),
                                bio_sectors(bio),
                                q->max_hw_sectors);
                        goto end_io;
                }

So if we try to push a too large buffer down with submit_bh() we get a 
failure.

