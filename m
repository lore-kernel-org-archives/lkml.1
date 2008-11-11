Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbYKKSTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbYKKSTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYKKSS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:18:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38847 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYKKSS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:18:56 -0500
Date: Tue, 11 Nov 2008 13:18:54 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Chandra Seetharaman <sekharan@us.ibm.com>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: Queue upcall locking (was: [dm-devel] [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Message-ID: <20081111181854.GA25049@infradead.org>
References: <1225944008.14830.1101.camel@chandra-ubuntu> <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com> <20081110135401.GA11606@infradead.org> <Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 09:19:21AM -0500, Mikulas Patocka wrote:
> For device mapper, congested_fn asks every device in the tree and make OR 
> of their bits --- so if the user has 50 devices, it asks them all.
> 
> For md-linear, md-raid0, md-raid1, md-raid10 and md-multipath it does the 
> same --- asking every device.
> 
> If you have a better idea how to implement congested_fn, say it.

Well, even asking 50 devices shouldn't take that long normally.  Do you
take some sleeping lock that might block forever?  In that case I would
just return congested for that device as it would delay pdflush
otherwise.

