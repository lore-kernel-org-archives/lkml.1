Return-Path: <linux-kernel-owner+w=401wt.eu-S1750908AbXBRMk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908AbXBRMk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 07:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbXBRMk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 07:40:26 -0500
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:37509 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbXBRMkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 07:40:25 -0500
Date: Sun, 18 Feb 2007 13:37:49 +0100
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: jens.axboe@oracle.com, dougg@torque.net
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       James.Bottomley@steeleye.com
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
Message-ID: <45d8489d.1z3gW/oKAYBXy2Ws%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0702161422100.3490-100000@iolanthe.rowland.org>
 <20070217062832.GE3689@kernel.dk> <45D7CB46.6060807@torque.net>
In-Reply-To: <45D7CB46.6060807@torque.net>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Douglas Gilbert <dougg@torque.net> wrote:

> Jens Axboe wrote:
> > On Fri, Feb 16 2007, Alan Stern wrote:
> >> From: James Bottomley <James.Bottomley@SteelEye.com>
> >>
> >> This patch (as854) separates out the two queue-oriented ioctls from
> >> the rest of the block-layer ioctls.  The idea is that they should
> >> apply to any driver using a request_queue, even if the driver doesn't
> >> implement a block-device interface.  The prototypical example is the
> >> sg driver, to which the patch adds the new interface.
> >>
> >> This will make it possible for cdrecord and related programs to
> >> retrieve reliably the max_sectors value, regardless of whether the
> >> user points it to an sr or an sg device.  In particular, this will
> >> resolve Bugzilla entry #7026.
> > 
> > The block bits are fine with me, the sg calling point is a bit of a sore
> > thumb (a char driver calling into block layer ioctls) though. So the
> > block layer bits are certainly ok with me, if Doug acks the sg bit I'll
> > merge everything up.
> > 
> > (patch left below)
>
> Does this need to be in the sg driver?
>
> What is the hardware sector size of a SES or OSD device?
>
> As for the max_sector variable, wouldn't it be better
> to generate a new ioctl that yielded the limit in bytes?
> Making a driver variable that implicitly assumes sectors
> are 512 bytes in length more visible to the user space
> seems like a step in the wrong direction.

This is what I did propose. I know of no SCSI device made since 1986 that
has a "hardware sector size". This is really a DMA size limit in bytes
and if you return the number in an unrelated multiple of a fraction, you
will not be able to use the optmium max transfer size.

> Alternatively the SG_GET_RESERVED_SIZE ioctl could be
> modified to yield no more than max_sectors*512 .

This is what I did propose 3 months ago and already 2 years ago.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
