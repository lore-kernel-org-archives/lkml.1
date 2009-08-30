Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbZH3C4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbZH3C4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 22:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZH3C4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 22:56:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbZH3C4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 22:56:17 -0400
Date: Sat, 29 Aug 2009 22:56:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mark Lord <liml@rtr.ca>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       dwmw2@infradead.org
Subject: Re: [PATCH 6/7] block: allow large discard requests
Message-ID: <20090830025616.GA26428@infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231122.302813585@bombadil.infradead.org> <4A99E89E.9020204@rtr.ca> <20090830025022.GE22870@parisc-linux.org> <4A99E98B.403@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A99E98B.403@rtr.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 10:52:59PM -0400, Mark Lord wrote:
>> That depends on the firmware.  I do have plans to group the extents,
>> but let's get something working before making it quick.
> ..
>
> In this situation, it's more a case of making it *not sucky slow*
> than getting to the point where we think about making it "quick".
>
> One extent at a time is glacial.

Really depends on the use case.  With XFS you will only have very few
free space extents per AG, so it should work reasonably well for the
batched "offline" discard in my last patch.  And for SCSI arrays that
can actually process other I/O during that time the WRITE SAME is in
progress it should not be that bad.

But so far this is all a lot of talk of course until I can actually
work against real hardware.
