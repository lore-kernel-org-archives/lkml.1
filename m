Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYKKSVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYKKSVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYKKSVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:21:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39064 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbYKKSVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:21:04 -0500
Date: Tue, 11 Nov 2008 13:21:02 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
       Mikulas Patocka <mpatocka@redhat.com>, axboe@kernel.dk,
       dm-devel <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Queue upcall locking (was: [dm-devel] [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Message-ID: <20081111182102.GB25049@infradead.org>
References: <1225944008.14830.1101.camel@chandra-ubuntu> <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com> <20081110135401.GA11606@infradead.org> <20081110142715.GD16649@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110142715.GD16649@agk.fab.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 02:27:15PM +0000, Alasdair G Kergon wrote:
> Indeed - the blocking was a bug for which there's a patch, but that doesn't
> deal with how the function should be operating in the first place.
> 
> - If one device is found to be congested, why bother checking the remaining
> devices?
> 
> - If the device is suspended, the response should be that it is congested, I'd
> have thought.

Yes.  device congested is a quick an dirty check - if you encounter
anything long just return congested if I/O would hit this long delay,
too or not congested if you can't really know.

