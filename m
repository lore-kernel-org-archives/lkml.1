Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0BKO4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:56:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48733 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab0BKO4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:56:33 -0500
Date: Thu, 11 Feb 2010 09:56:32 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.32.3 x86_64 - XFS hangs, all I/O to D-state bug (again)
Message-ID: <20100211145632.GA16912@infradead.org>
References: <alpine.DEB.2.00.1002110903080.25392@p34.internal.lan> <20100211145123.GA13114@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211145123.GA13114@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 09:51:23AM -0500, Christoph Hellwig wrote:
> Can you check if this still happens with the patch below?

Or the 2.6.32 variant of it:

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-02-11 15:52:14.442003504 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-02-11 15:52:33.172024387 +0100
@@ -1182,8 +1182,7 @@ _xfs_buf_ioapply(
 		bp->b_flags &= ~_XBF_RUN_QUEUES;
 		rw = (bp->b_flags & XBF_WRITE) ? WRITE_SYNC : READ_SYNC;
 	} else {
-		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
-		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
+		rw = (bp->b_flags & XBF_WRITE) ? WRITE : READ;
 	}
 
 	/* Special code path for reading a sub page size buffer in --
