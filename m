Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbYKJNyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbYKJNyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 08:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbYKJNyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 08:54:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34346 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbYKJNyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 08:54:04 -0500
Date: Mon, 10 Nov 2008 08:54:01 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: Queue upcall locking (was: [dm-devel] [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Message-ID: <20081110135401.GA11606@infradead.org>
References: <1225944008.14830.1101.camel@chandra-ubuntu> <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 08:11:51AM -0500, Mikulas Patocka wrote:
> For upstream Linux developers: you are holding a spinlock and calling 
> bdi*_congested functions that can take indefinite amount of time (there 
> are even users reporting having 50 disks in one logical volume or so). I 
> think it would be good to move these calls out of spinlocks.

Umm, they shouldn't block that long, as that completely defeats their
purpose.  These functions are mostly used to avoid throwing more I/O at
a congested device if pdflush could do more useful things instead.  But
if it blocks in those functions anyway we wouldn't have to bother using
them.  Do you have more details about the uses cases when this happens
and where the routines spend so much time?

