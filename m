Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbYKENKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbYKENKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbYKENJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:09:47 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33209 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755068AbYKENJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:09:46 -0500
Subject: Re: [PATCH 03/18] libosd: OSDv1 Headers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, michaelc@cs.wisc.edu,
       fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sami.Iren@seagate.com, pw@padd.com
In-Reply-To: <49119774.10706@panasas.com>
References: <491073BB.4000900@panasas.com>
	 <1225817046-5946-1-git-send-email-bharrosh@panasas.com>
	 <20081104111037.bcae04e5.akpm@linux-foundation.org>
	 <49119774.10706@panasas.com>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 08:09:32 -0500
Message-Id: <1225890572.4703.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 14:54 +0200, Boaz Harrosh wrote:
> >> +    struct _osd_io_info {
> >> +            struct bio *bio;
> >> +            u64 total_bytes;
> > 
> > u64(!)
> > 
> 
> Do you mean that I need to use __u64? or what do you mean?

He means you've used u64 in a header without actually including any file
that defines the typedef.  Linux header files aren't supposed to depend
on include order.  They're supposed to stand alone.  The point is that
if I include just #include osd_initiator.h into an empty kernel file
it's not supposed to spit undefined errors.

Right at the moment the u64 probably works because blkdev.h #includes
the file which defines it, but you're not supposed to rely on that.

James


