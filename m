Return-Path: <linux-kernel-owner+w=401wt.eu-S1946367AbXBCGlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946367AbXBCGlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 01:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946365AbXBCGk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 01:40:59 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60879 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946362AbXBCGk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 01:40:58 -0500
Date: Sat, 3 Feb 2007 12:13:45 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Fengguang Wu <fengguang.wu@gmail.com>
Subject: Re: [patch 0/9] buffered write deadlock fix
Message-ID: <20070203064345.GA22331@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <20070129081905.23584.97878.sendpatchset@linux.site> <20070202155232.babe1a52.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202155232.babe1a52.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 03:52:32PM -0800, Andrew Morton wrote:
> On Mon, 29 Jan 2007 11:31:37 +0100 (CET)
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > The following set of patches attempt to fix the buffered write
> > locking problems (and there are a couple of peripheral patches
> > and cleanups there too).
> > 
> > Patches against 2.6.20-rc6. I was hoping that 2.6.20-rc6-mm2 would
> > be an easier diff with the fsaio patches gone, but the readahead
> > rewrite clashes badly :(
> 
> Well fsaio is restored, but there's now considerable doubt over it due to
> the recent febril febrility.

I think Ingo made a point earlier about letting the old co-exist with the
new. Fibrils + kevents have great potential for a next generation
solution but we need to give the whole story some time to play out and prove
it in practice, debate and benchmark the alternative combinations, optimize it
for various workloads etc.  It will also take more work on top before we
can get the whole POSIX AIO implementation supported on top of this. I'll be
very happy when that happens ... it is just that it is still too early to
be sure.

Since this is going to be a new interface, not the existing linux AIO
interface, I do not see any conflict between the two. Samba4 already uses
fsaio, and we now have the ability to do POSIX AIO over kernel AIO (which
depends on fsaio). The more we delay real world usage the longer we take
to learn about the application patterns that matter. And it is those
patterns that are key.

> 
> How bad is the clash with the readahead patches?
> 
> Clashes with git-block are likely, too.
> 
> Bugfixes come first, so I will drop readahead and fsaio and git-block to get
> this work completed if needed - please work agaisnt mainline.

If you need help with fixing the clashes, please let me know.

Regards
Suparna

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

