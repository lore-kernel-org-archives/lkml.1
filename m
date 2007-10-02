Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbXJCBJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbXJCBJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbXJCBJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:09:04 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:49057 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751467AbXJCBJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:09:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DLq5bi+ng1JtKdDr+7rUfMhNq8s0brCdpGo8TYnt4JQn2wLzrYqTYvOfVVL6G/j6chnKTYpHNI7ykm1MPpPwtUNaAifEZigcIcTo2wiE74/e1MtATON65zEqyyyPIds0Oo+8uWCJTWprEKkTAPvf5KOvemx3fK7vNb4XFd6yAUI=  ;
X-YMail-OSG: skld1.gVM1k9I.T14Yye6sUs7LxnB2RmUnApj7VrFBnaTvWTA1VfDW0daGQaOSjtXLbGCvPQlw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Date: Tue, 2 Oct 2007 18:37:24 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org
References: <20070919033605.785839297@sgi.com> <1191055513.18147.97.camel@lappy> <Pine.LNX.4.64.0710011358350.19779@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710011358350.19779@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021837.24772.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 07:01, Christoph Lameter wrote:
> On Sat, 29 Sep 2007, Peter Zijlstra wrote:
> > On Fri, 2007-09-28 at 11:20 -0700, Christoph Lameter wrote:
> > > Really? That means we can no longer even allocate stacks for forking.
> >
> > I think I'm running with 4k stacks...
>
> 4k stacks will never fly on an SGI x86_64 NUMA configuration given the
> additional data that may be kept on the stack. We are currently
> considering to go from 8k to 16k (or even 32k) to make things work. So
> having the ability to put the stacks in vmalloc space may be something to
> look at.

i386 and x86-64 already used 8K stacks for years and they have never
really been much problem before.

They only started failing when contiguous memory is getting used up
by other things, _even with_ those anti-frag patches in there.

Bottom line is that you do not use higher order allocations when you do
not need them.
