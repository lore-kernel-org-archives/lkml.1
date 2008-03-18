Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYCRATR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYCRATR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 20:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYCRATF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 20:19:05 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:49727 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355AbYCRATE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 20:19:04 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <alpine.LFD.1.00.0803171548480.3020@woody.linux-foundation.org> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com> <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org> <200803162054.04757.bzolnier@gmail.com> <20080316225921.CAA082DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803161618480.3020@woody.linux-foundation.org> <20080317210901.0135A93C911@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803171548480.3020@woody.linux-foundation.org>
Comments: In-reply-to Linus Torvalds <torvalds@linux-foundation.org>
   message dated "Mon, 17 Mar 2008 15:52:57 -0700."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 18 Mar 2008 01:18:31 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080318001831.575D093C911@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JbPXF-0007m5-64.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JbPXF-0007m5-64 2fd1a3318e0f71db60cf4936b7483880
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


torvalds@linux-foundation.org said:
> So try to see if you get to ide_error(), which is where Bartlomiejs latest
> patch was in effect - but add a few printk's there to print out the 'stat'
> variable etc to see if it actually triggers. And maybe a WARN_ON(1) to get
> the trace.. 

Seems we don't. At least this addition didn't yield anything:

ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
{
        ide_hwif_t *hwif = drive->hwif;
        struct request *rq = hwif->hwgroup->rq;
        u8 err;

              printk("ide_error(msg=%s, stat=%i)\n",msg,stat);
              WARN_ON(1);
               if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {

Going to bed...

/A

