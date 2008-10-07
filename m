Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbYJGS7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbYJGS7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbYJGS7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:59:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:43487 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYJGS7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:59:42 -0400
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
	arch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <20081007105056.16d9e785.akpm@linux-foundation.org>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2>
	 <6.0.0.20.2.20081007183452.0f052210@172.19.0.2>
	 <20081007102942.GE20740@one.firstfloor.org>
	 <200810080327.44530.nickpiggin@yahoo.com.au>
	 <20081007105056.16d9e785.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 20:59:23 +0200
Message-Id: <1223405963.26330.83.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 10:50 -0700, Andrew Morton wrote:
> On Wed, 8 Oct 2008 03:27:44 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > So.. is everyone agreed that corrupting f_pos is a bad thing? (serious
> > question) If so, then we should get something like this merged sooner
> > rather than later.
> 
> - two threads/processes sharing the same fd
> 
> - both appending the same fd
> 
> - both hit the small race window right around the time when the file
>   flips over a multiple of 4G.
> 
> It's pretty damn improbable, and I think we can afford to spend the
> time to get this right in 2.6.29.

The whole point is that such usage is outside the specification and thus
we don't strictly need to fix this.

So the question Nick is asking is, do we want to slow down the kernel
for a few broken user-space applications. Esp. since the race doesn't
affect anybody else except the broken users of the file descriptor.

IMHO not worth fixing..

