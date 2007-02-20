Return-Path: <linux-kernel-owner+w=401wt.eu-S965094AbXBTQGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094AbXBTQGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965292AbXBTQGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:06:31 -0500
Received: from kanga.kvack.org ([66.96.29.28]:45331 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965094AbXBTQGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:06:30 -0500
Date: Tue, 20 Feb 2007 11:06:15 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Chris Mason <chris.mason@oracle.com>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion event
Message-ID: <20070220160615.GT31205@kvack.org>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net> <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411> <20070219215048.GI6133@think.oraclecorp.com> <20070220002109.GG31205@kvack.org> <1171987310.6271.23.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171987310.6271.23.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 11:01:50AM -0500, Trond Myklebust wrote:
> We don't try to resolve "conflicting" writes between ordinary mmap() and
> write(), so why should we be doing it for mmap and O_DIRECT?

Yes we do -- both writes will succeed.  More importantly, if one modifies 
the first 512 bytes of a page and the other modifies the last 512 bytes of 
the page, both writes will show up in the completed result.  This is not the 
case with the -EIO bailout.

> mmap() is designed to violate the ordinary mutex locks for write(), so
> if a conflict arises, whether it be with O_DIRECT or ordinary writes
> then it is a case of "last writer wins".

Except that we're not handling cases like the one mentioned above, which 
is quite broken.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <dont@kvack.org>.
