Return-Path: <linux-kernel-owner+w=401wt.eu-S1030195AbXBTQVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195AbXBTQVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030192AbXBTQVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:21:45 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:52651 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030195AbXBTQVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:21:44 -0500
Date: Tue, 20 Feb 2007 11:19:48 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Benjamin LaHaise <bcrl@kvack.org>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion event
Message-ID: <20070220161948.GQ6133@think.oraclecorp.com>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net> <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411> <20070219215048.GI6133@think.oraclecorp.com> <20070220002109.GG31205@kvack.org> <1171987310.6271.23.camel@heimdal.trondhjem.org> <1171987607.3531.142.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171987607.3531.142.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 05:06:47PM +0100, Arjan van de Ven wrote:
> > We don't try to resolve "conflicting" writes between ordinary mmap() and
> > write(), so why should we be doing it for mmap and O_DIRECT?
> > 
> > mmap() is designed to violate the ordinary mutex locks for write(), so
> > if a conflict arises, whether it be with O_DIRECT or ordinary writes
> > then it is a case of "last writer wins".
> 
> but.. wouldn't an O_DIRECT *read* even cause this?

The O_DIRECT read is fine because it doesn't leave bad data in the page
cache.  The point of doing invalidate_inode_pages2_range is to purge
page cache data that has the old contents of the file before the
O_DIRECT write.

-chris

