Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbYE3GWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbYE3GWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbYE3GWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:22:38 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36091 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752893AbYE3GWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:22:37 -0400
Date: Thu, 29 May 2008 23:22:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Eric Dumazet <dada1@cosmosbay.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
In-Reply-To: <20080529231618.56e4028b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805292321240.12457@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080529215827.b659d032.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com>
 <20080529222143.5d7aa1e5.akpm@linux-foundation.org> <483F981E.3040004@cosmosbay.com>
 <20080529231618.56e4028b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Andrew Morton wrote:

> ext3 maintains three percpu_counters per mount.  Each percpu_counter
> does one percpu_alloc.  People can mount an arbitrary number of ext3
> filesystems!

But its 4 bytes per alloc right?

> Another: there are two percpu_counters (and hence two percpu_alloc()s)
> per backing_dev_info.  One backing_dev_info per disk and people have
> been known to have thousands (iirc ~10,000) disks online.

8 bytes per backing device. 80000 bytes for 10000 disks.

> And those examples were plucked only from today's kernel.  Who knows
> what other problems will be in 2.6.45?

We can always increase the sizes.
 
