Return-Path: <linux-kernel-owner+w=401wt.eu-S1030488AbXAaSN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030488AbXAaSN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030485AbXAaSN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:13:26 -0500
Received: from accolon.hansenpartnership.com ([64.109.89.108]:45365 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030481AbXAaSNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:13:25 -0500
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mark Lord <liml@rtr.ca>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Ric Wheeler <ric@emc.com>,
       "Eric D. Mudama" <edmudama@gmail.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
In-Reply-To: <45C0D8A1.2030506@rtr.ca>
References: <200701301947.08478.liml@rtr.ca>
	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>
	 <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>
	 <45BFF3D6.9050605@rtr.ca>	<45C00AEE.1090708@emc.com>
	 <45C0B0DC.8030501@rtr.ca> <20070131152301.19a8a5ac@localhost.localdomain>
	 <45C0D8A1.2030506@rtr.ca>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 12:13:18 -0600
Message-Id: <1170267198.3402.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 12:57 -0500, Mark Lord wrote:
> Alan wrote:
> >> When libata reports a MEDIUM_ERROR to us, we *know* it's non-recoverable,
> >> as the drive itself has already done internal retries (libata uses the
> >> "with retry" ATA opcodes for this).
> > 
> > This depends on the firmware. Some of the "raid firmware" drives don't
> > appear to do retries in firmware.
> 
> One way to tell if this is true, is simply to time how long
> the failed operation takes.  If the drive truly does not do retries,
> then the media error should be reported more or less instantly
> (assuming drive was already spun up).

Well, the simpler way (and one we have a hope of implementing) is to
examine the ASC/ASCQ codes to see if the error is genuinely unretryable.

I seem to have dropped the ball on this one in that the scsi_error.c
pieces of this patch

http://marc.theaimsgroup.com/?l=linux-scsi&m=116485834119885

I thought I'd applied.  Apparently I didn't, so I'll go back and put
them in.

James


