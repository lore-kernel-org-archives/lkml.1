Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZH2XLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZH2XLY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 19:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZH2XLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 19:11:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58937 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZH2XLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 19:11:21 -0400
Message-Id: <20090829230332.017137693@bombadil.infradead.org>
User-Agent: quilt/0.47-1
Date: Sat, 29 Aug 2009 19:03:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org
Subject: [PATCH 0/7] discard support revisited
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've started working on discard support a little bit more, and I think
it's time to get an overview over the state we're in right now.  This
patchswt is what I needed to get the batched discard support in XFS
properly working.  Many patches are just forward ported from Matthew's
SSD tree and I hope quilt mail didn't lose the attributions.

There are however a few significant changes:

 - blkdev_issue_discard is now a lot more generic - it grows a flags
   argument to control if we issue a barrier discard request or not
   or if we wait or not.  That is needed for the batched discard support
   in XFS which wants to wait just like the ioctl interface.
 - I have implemented support for sending WRITE SAME requests with the
   unmap bit set in sd.  This has been tested with a qemu-based backed
   only so far, but we'll get some real array coverage soon.
 - there is a new patch to allow larger discard requests.
 - the last patch is just my old batched discard patch for xfs ported
   to work ontop of this series.

I would really love to see some progress on this in the 2.6.32 circle.
We should at least get the block layer bits in that allow implementing
a somewhat useful discard function.  I would also love to see the
actual scsi and libata implementations in so that we can start playing
around with it.  But given the speed up the current TRIM implementations
and the expectations for WRITE SAME we should make sure the exact
TRIM tracking is not actually enabled anywhere by default for now.
