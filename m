Return-Path: <linux-kernel-owner+w=401wt.eu-S1761184AbYHDTCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761184AbYHDTCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760708AbYHDTCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:02:12 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58188 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010AbYHDTCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:02:09 -0400
Subject: Re: Too many I/O controller patches
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: righi.andrea@gmail.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@sourceware.org
In-Reply-To: <489748E6.5080106@gmail.com>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	 <1217870433.20260.101.camel@nimitz>  <489748E6.5080106@gmail.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 12:02:01 -0700
Message-Id: <1217876521.20260.123.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 20:22 +0200, Andrea Righi wrote:
> But I'm not yet convinced that limiting the IO writes at the device
> mapper layer is the best solution. IMHO it would be better to throttle
> applications' writes when they're dirtying pages in the page cache (the
> io-throttle way), because when the IO requests arrive to the device
> mapper it's too late (we would only have a lot of dirty pages that are
> waiting to be flushed to the limited block devices, and maybe this could
> lead to OOM conditions). IOW dm-ioband is doing this at the wrong level
> (at least for my requirements). Ryo, correct me if I'm wrong or if I've
> not understood the dm-ioband approach.

The avoid-lots-of-page-dirtying problem sounds like a hard one.  But, if
you look at this in combination with the memory controller, they would
make a great team.

The memory controller keeps you from dirtying more than your limit of
pages (and pinning too much memory) even if the dm layer is doing the
throttling and itself can't throttle the memory usage.

I also don't think this is any different from the problems we have in
the regular VM these days.  Right now, people can dirty lots of pages on
devices that are slow.  The only thing dm-ioband would be added would be
changing how those devices *got* slow. :)

-- Dave

