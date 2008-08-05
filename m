Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbYHEG2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbYHEG2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 02:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYHEG2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:28:18 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:50596 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751142AbYHEG2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:28:18 -0400
Date: Tue, 05 Aug 2008 15:28:16 +0900 (JST)
Message-Id: <20080805.152816.105502343.taka@valinux.co.jp>
To: dave@linux.vnet.ibm.com
Cc: righi.andrea@gmail.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org
Subject: Re: Too many I/O controller patches
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <1217883036.20260.137.camel@nimitz>
References: <1217876521.20260.123.camel@nimitz>
	<48976A2A.9060600@gmail.com>
	<1217883036.20260.137.camel@nimitz>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > >> But I'm not yet convinced that limiting the IO writes at the device
> > >> mapper layer is the best solution. IMHO it would be better to throttle
> > >> applications' writes when they're dirtying pages in the page cache (the
> > >> io-throttle way), because when the IO requests arrive to the device
> > >> mapper it's too late (we would only have a lot of dirty pages that are
> > >> waiting to be flushed to the limited block devices, and maybe this could
> > >> lead to OOM conditions). IOW dm-ioband is doing this at the wrong level
> > >> (at least for my requirements). Ryo, correct me if I'm wrong or if I've
> > >> not understood the dm-ioband approach.
> > > 
> > > The avoid-lots-of-page-dirtying problem sounds like a hard one.  But, if
> > > you look at this in combination with the memory controller, they would
> > > make a great team.
> > > 
> > > The memory controller keeps you from dirtying more than your limit of
> > > pages (and pinning too much memory) even if the dm layer is doing the
> > > throttling and itself can't throttle the memory usage.
> > 
> > mmh... but in this way we would just move the OOM inside the cgroup,
> > that is a nice improvement, but the main problem is not resolved...
> > 
> > A safer approach IMHO is to force the tasks to wait synchronously on
> > each operation that directly or indirectly generates i/o.
> 
> Fine in theory, hard in practice. :)
> 
> I think the best we can hope for is to keep parity with what happens in
> the rest of the kernel.  We already have a problem today with people
> mmap()'ing lots of memory and dirtying it all at once.  Adding a i/o
> bandwidth controller or a memory controller isn't really going to fix
> that.  I think it is outside the scope of the i/o (and memory)
> controllers until we solve it generically, first.

Yes, that's right. This should be solved.

But there is a good thing when you use a memory controller.
A problem occurred in a certain cgroup will be confined in its cgroup.
I think this is a great point, don't you think?

Thank you,
Hirokazu Takahashi.




