Return-Path: <linux-kernel-owner+w=401wt.eu-S933509AbXCOLzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbXCOLzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 07:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933504AbXCOLzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 07:55:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16819 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933509AbXCOLzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 07:55:52 -0400
Date: Thu, 15 Mar 2007 12:54:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [patch 2/2] splice: dont readpage
Message-ID: <20070315115454.GN15400@kernel.dk>
References: <20070314121440.GA926@wotan.suse.de> <20070314121543.GB926@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314121543.GB926@wotan.suse.de>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14 2007, Nick Piggin wrote:
> 
> Splice does not need to readpage to bring the page uptodate before writing
> to it, because prepare_write will take care of that for us.

Ah great, always good to get rid of some code.

> Splice is also wrong to SetPageUptodate before the page is actually uptodate.
> This results in the old uninitialised memory leak. This gets fixed as a
> matter of course when removing the readpage logic.

Leak, how? The page should still be locked all through to the copy.
Anyway, doesn't matter since you've killed it anyway. I have applied
this patch.

-- 
Jens Axboe

