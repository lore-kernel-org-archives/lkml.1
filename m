Return-Path: <linux-kernel-owner+w=401wt.eu-S933363AbXGUHZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363AbXGUHZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 03:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbXGUHY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 03:24:59 -0400
Received: from ozlabs.org ([203.10.76.45]:43424 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbXGUHY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 03:24:58 -0400
Subject: Re: [PATCH 7/7] readahead: basic support of interleaved reads
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070721044347.388744012@mail.ustc.edu.cn>
References: <20070721044300.909424569@mail.ustc.edu.cn>
	 <20070721044347.388744012@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 17:24:39 +1000
Message-Id: <1185002679.6344.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 12:43 +0800, Fengguang Wu wrote:
> plain text document attachment (readahead-interleaved-reads.patch)
> This is a simplified version of the pagecache context based readahead.
> It handles the case of multiple threads reading on the same fd and invalidating
> each others' readahead state. It does the trick by scanning the pagecache and
> recovering the current read stream's readahead status.
> 
> The algorithm works in a opportunistic way, in that it do not try to detect
> interleaved reads _actively_, which requires a probe into the page cache(which
> means a little more overheads for random reads). It only tries to handle a
> previously started sequential readahead whose state was overwritten by
> another concurrent stream, and it can do this job pretty well.

Hi Fengguang,

	This is really clever!

	Only one slight complaint: I wonder if "radix_tree_scan_hole" could be
expressed as "radix_tree_extent_size" which return the number of
populated indices up to "max_scan".  Returning a length seems more
intuitive to me (and I think gets rid of the wraparound error case?)

Cheers,
Rusty.

