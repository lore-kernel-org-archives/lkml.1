Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbXEKQTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbXEKQTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbXEKQS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:18:58 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:50636 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759208AbXEKQS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:18:57 -0400
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
In-Reply-To: <20070508170335.1b1f844c@the-village.bc.nu>
References: <20070508170335.1b1f844c@the-village.bc.nu>
Content-Type: text/plain
Date: Fri, 11 May 2007 11:18:53 -0500
Message-Id: <1178900333.3692.44.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 17:03 +0100, Alan Cox wrote:
> The CD-ROM layer doesn't bounce requests for old ISA controllers (and
> nor should it). However they get injected into the SCSI layer via
> sr_ioctl which also doesn't bounce them and SCSI then passes the buffer
> along to a device with unchecked_isa_dma set which either panics or
> truncates the buffer to 24bits.
> 
> According to Jens the right long term fix is for the CD layer to route
> the requests differently but in the mean time this has been tested by a
> victim and verified to sort the problem out. For the other 99.9% of users
> it's a no-op and doesn't bounce data.

OK, the alternative fix for this is in the vanilla tree.

Could you make sure it works ... if it does, I think it's a candidate
for 2.6.21 stable as well.

James


