Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYHYVz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYHYVz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYHYVzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:55:49 -0400
Received: from verein.lst.de ([213.95.11.210]:50797 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbYHYVzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:55:49 -0400
Date: Mon, 25 Aug 2008 23:55:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Lachlan McIlroy <lachlan@sgi.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       hch@lst.de
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
Message-ID: <20080825215532.GB28188@lst.de>
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com> <20080825010213.GO5706@disturbed> <48B21507.9050708@sgi.com> <20080825035542.GR5706@disturbed> <1219647573.20732.28.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219647573.20732.28.camel@twins>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 08:59:33AM +0200, Peter Zijlstra wrote:
> How can you take two locks in one go? It seems to me you always need to
> take them one after another, and as soon as you do that, you have
> ordering constraints.

Yes, you would.  Except that in all other places we only have a single
iolock involved, so the ordering of the second iolock and second ilock
don't matter.

Because of that I think declaring that xfs_lock_two_inodes can just
lock on lock type at a time might be the better solution.
