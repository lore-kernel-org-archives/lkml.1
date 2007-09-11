Return-Path: <linux-kernel-owner+w=401wt.eu-S965716AbXIKVss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965716AbXIKVss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbXIKVse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:48:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35893 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758138AbXIKVsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:48:32 -0400
Date: Tue, 11 Sep 2007 14:48:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@skynet.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709111600.18756.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709111446080.27023@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709111144.48743.nickpiggin@yahoo.com.au>
 <20070911205350.GA18127@skynet.ie> <200709111600.18756.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Nick Piggin wrote:

> But that's not my place to say, and I'm actually not arguing that high
> order pagecache does not have uses (especially as a practical,
> shorter-term solution which is unintrusive to filesystems).
> 
> So no, I don't think I'm really going against the basics of what we agreed
> in Cambridge. But it sounds like it's still being billed as first-order
> support right off the bat here.

Well its seems that we have different interpretations of what was agreed 
on. My understanding was that the large blocksize patchset was okay 
provided that I supply an acceptable mmap implementation and put a 
warning in.

> But even so, you can just hold an open fd in order to pin the dentry you
> want. My attack would go like this: get the page size and allocation group
> size for the machine, then get the number of dentries required to fill a
> slab. Then read in that many dentries and pin one of them. Repeat the
> process. Even if there is other activity on the system, it seems possible
> that such a thing will cause some headaches after not too long a time.
> Some sources of pinned memory are going to be better than others for
> this of course, so yeah maybe pagetables will be a bit easier (I don't know).

Well even without slab targeted reclaim: Mel's antifrag will sort the 
dentries into separate blocks of memory and so isolate the issue.
