Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXBQVfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXBQVfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933011AbXBQVfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:35:19 -0500
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:38412 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932991AbXBQVfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:35:16 -0500
X-Greylist: delayed 842 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Feb 2007 16:35:15 EST
Date: Sat, 17 Feb 2007 22:18:41 +0100
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: stern@rowland.harvard.edu, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, James.Bottomley@steeleye.com,
       dougg@torque.net
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
Message-ID: <45d77131.+T7gCigNPHcfrnkV%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0702161422100.3490-100000@iolanthe.rowland.org>
 <20070217062832.GE3689@kernel.dk>
In-Reply-To: <20070217062832.GE3689@kernel.dk>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:

> > This will make it possible for cdrecord and related programs to
> > retrieve reliably the max_sectors value, regardless of whether the
> > user points it to an sr or an sg device.  In particular, this will
> > resolve Bugzilla entry #7026.
>
> The block bits are fine with me, the sg calling point is a bit of a sore
> thumb (a char driver calling into block layer ioctls) though. So the
> block layer bits are certainly ok with me, if Doug acks the sg bit I'll
> merge everything up.

If you care about this kind of order, you would first need to eliminate the
ability of doing low level things like SG_IO from block drivers as this is 
similar low level stuff that rather belongs to low level drivers.

Any driver that allows to use low level interfaces to send RAW SCSI commands
also needs access to other lowlevel stuff like the ability to know the 
max. DMA size.



Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
