Return-Path: <linux-kernel-owner+w=401wt.eu-S932912AbXH3SOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbXH3SOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932454AbXH3SOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:14:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47644 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932348AbXH3SOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:14:42 -0400
Date: Thu, 30 Aug 2007 11:14:39 -0700 (PDT)
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
In-Reply-To: <20070830092038.GD22586@dnb.sw.ru>
Message-ID: <Pine.LNX.4.64.0708301113170.7975@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828190730.220393749@sgi.com>
 <20070830092038.GD22586@dnb.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Dmitry Monakhov wrote:

> On 12:06 Tue 28 Aug     , clameter@sgi.com wrote:
> > Use page_cache_xxx in fs/buffer.c.
> submit_bh wasn't changed this means what bio pages may have huge size
> without respect to queue reqsrictions (q->max_hw_segments, and etc)
> At least driver/md/raid0 will be broken by you'r patch.

Hmmm... So we need to check the page size and generate multiple requests 
in submit_bh?
