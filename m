Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbXK0Tn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbXK0Tn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 14:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbXK0TnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 14:43:19 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:26371 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752478AbXK0TnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:43:18 -0500
X-YMail-OSG: 2cj0w8UVM1lpaCOoCdgMFWRDQCN.Qj0HAA5zRH1ngH9bvpjVqKGCNLesGK00FR9HyQFmOwAt6A--
Date: Tue, 27 Nov 2007 11:43:14 -0800
From: Chris Wedgwood <cw@f00f.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
Message-ID: <20071127194314.GA4939@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071125163014.GA17922@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2007 at 04:30:14PM +0000, Christoph Hellwig wrote:

> The current readdir implementation deadlocks on a btree buffers
> locks because nfsd calls back into ->lookup from the filldir
> callback.  The only short-term fix for this is to revert to the old
> inefficient double-buffering scheme.

This seems to work really well here.

> This patch does exactly that and reverts xfs_file_readdir to what's
> basically the 2.6.23 version minus the uio and vnops junk.

This should probably be submitted for inclusion stable-2.6.24.
Perhaps a version with the #if 0 [...]  stuff dropped?  (I'm happy to
send a patch for that if you prefer).
