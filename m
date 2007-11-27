Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXK0XXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXK0XXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbXK0XW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:22:58 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36665 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757130AbXK0XW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:22:57 -0500
Date: Tue, 27 Nov 2007 15:22:56 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: andi@firstfloor.org, travis@sgi.com, ak@suse.de, pageexec@freemail.hu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: Prevent dereferencing non-allocated per_cpu
 variables
In-Reply-To: <20071127152122.1d5fbce3.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711271522050.6713@schroedinger.engr.sgi.com>
References: <20071127215052.090968000@sgi.com> <20071127215054.660250000@sgi.com>
 <20071127221628.GG24223@one.firstfloor.org> <20071127151241.038c146d.akpm@linux-foundation.org>
 <20071127152122.1d5fbce3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Andrew Morton wrote:

> The prefetch however might still need some work - we can indeed do
> prefetch() against a not-possible CPU's memory here.  And I do recall that
> 4-5 years ago we did have a CPU (one of mine, iirc) which would oops when
> prefetching from a bad address.  I forget what the conclusion was on that
> matter.
> 
> If we do want to fix the prefetch-from-outer-space then we should be using
> cpu_isset(cpu, *cpumask) here rather than cpu_possible().

Generally the prefetch things have turned out to be not that useful. How 
about dropping the prefetch? I kept it because it was there.

