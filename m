Return-Path: <linux-kernel-owner+w=401wt.eu-S1764635AbXIKUEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764635AbXIKUEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934193AbXIKUBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:01:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55152 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934060AbXIKUBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:01:53 -0400
Date: Tue, 11 Sep 2007 13:01:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709110452.20363.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709111256250.25781@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Nick Piggin wrote:

> There is a limitation in the VM. Fragmentation. You keep saying this
> is a solved issue and just assuming you'll be able to fix any cases
> that come up as they happen.
> 
> I still don't get the feeling you realise that there is a fundamental
> fragmentation issue that is unsolvable with Mel's approach.

Well my problem first of all is that you did not read the full message. It 
discusses that later and provides page pools to address the issue.

Secondly you keep FUDding people with lots of theoretical concerns 
assuming Mel's approaches must fail. If there is an issue (I guess there 
must be right?) then please give us a concrete case of a failure that we 
can work against.

> The idea that there even _is_ a bug to fail when higher order pages
> cannot be allocated was also brushed aside by some people at the
> vm/fs summit. I don't know if those people had gone through the
> math about this, but it goes somewhat like this: if you use a 64K
> page size, you can "run out of memory" with 93% of your pages free.
> If you use a 2MB page size, you can fail with 99.8% of your pages
> still free. That's 64GB of memory used on a 32TB Altix.

Allocations can currently fail and all code has the requirement to handle 
failure cases in one form or another.

Currently we can only handle up to order 3 allocs it seems. 2M pages (and 
in particular pagesizes > MAX_ORDER) will have to be handled by a separate 
large page pool facility discussed in the earlier message.
