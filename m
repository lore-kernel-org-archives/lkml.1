Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbXLMWPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbXLMWPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbXLMWPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:15:20 -0500
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:48570
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbXLMWPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:15:17 -0500
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, liml@rtr.ca, lkml@rtr.ca,
       matthew@wil.cx, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20071213140207.111f94e2.akpm@linux-foundation.org>
References: <20071213185326.GQ26334@parisc-linux.org>
	 <4761821F.3050602@rtr.ca> <20071213192633.GD10104@kernel.dk>
	 <4761883A.7050908@rtr.ca> <476188C4.9030802@rtr.ca>
	 <20071213193937.GG10104@kernel.dk> <47618B0B.8020203@rtr.ca>
	 <20071213195350.GH10104@kernel.dk> <20071213200219.GI10104@kernel.dk>
	 <476190BE.9010405@rtr.ca> <20071213200958.GK10104@kernel.dk>
	 <20071213140207.111f94e2.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 17:15:06 -0500
Message-Id: <1197584106.3154.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 14:02 -0800, Andrew Morton wrote:
> On Thu, 13 Dec 2007 21:09:59 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> >
> > OK, it's a vm issue,
> 
> cc linux-mm and probable culprit.
> 
> >  I have tens of thousand "backward" pages after a
> > boot - IOW, bvec->bv_page is the page before bvprv->bv_page, not
> > reverse. So it looks like that bug got reintroduced.
> 
> Bill Irwin fixed this a couple of years back: changed the page allocator so
> that it mostly hands out pages in ascending physical-address order.
> 
> I guess we broke that, quite possibly in Mel's page allocator rework.
> 
> It would help if you could provide us with a simple recipe for
> demonstrating this problem, please.

The simple way seems to be to malloc a large area, touch every page and
then look at the physical pages assigned ... they now mostly seem to be
descending in physical address.

James


