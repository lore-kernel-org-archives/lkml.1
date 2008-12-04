Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYLDRxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYLDRxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbYLDRxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:53:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbYLDRxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:53:14 -0500
Date: Thu, 4 Dec 2008 12:53:07 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
Message-ID: <20081204175306.GA24196@infradead.org>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com> <20081204100050.GN6703@one.firstfloor.org> <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com> <20081204142015.GQ6703@one.firstfloor.org> <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com> <20081204145810.GR6703@one.firstfloor.org> <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com> <20081204174838.GS6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204174838.GS6703@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 06:48:38PM +0100, Andi Kleen wrote:
> I think. Just the low level xfs_buf interface happens to use the asynchronous
> callbacks instead of calling into the block layer directly like jbd et.al.
> do.

Only delwri buffers are delayed in XFS, but the journaling code only
uses async buffers which *synchronously* call into the block layer, but
just don't wait for it to complete..

