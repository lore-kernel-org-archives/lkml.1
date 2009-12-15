Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbZLOWCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbZLOWCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933854AbZLOWCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:02:52 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58885 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933852AbZLOWCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:02:50 -0500
Date: Tue, 15 Dec 2009 23:02:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Heinz Diehl <htd@fancy-poultry.org>, LKML <linux-kernel@vger.kernel.org>,
       martin.petersen@oracle.com
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device
	mapper warnings
Message-ID: <20091215220249.GG28252@kernel.dk>
References: <200912091049.12604.borntraeger@de.ibm.com> <20091209212516.GA6206@fancy-poultry.org> <20091209214501.GC8742@kernel.dk> <20091209220749.GD8742@kernel.dk> <alpine.DEB.2.01.0912151354350.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0912151354350.3483@bogon.housecafe.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15 2009, Christian Kujau wrote:
> On Wed, 9 Dec 2009 at 23:07, Jens Axboe wrote:
> > Does this work?
> > 
> [...]
> > +#if 0
> >  	if (offset &&
> >  	    (offset & (b->discard_granularity - 1)) != b->discard_alignment) {
> >  		t->discard_misaligned = 1;
> >  		ret = -1;
> >  	}
> > +#endif
> 
> I can't tell: is this a purely cosmetical change or is it dangerous to run 
> my DM devices without that patch? I'm trying to track mainline -git but 
> the patch hasn't made into the tree yet, so I always have to manually
> apply the patch - or can I just ignore the warning?

You can ignore it, it wont harm the functionality or data integrity. The
code "failure" will always trigger, since the default settings are 0.
Thus:

(offset & (b->discard_granularity - 1)) != b->discard_alignment

will always be true.

I'll revert the bad commit tomorrow so that -rc1 wont be affected, at
least.

-- 
Jens Axboe

