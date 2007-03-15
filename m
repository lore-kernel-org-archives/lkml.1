Return-Path: <linux-kernel-owner+w=401wt.eu-S965496AbXCOM1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496AbXCOM1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965514AbXCOM1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:27:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:55791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965496AbXCOM1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:27:38 -0400
Date: Thu, 15 Mar 2007 13:27:36 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [patch 2/2] splice: dont readpage
Message-ID: <20070315122736.GB8321@wotan.suse.de>
References: <20070314121440.GA926@wotan.suse.de> <20070314121543.GB926@wotan.suse.de> <20070315115454.GN15400@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315115454.GN15400@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 12:54:54PM +0100, Jens Axboe wrote:
> On Wed, Mar 14 2007, Nick Piggin wrote:
> > 
> > Splice does not need to readpage to bring the page uptodate before writing
> > to it, because prepare_write will take care of that for us.
> 
> Ah great, always good to get rid of some code.

Yeah, it should especially make block (but not page) sized and aligned
writes into uncached files work much better, AFAIKS (won't require the
synchronous read).

> > Splice is also wrong to SetPageUptodate before the page is actually uptodate.
> > This results in the old uninitialised memory leak. This gets fixed as a
> > matter of course when removing the readpage logic.
> 
> Leak, how? The page should still be locked all through to the copy.
> Anyway, doesn't matter since you've killed it anyway. I have applied
> this patch.

The read side doesn't need to lock the page if it is uptodate, and doesn't.

Nick
