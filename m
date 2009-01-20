Return-Path: <linux-kernel-owner+w=401wt.eu-S1760326AbZATOFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326AbZATOFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZATOFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:05:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbZATOFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:05:16 -0500
Date: Tue, 20 Jan 2009 09:05:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>,
       LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120140514.GA2976@infradead.org>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com> <20090120114906.GA12526@infradead.org> <20090120121335.GA19182@infradead.org> <20090120124515.GA31838@infradead.org> <4975D88B.7020906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4975D88B.7020906@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 02:58:35PM +0100, Jacek Luczak wrote:
> Good job! Is there some ,,quick'' fix?

The patch below makes it go away for me, alternatively just enable
CONFIG_LBD.


Index: linux-2.6/fs/xfs/xfs_types.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_types.h	2009-01-20 14:55:55.806068213 +0100
+++ linux-2.6/fs/xfs/xfs_types.h	2009-01-20 14:56:01.437945154 +0100
@@ -96,7 +96,7 @@ typedef	__uint64_t	xfs_dfilblks_t;	/* nu
 /*
  * Memory based types are conditional.
  */
-#if XFS_BIG_BLKNOS
+#if 1 //XFS_BIG_BLKNOS
 typedef	__uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
 typedef __uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
 typedef __uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
