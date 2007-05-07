Return-Path: <linux-kernel-owner+w=401wt.eu-S965668AbXEGQGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965668AbXEGQGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965472AbXEGQGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:06:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52472 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965440AbXEGQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:06:08 -0400
Date: Mon, 7 May 2007 09:06:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: David Chinner <dgc@sgi.com>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <m17irlkubc.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0705070901400.4290@schroedinger.engr.sgi.com>
References: <20070427042046.GI65285596@melbourne.sgi.com>
 <20070426221528.655d79cb.akpm@linux-foundation.org>
 <20070427060921.GA77450368@melbourne.sgi.com> <20070427000403.6013d1fa.akpm@linux-foundation.org>
 <20070427080321.GG32602149@melbourne.sgi.com> <20070427014849.41f383f7.akpm@linux-foundation.org>
 <20070427164535.GH24852@thunk.org> <m1abwku30d.fsf@ebiederm.dsl.xmission.com>
 <20070507042925.GT32602149@melbourne.sgi.com> <m1tzupkzmw.fsf@ebiederm.dsl.xmission.com>
 <20070507052729.GV32602149@melbourne.sgi.com> <m17irlkubc.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Eric W. Biederman wrote:

> Yes, instead of having to redesign the interface between the
> fs and the page cache for those filesystems that handle large
> blocks we instead need to redesign significant parts of the VM interface.
> Shift the redesign work to another group of people and call it a trivial.

To some extend that is true. But then there will then also be additional 
gain: We can likely get the VM to handle larger pages too which may get 
rid of hugetlb fs etc. The work is pretty straightforward: No locking 
changes f.e. So hardly a redesign. I think the crucial point is the 
antifrag/defrag issue if we want to generalize it.

I have an updated patch here that relies on page reservations. Adds 
something called page pools. On bootup you need to specify how many pages 
of each size you want. The page cache will then use those pages for 
filesystems that need larger blocksize. 

The interesting thing about that one is that it actually enables support 
foir multiple blocksizes with a single larger pagesize. If f.e. we setup a 
pool of 64k pages then the block layer can segment that into 16k pieces. 
So one can actually use 16k 32k and 64k block size with a single larger 
page size.

