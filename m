Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYDWJeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYDWJeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYDWJd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:33:56 -0400
Received: from mr1.bfh.ch ([147.87.250.50]:44599 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbYDWJdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:33:55 -0400
Message-ID: <480F0278.1080007@bfh.ch>
Date: Wed, 23 Apr 2008 11:33:44 +0200
From: Seewer Philippe <philippe.seewer@bfh.ch>
Organization: BFH
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>	 <480354C9.1050600@bfh.ch>	 <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>	 <4805AF93.90209@bfh.ch>	 <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com>	 <4807635E.9060101@bfh.ch> <4808A09B.6090106@rtr.ca>	 <38b2ab8a0804221316o7cab5641q16814849a1099b9a@mail.gmail.com>	 <480E6A35.4040108@rtr.ca> <38b2ab8a0804230002x4b626fa6p89fe940e8e0ff374@mail.gmail.com>
In-Reply-To: <38b2ab8a0804230002x4b626fa6p89fe940e8e0ff374@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Apr 2008 09:33:27.0758 (UTC) FILETIME=[15C3B6E0:01C8A525]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Francis Moreau wrote:
[snip]
> If I'd like to take a look in the kernel code to see where the kernel
> translates an offset
> provided by sys_read into a LBA or CHS address, where should I go ?
> drivers/block ?
No just /block

from Documentation/block/biodoc.txt

[quote]
Drivers no longer have to map a {partition, sector offset} into the
correct absolute location anymore, this is done by the block layer, so
where a driver received a request ala this before:

         rq->rq_dev = mk_kdev(3, 5);     /* /dev/hda5 */
         rq->sector = 0;                 /* first sector on hda5 */

   it will now see

         rq->rq_dev = mk_kdev(3, 0);     /* /dev/hda */
         rq->sector = 123128;            /* offset from start of disk */
[/quote]


/drivers/block is block-device drivers not the block layer itself.
