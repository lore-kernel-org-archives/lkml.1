Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbYE3GQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbYE3GQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbYE3GQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:16:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbYE3GQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:16:41 -0400
Date: Thu, 29 May 2008 23:16:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
Message-Id: <20080529231618.56e4028b.akpm@linux-foundation.org>
In-Reply-To: <483F981E.3040004@cosmosbay.com>
References: <20080530035620.587204923@sgi.com>
	<20080529215827.b659d032.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com>
	<20080529222143.5d7aa1e5.akpm@linux-foundation.org>
	<483F981E.3040004@cosmosbay.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 08:01:02 +0200 Eric Dumazet <dada1@cosmosbay.com> wrote:

> Really, percpu allocations are currently not frequent at all.
> 
> vmalloc()/vfreee() are way more frequent and still use a list.

Sure it's hard to conceive how anyone could go and do a per-cpu
allocation on a fastpath.

But this has nothing to do with the frequency!  The problems surround
the _amount_ of allocated memory and the allocation/freeing patterns.

Here's another example.  And it's only an example!  Generalise!

ext3 maintains three percpu_counters per mount.  Each percpu_counter
does one percpu_alloc.  People can mount an arbitrary number of ext3
filesystems!


Another: there are two percpu_counters (and hence two percpu_alloc()s)
per backing_dev_info.  One backing_dev_info per disk and people have
been known to have thousands (iirc ~10,000) disks online.

And those examples were plucked only from today's kernel.  Who knows
what other problems will be in 2.6.45?
