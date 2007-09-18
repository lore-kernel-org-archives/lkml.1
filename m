Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbXIRTbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbXIRTbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXIRTbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:31:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:42867 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526AbXIRTbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:31:05 -0400
Date: Tue, 18 Sep 2007 21:31:02 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20070918193102.GC7541@v2.random>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <20070916181504.GB16406@skynet.ie> <20070916185052.GG6708@v2.random> <87lkb643ug.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lkb643ug.fsf@informatik.uni-tuebingen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 12:56:07AM +0200, Goswin von Brederlow wrote:
> When has free ever given any usefull "free" number? I can perfectly
> fine allocate another gigabyte of memory despide free saing 25MB. But
> that is because I know that the buffer/cached are not locked in.

Well, as you said you know that buffer/cached are not locked in. If
/proc/meminfo would be rubbish like you seem to imply in the first
line, why would we ever bother to export that information and even
waste time writing a binary that parse it for admins?

> On the other hand 1GB can instantly vanish when I start a xen domain
> and anything relying on the free value would loose.

Actually you better check meminfo or free before starting a 1G of Xen!!

> The only sensible thing for an application concerned with swapping is
> to whatch the swapping and then reduce itself. Not the amount
> free. Although I wish there were some kernel interface to get a
> preasure value of how valuable free pages would be right now. I would
> like that for fuse so a userspace filesystem can do caching without
> cripling the kernel.

Repeated drop caches + free can help.
