Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYH1IMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYH1IMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 04:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYH1IMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 04:12:01 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40025 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbYH1IL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 04:11:59 -0400
Date: Thu, 28 Aug 2008 10:11:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andre Noll <maan@systemlinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, jurriaan <thunder7@xs4all.nl>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with  software-raid1
Message-ID: <20080828081113.GW20055@kernel.dk>
References: <20080827170538.GA24393@amd64.of.nowhere> <200808272347.43577.rjw@sisk.pl> <20080828073324.GR20055@kernel.dk> <20080828004532.45d8b8c9.akpm@linux-foundation.org> <20080828074830.GV20055@kernel.dk> <20080828075607.GA3795@skl-net.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828075607.GA3795@skl-net.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28 2008, Andre Noll wrote:
> On 09:48, Jens Axboe wrote:
> > Doh right, we of course can't block inside a RCU section. Then
> > bitmap.c:write_sb_page() wants fixing:
> > 
> >         rcu_read_lock();
> >         rdev_for_each_rcu(...)
> >                 md_super_write(...)
> >                         bio_alloc(GFP_NOIO, 1);
> 
> Also, md_super_write() does not check the return value of bio_alloc().
> That probably needs fixing as well.

No, that's the guarentee of mempool_alloc() - as long as you have
__GFP_WAIT set, you'll never see a NULL return.

-- 
Jens Axboe

