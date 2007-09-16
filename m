Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbXIPW4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbXIPW4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 18:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXIPW4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 18:56:13 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:49094 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622AbXIPW4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 18:56:12 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Mel Gorman <mel@skynet.ie>,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
References: <20070911060349.993975297@sgi.com>
	<200709110452.20363.nickpiggin@yahoo.com.au>
	<20070911121225.GE13132@lazybastard.org>
	<20070915014449.4f9cdb51.akpm@linux-foundation.org>
	<87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
	<20070915155100.GA21861@v2.random> <20070916181504.GB16406@skynet.ie>
	<20070916185052.GG6708@v2.random>
Date: Mon, 17 Sep 2007 00:56:07 +0200
In-Reply-To: <20070916185052.GG6708@v2.random> (Andrea Arcangeli's message of
	"Sun, 16 Sep 2007 20:50:52 +0200")
Message-ID: <87lkb643ug.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli <andrea@suse.de> writes:

> You ignore one other bit, when "/usr/bin/free" says 1G is free, with
> config-page-shift it's free no matter what, same goes for not mlocked
> cache. With variable order page cache, /usr/bin/free becomes mostly a
> lie as long as there's no 4k fallback (like fsblock).

% free
             total       used       free     shared    buffers     cached
Mem:       1398784    1372956      25828          0     225224     321504
-/+ buffers/cache:     826228     572556
Swap:      1048568         20    1048548

When has free ever given any usefull "free" number? I can perfectly
fine allocate another gigabyte of memory despide free saing 25MB. But
that is because I know that the buffer/cached are not locked in.

On the other hand 1GB can instantly vanish when I start a xen domain
and anything relying on the free value would loose.


The only sensible thing for an application concerned with swapping is
to whatch the swapping and then reduce itself. Not the amount
free. Although I wish there were some kernel interface to get a
preasure value of how valuable free pages would be right now. I would
like that for fuse so a userspace filesystem can do caching without
cripling the kernel.

MfG
        Goswin
