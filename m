Return-Path: <linux-kernel-owner+w=401wt.eu-S1031415AbXDZSTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031415AbXDZSTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031418AbXDZSTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:19:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53766 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031415AbXDZSTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:19:10 -0400
Date: Thu, 26 Apr 2007 11:13:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <463057D9.9030804@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704261110480.3263@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com>
 <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com>
 <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com>
 <463057D9.9030804@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nick Piggin wrote:

> > But what do you mean with it? A block is no longer a contiguous section of
> > memory. So you have redefined the term.
> 
> I don't understand what you mean at all. A block has always been a
> contiguous area of disk.

You want to change the block layer to support larger blocksize than 
PAGE_SIZE right? So you need to segment that larger block into pieces.

> > And you dont care about Mel's work on that level?
> 
> I actually don't like it too much because it can't provide a robust
> solution. What do you do on systems with small memories, or those that
> eventually do get fragmented?

You could f.e. switch off defragmentation and the large block support?

> Actually, I don't know why people are so excited about being able to
> use higher order allocations (I would rather be more excited about
> never having to use them). But for those few places that really need
> it, I'd rather see them use a virtually mapped kernel with proper
> defragmentation rather than putting hacks all through the core code.

Ahh. I knew we were going this way.... Now we have virtual contiguous vs. 
physical discontiguous.... Yuck hackidihack.

> > No this has been tried before and does not work. Why should we loose the
> > capability to work with 4k pages just because there is some data that has to
> > be thrown around in quantity? I'd like to have flexibility here.
> 
> Is that a big problem? Really? You use 16K pages on your IPF systems,
> don't you?

Yes but the processor supports 4k also. I'd rather have a choice. 16k is a 
choice for performance given the current kernel limitations hat wastes 
lots of memory.

