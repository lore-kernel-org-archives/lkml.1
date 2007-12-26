Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbXLZRNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbXLZRNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 12:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXLZRNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 12:13:21 -0500
Received: from [76.243.235.52] ([76.243.235.52]:37667 "EHLO
	accolon.hansenpartnership.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbXLZRNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 12:13:19 -0500
Subject: Re: [PATCH 7/7] sg_ring: convert core ATA code to sg_ring.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <47721294.7030401@gmail.com>
References: <200712191731.26512.rusty@rustcorp.com.au>
	 <200712191836.06769.rusty@rustcorp.com.au>
	 <200712191837.04697.rusty@rustcorp.com.au>
	 <200712191838.27363.rusty@rustcorp.com.au>  <47721294.7030401@gmail.com>
Content-Type: text/plain
Date: Wed, 26 Dec 2007 11:12:59 -0600
Message-Id: <1198689179.3317.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-26 at 17:36 +0900, Tejun Heo wrote:
> (PS, I haven't followed the sg chaining discussion.  Why is sg chaining
> an optional feature?  Performance overhead on low end machines?)

The idea of SG chaining is to allow drivers that wish to take advantage
of it to increase their transfer lengths beyond
MAX_HW_SEGMENTS*PAGE_SIZE by using chaining.  However, drivers that stay
below MAX_HW_SEGMENTS for the scatterlist length don't need to be
altered.

The ultimate goal (well, perhaps more wish) is to have all drivers
converted, so SCSI can use something small for the default scatterlist
sizing and dump all the sglist mempool stuff (although this may never be
reached).

James


