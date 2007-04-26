Return-Path: <linux-kernel-owner+w=401wt.eu-S933278AbXDZHHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbXDZHHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbXDZHHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:07:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37155 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933278AbXDZHHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:07:54 -0400
Date: Thu, 26 Apr 2007 00:07:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <46304C74.9040304@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com>
 <46304C74.9040304@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nick Piggin wrote:

> > > I am working now and again on some code to do this, it is a big job but
> > > I think it is the right way to do it. But it would take a long time to
> > > get stable and supported by filesystems...
> > Ummm... We already have a radix tree for this???? What more is needed? You
> > just need to go through all filesystems and make them use extends.
> 
> I'm talking about block size > page size in the buffer layer.

I fail to see the point of adding another layer when you already have a 
mapping through the radix tree. You just need to change the way the 
filesystem looks up pages.

What are the exact requirement you are trying to address?

You fundamentally cannot address the large blocksize requirements with 4k 
pages since you simply must have larger contiguous memory.

Large blocksize means that the device can do I/O on blocks of that size.

What can be done is to create some kind of fake linearity. At one level 
the radix tree and the address space already provide that. The radix tree 
allows you to find the next page etc. Another approach would be to create 
a virtual address space that fakes linearity even for the processor.

Then there are ways with I/O mmus to avoid the issues again.

However, you still have not addressed the underlying problem of the device 
not being able to do I/O to a larger block of memory.


