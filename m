Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbXEaRcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbXEaRcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbXEaRbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:31:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55569 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbXEaRbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:31:53 -0400
Date: Thu, 31 May 2007 18:31:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, neilb@suse.de, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070531173143.GA7605@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Hugh Dickins <hugh@veritas.com>, Jens Axboe <jens.axboe@oracle.com>,
	linux-kernel@vger.kernel.org, cotte@de.ibm.com, neilb@suse.de,
	zanussi@us.ibm.com, Linus Torvalds <torvalds@osdl.org>
References: <20070531103316.GO32105@kernel.dk> <Pine.LNX.4.64.0705311750180.12688@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705311750180.12688@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 06:06:19PM +0100, Hugh Dickins wrote:
> Christoph already picked up on that, and it's of interest to shmem too:
> loop over tmpfs in 2.6 was relying on shmem_file_sendfile, for which
> the generic route is not good enough.
> 
> If we're giving a .splice_read to everything which used to have a
> .sendfile, then I think you just need to make do_lo_read() use
> ->splice_read now?

I'd be perfectly happy with killing support for using ->read.  Any
simple filesystem can use the generic methods, and any more complex
filesystem should better have splice aswell.  Btw, someone should
look into using splice for the loop write path aswell, the current
useage of ->prepare_write and ->commit_write has similar locking
problems aswell.
