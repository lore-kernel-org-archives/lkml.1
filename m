Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYGXQxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYGXQxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYGXQxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:53:15 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38004 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbYGXQxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:53:14 -0400
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
	blk_recalc_rq_segments about VMERGE
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0807241232040.9412@devserv.devel.redhat.com>
References: <1216520228.3376.33.camel@localhost.localdomain>
	 <20080719.210737.197246608.davem@davemloft.net>
	 <1216565545.4199.10.camel@localhost.localdomain>
	 <20080720.102302.137955996.davem@davemloft.net>
	 <1216575211.4199.35.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0807241103190.1545@devserv.devel.redhat.com>
	 <1216913314.4524.25.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0807241232040.9412@devserv.devel.redhat.com>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 12:52:51 -0400
Message-Id: <1216918371.4524.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 12:34 -0400, Mikulas Patocka wrote:
> On Thu, 24 Jul 2008, James Bottomley wrote:
> 
> > On Thu, 2008-07-24 at 11:07 -0400, Mikulas Patocka wrote:
> > > So try to #define BIO_VMERGE_BOUNDARY 0 for Pa-Risc and tell us what 
> > > performance degradation do you see (and what driver do you use and what is 
> > > the I/O pattern).
> > > 
> > > If you show something specific, we can consider that --- but you haven't 
> > > yet told us anything, except generic talk.
> > 
> > You keep ignoring inconvenient facts.  For about the third time:
> > 
> > I run a test bed for sg_tables (large chaining of requests).  This runs
> > on parisc using virtual merging (has to because the final physical table
> > size can't go over the sg list of the SCSI card).  If I turn off virtual
> > merging I can no longer test sg_tables in vanilla kernels.
> > 
> > James
> 
> What sg_tables test do you mean? What does the test do? Why couldn't you 
> run the test if BIO_VMERGE_BOUNDARY is 0? Normal I/O obviously can work 
> with BIO_VMERGE_BOUNDARY 0, the kernel will just send more smaller 

Look, if you don't really understand what I'm doing, it's not really my
job to educate you.  The sg_table discussions are on marc.info, mainly
on the SCSI lists; just look for 'sg chaining' in the header (need to
use google site ... marc's search is bad).

You can complain if the code is impacting you ... but I believe I've
optimised it so it isn't.  Your basic problem amounts to you not liking
me doing something that has no impact on you ... I'm afraid that's what
freedom leads to (shocking, I know).

James


