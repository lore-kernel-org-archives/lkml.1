Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbXK0Xmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbXK0Xmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760258AbXK0Xme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:42:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760232AbXK0Xmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:42:33 -0500
Date: Tue, 27 Nov 2007 15:42:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: andi@firstfloor.org, travis@sgi.com, ak@suse.de, pageexec@freemail.hu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: Prevent dereferencing non-allocated per_cpu
 variables
Message-Id: <20071127154213.11970e63.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0711271522050.6713@schroedinger.engr.sgi.com>
References: <20071127215052.090968000@sgi.com>
	<20071127215054.660250000@sgi.com>
	<20071127221628.GG24223@one.firstfloor.org>
	<20071127151241.038c146d.akpm@linux-foundation.org>
	<20071127152122.1d5fbce3.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0711271522050.6713@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 15:22:56 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 27 Nov 2007, Andrew Morton wrote:
> 
> > The prefetch however might still need some work - we can indeed do
> > prefetch() against a not-possible CPU's memory here.  And I do recall that
> > 4-5 years ago we did have a CPU (one of mine, iirc) which would oops when
> > prefetching from a bad address.  I forget what the conclusion was on that
> > matter.
> > 
> > If we do want to fix the prefetch-from-outer-space then we should be using
> > cpu_isset(cpu, *cpumask) here rather than cpu_possible().
> 
> Generally the prefetch things have turned out to be not that useful. How 
> about dropping the prefetch? I kept it because it was there.

I don't recall anyone ever demonstrating that prefetch is useful in-kernel.

I think I've heard of situations where benefits have been seen in userspace
- if a loop does a lot of calculation on each datum which it fetches then
there's a good opportunity to pipeline the fetch with the on-core
crunching.  But kernel doesn't do that sort of thing..

