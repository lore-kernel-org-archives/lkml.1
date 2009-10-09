Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbZJIPTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbZJIPTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761164AbZJIPTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:19:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33094 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760858AbZJIPTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:19:46 -0400
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
 balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091009151230.GF7654@duck.suse.cz>
References: <20091007073818.318088777@intel.com>
	 <20091007074901.251116016@intel.com>  <20091009151230.GF7654@duck.suse.cz>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 17:18:32 +0200
Message-Id: <1255101512.8802.65.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 17:12 +0200, Jan Kara wrote:
>   Ugh, but this is not equivalent! We would block the writer on some BDI
> without any dirty data if we are over global dirty limit. That didn't
> happen before.

It should have, we should throttle everything calling
balance_dirty_pages() when we're over the total limit.

