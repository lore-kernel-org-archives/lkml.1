Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbXEWRuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbXEWRuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbXEWRuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:50:04 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756342AbXEWRuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:50:03 -0400
Date: Wed, 23 May 2007 10:49:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: suresh.b.siddha@intel.com, clameter@sgi.com, kiran@scalex86.org,
       rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Define new percpu interface for shared data --
 version 3
Message-Id: <20070523104946.f279241c.akpm@linux-foundation.org>
In-Reply-To: <20070522182003.GA28106@linux-os.sc.intel.com>
References: <20070522124713.GB27428@frankl.hpl.hp.com>
	<20070522090210.1388ff3e.akpm@linux-foundation.org>
	<20070522182003.GA28106@linux-os.sc.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 11:20:03 -0700 Fenghua Yu <fenghua.yu@intel.com> wrote:

> per cpu data section contains two types of data. One set which is exclusively
> accessed by the local cpu and the other set which is  per cpu, but also shared
> by remote cpus. In the current kernel, these two sets are not clearely
> separated out. This can potentially cause the same data cacheline shared
> between the two sets of data, which will result in unnecessary bouncing of the
> cacheline between cpus.
> 
> One way to fix the problem is to cacheline align the remotely accessed per cpu
> data, both at the beginning and at the end. Because of the padding at both ends,
> this will likely cause some memory wastage and also the interface to achieve
> this is not clean.
> 
> This patch:
> 
> Moves the remotely accessed per cpu data (which is currently marked
> as ____cacheline_aligned_in_smp) into a different section, where all the data
> elements are cacheline aligned. And as such, this differentiates the local
> only data and remotely accessed data cleanly.

OK, but could we please have a concise description of the impact
of these changes on kernel memory footprint?  Increase or decrease?
And by approximately how much?

Thanks.
