Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbXKZCNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbXKZCNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 21:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbXKZCNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 21:13:12 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41400 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757378AbXKZCNL (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 21:13:11 -0500
Message-ID: <474A2B62.20204@sgi.com>
Date: Mon, 26 Nov 2007 13:11:46 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
References: <20071122003339.GH114266761@sgi.com>
In-Reply-To: <20071122003339.GH114266761@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-11-22 10:47:21.945395328 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-11-22 10:53:11.556186722 +1100
> @@ -1443,6 +1443,8 @@ xlog_sync(xlog_t		*log,
>  	XFS_BUF_ZEROFLAGS(bp);
>  	XFS_BUF_BUSY(bp);
>  	XFS_BUF_ASYNC(bp);
> +	XFS_BUF_SET_LOGBUF(bp);
> +
>  	/*
>  	 * Do an ordered write for the log block.
>  	 * Its unnecessary to flush the first split block in the log wrap case.

Whichever way you go with this one Dave you should probably add another
XFS_BUF_SET_LOGBUF() call for the buffer split case further down in the
same function.
