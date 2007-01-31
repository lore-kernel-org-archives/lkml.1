Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbXAaEVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbXAaEVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 23:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXAaEVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 23:21:34 -0500
Received: from accolon.hansenpartnership.com ([64.109.89.108]:47342 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbXAaEVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 23:21:33 -0500
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ric Wheeler <ric@emc.com>
Cc: Mark Lord <liml@rtr.ca>, "Eric D. Mudama" <edmudama@gmail.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <45C00AEE.1090708@emc.com>
References: <200701301947.08478.liml@rtr.ca>
	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>
	 <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>
	 <45BFF3D6.9050605@rtr.ca>  <45C00AEE.1090708@emc.com>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 22:21:28 -0600
Message-Id: <1170217288.10890.37.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 22:20 -0500, Ric Wheeler wrote:
> Mark Lord wrote:
> > The number of retries is an entirely separate issue.
> > If we really care about it, then we should fix SD_MAX_RETRIES.
> >
> > The current value of 5 is *way* too high.  It should be zero or one.
> >
> > Cheers
> >
> I think that drives retry enough, we should leave retry at zero for 
> normal (non-removable) drives. Should this  be a policy we can set like 
> we do with NCQ queue depth via /sys ?

I don't disagree that it should be settable.  However, retries occur for
other reasons than failures inside the device.  The most standard ones
are unit attentions generated because of other activity (target reset
etc).  The key to the problem is retrying only operations that are
genuinely retryable, which the mid-layer doesn't do such a good job on.

> We need to be able to layer things like MD on top of normal drive errors 
> in a way that will produce a system that provides reasonable response 
> time despite any possible IO error on a single component.  Another case 
> that we end up doing on a regular basis is drive recovery. Errors need 
> to be limited in scope to just the impacted area and dispatched up to 
> the application layer as quickly as we can so that you don't spend days 
> watching a copy of  huge drive (think 750GB or more) ;-)

For the MD case, this is what REQ_FAILFAST is for.

James


