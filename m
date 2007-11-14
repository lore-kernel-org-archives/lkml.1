Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbXKNLtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbXKNLtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbXKNLtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:49:12 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:30753 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754851AbXKNLtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:49:09 -0500
X-YMail-OSG: 3BM2TUgVM1kDu47611Df_i9KFswRZEP.gTBtpmJcXfTvKu4sTQCHvfCKZUeZ842fBORefL3B1g--
Date: Wed, 14 Nov 2007 03:49:07 -0800
From: Chris Wedgwood <cw@f00f.org>
To: linux-xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
       David Chinner <dgc@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Benny Halevy <bhalevy@panasas.com>,
       Christian Kujau <lists@nerdbynature.de>
Subject: 2.6.24-rc2 XFS nfsd hang --- filldir change responsible?
Message-ID: <20071114114907.GA31466@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114070400.GA25708@puku.stupidest.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 11:04:00PM -0800, Chris Wedgwood wrote:

> With 2.6.24-rc2 (amd64) I sometimes (usually but perhaps not always)
> see a hang when accessing some NFS exported XFS filesystems.  Local
> access to these filesystems ahead of time works without problems.
>
> This does not occur with 2.6.23.1.  The filesystem does not appear
> to be corrupt.

After some bisection pain (sg broken in the middle and XFS not
compiling in other places) the regression seems to be:

    commit 051e7cd44ab8f0f7c2958371485b4a1ff64a8d1b
    Author: Christoph Hellwig <hch@infradead.org>
    Date:   Tue Aug 28 13:58:24 2007 +1000

	[XFS] use filldir internally

There have been a lot of changes since this so reverting it and
retesting as-is won't work. I'll have to see what I can come up with
after some sleep.

I'm not building/testing with dmapi --- perhaps that makes a
difference here?  I would think it would have broken with xfsqa but
the number of bug reports seems small so far.
