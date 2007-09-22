Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbXIVApu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbXIVApu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 20:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbXIVApm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 20:45:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:1248 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbXIVApl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 20:45:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,286,1186383600"; 
   d="scan'208";a="284003334"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
Date: Fri, 21 Sep 2007 17:45:39 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E52027D927D@azsmsx413.amr.corp.intel.com>
In-Reply-To: <18164.23902.732535.384492@notabene.brown>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
Thread-Index: Acf8rPPtSXDtYWTmRke2zIC5SO9D9QAA9HdA
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com><20070921114823.49d00263.akpm@linux-foundation.org> <18164.23902.732535.384492@notabene.brown>
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Neil Brown" <neilb@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
       <yur@emcraft.com>, <saeed.bishara@gmail.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>
X-OriginalArrivalTime: 22 Sep 2007 00:45:40.0641 (UTC) FILETIME=[E64AA110:01C7FCB1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Neil Brown [mailto:neilb@suse.de]
> On Friday September 21, akpm@linux-foundation.org wrote:
> > On Thu, 20 Sep 2007 18:27:35 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > > Fix a couple bugs and provide documentation for the async_tx api.
> > >
> > > Neil, please 'ack' patch #3.
> > >
> > > git://lost.foo-projects.org/~dwillia2/git/iop
async-tx-fixes-for-linus
> >
> > Well it looks like Neil is on vacation or is hiding from us or
something.
> 
> Neil is just not coping well with jet-lag....
> 
> Patch #3 looks good and necessary
>   Acked-By: NeilBrown <neilb@suse.de>
> 
> I know that should probably be a "reviewed-by"....  I was a bit
I went ahead and added reviewed-by.

> surprised that the "handle_completed_read_requests" call was so early
> in handle_stripe5 - I don't think the code was originally that early.
It is slightly earlier than 2.6.22 (outside the '/* now count some
things */' loop) to make sure the R5_Wantfill flags from the last
request have been cleared before starting a new one:

		/* maybe we can request a biofill operation
		 *
		 * new wantfill requests are only permitted while
		 * STRIPE_OP_BIOFILL is clear
		 */
		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread &&
			!test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
			set_bit(R5_Wantfill, &dev->flags);

> But it is probably right.   Hopefully my brain will have cleared by
> Monday and I'll review it again then.
>

Ok, the tree is updated with 'Reviewed-by' tags and the proposed
documentation updates from Randy and Shannon.

git://lost.foo-projects.org/~dwillia2/git/iop async-tx-fixes-for-linus

Dan Williams (3):
      async_tx: usage documentation and developer notes (v2)
      async_tx: fix dma_wait_for_async_tx
      raid5: fix ops_complete_biofill

> NeilBrown

--
Dan
