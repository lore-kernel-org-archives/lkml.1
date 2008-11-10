Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbYKJO1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbYKJO1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYKJO11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:27:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36750 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYKJO10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:27:26 -0500
Date: Mon, 10 Nov 2008 14:27:15 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, axboe@kernel.dk,
       dm-devel <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Queue upcall locking (was: [dm-devel] [RFC][PATCH] fix dm_any_congested() to properly sync up with suspend code path)
Message-ID: <20081110142715.GD16649@agk.fab.redhat.com>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mpatocka@redhat.com>, axboe@kernel.dk,
	dm-devel <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
References: <1225944008.14830.1101.camel@chandra-ubuntu> <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com> <20081110135401.GA11606@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110135401.GA11606@infradead.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 08:54:01AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 10, 2008 at 08:11:51AM -0500, Mikulas Patocka wrote:
> > For upstream Linux developers: you are holding a spinlock and calling 
> > bdi*_congested functions that can take indefinite amount of time (there 
> > are even users reporting having 50 disks in one logical volume or so). I 
> > think it would be good to move these calls out of spinlocks.
> Umm, they shouldn't block that long, as that completely defeats their
> purpose.  

Indeed - the blocking was a bug for which there's a patch, but that doesn't
deal with how the function should be operating in the first place.

- If one device is found to be congested, why bother checking the remaining
devices?

- If the device is suspended, the response should be that it is congested, I'd
have thought.

Alasdair
-- 
agk@redhat.com
