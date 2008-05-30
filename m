Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYE3GiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYE3GiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYE3GiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:38:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbYE3GiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:38:14 -0400
Date: Thu, 29 May 2008 23:37:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
Message-Id: <20080529233758.7bd2c977.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805292321240.12457@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com>
	<20080529215827.b659d032.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com>
	<20080529222143.5d7aa1e5.akpm@linux-foundation.org>
	<483F981E.3040004@cosmosbay.com>
	<20080529231618.56e4028b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805292321240.12457@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 23:22:31 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 29 May 2008, Andrew Morton wrote:
> 
> > ext3 maintains three percpu_counters per mount.  Each percpu_counter
> > does one percpu_alloc.  People can mount an arbitrary number of ext3
> > filesystems!
> 
> But its 4 bytes per alloc right?

It could be 4000.  The present alloc_percpu() would support that.

And struct nfs_iostats is 264 bytes and nfs does an alloc_percpu() of
one of those per server and mounting thousands of servers per client
is, I believe, a real-world operation.

Plus for the entyenth time: saying that this code will probably work
acceptably for most people in 2.6.26 is not sufficient!
