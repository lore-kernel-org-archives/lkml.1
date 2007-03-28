Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbXC1VF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbXC1VF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbXC1VF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:05:56 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47872 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752976AbXC1VFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:05:55 -0400
Date: Wed, 28 Mar 2007 14:05:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
In-Reply-To: <20070328134511.0d61ec8f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703281401460.13743@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
 <20070328134511.0d61ec8f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, Andrew Morton wrote:

> I would like to test qlhack on ia64, because ia64 puts pte-pages into the
> quicklists as well, but my ia64 machine is presently indisposed.

Its probably easier to set the number of cached pages to one.

> My (much) preferred way to handle all this is to remove the quicklists from
> all architectures: just use alloc_page() and free_page() for pte pages, pmd
> pages, etc.  I remain unaware of any testing whcih indicates that this
> would be a bad change.

Tried this also on x86_64 with an enhanced quicklist patch that also deals 
with ptes (at the price of not guaranteeing the free after the tlb flush):

quicklist:

real    8m56.787s
user    7m46.380s
sys     0m55.910s

real    8m58.326s
user    7m46.030s
sys     0m56.250s
 
real    8m56.900s
user    7m46.620s
sys     0m55.570s

no quicklist:

real    9m7.798s
user    7m48.340s
sys     0m58.360s

real    8m58.994s
user    7m47.980s
sys     0m54.870s

real    8m58.533s
user    7m48.030s
sys     0m54.150s

Seems that there is a slight benefit but its also barely above noise 
level.

