Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbXJQWKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbXJQWKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXJQWKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:10:32 -0400
Received: from mail.tmr.com ([64.65.253.246]:50630 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092AbXJQWKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:10:31 -0400
Message-ID: <47168A5B.2020304@tmr.com>
Date: Wed, 17 Oct 2007 18:19:07 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Michael Stiller <ms@2scale.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: howto boost write(2) performance?
References: <1191937817.3641.9.camel@blackberry>
In-Reply-To: <1191937817.3641.9.camel@blackberry>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stiller wrote:
> Hi list,
> 
> i'm developing an application (in C) which needs to write about 
> 1Gbit/s (125Mb/s) to a disk array attached via U320 SCSI. 
> It runs on Dual Core 2 Xeons @2Ghz utilizing kernel 2.6.22.7. 

People regularly report speeds higher than that on the RAID list, and I 
can get that order of magnitude speed using dd with 1MB buffers to a 
software RAID-0 array or cheap SATA drives. Are you using a decent 
controller? Many "RAID" controllers have bandwidth limitations, buffer 
size issues, etc. I had some chea "SCSI" arrays which were just SCSI 
controllers in from of a bunch of cheap, slow, non-SCSI drives.
> 
> I buffer the data in (currently 4) 400Mb buffers and use write(2) in a
> dedicated thread to write them to the raw disk (no fs).

I would limit the write size to a MB and see if that helps, regardless 
of the buffer size. A circular queue of smaller buffers, like ptbuf, may 
perform better.

> 
> The write(2) performance is not good enough, the writer threads take to
> much time, and i ask you for ideas, howto to boost the write
> performance. 
> 
> Maybe mmaping the disk would work? 

I don't think it would help, I'd really try limiting the size of the 
write() calls first, assuming your hardware is adequate.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
