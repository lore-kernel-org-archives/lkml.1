Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbZICRw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbZICRw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZICRw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:52:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:59800 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZICRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:52:26 -0400
Subject: Re: [PATCH 1/7] Make DISCARD_BARRIER and DISCARD_NOBARRIER writes
 instead of reads
From: David Woodhouse <dwmw2@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com,
       matthew@wil.cx, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20090829231121.144124147@bombadil.infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org>
	 <20090829231121.144124147@bombadil.infradead.org>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 18:52:20 +0100
Message-Id: <1252000340.4483.529.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-29 at 19:03 -0400, Christoph Hellwig wrote:
> 
> The commands are conceptually writes, and in the case of IDE and SCSI
> commands actually are writes.  They were only reads because we thought
> that would interact better with the elevators.  Now the elevators know
> about discard requests, that advantage no longer exists.

Can you drop the final sentence of that? It isn't true, and I never said
it.

s/.  Now.*/, but that isn't necessary, and making them writes makes it
easier for the low-level IDE and SCSI code to cope with the fact that
the command has to be sent with a payload./


The elevators _still_ don't know about discards, and will still let
reads and writes (and discards, which are just a special case of writes)
to the same sector all cross each other on the queue unless there's some
external factor to prevent it.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

