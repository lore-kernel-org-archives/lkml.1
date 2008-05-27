Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbYE0W0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbYE0W0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbYE0W0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:26:24 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:41386 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbYE0W0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:26:23 -0400
Date: Tue, 27 May 2008 18:26:18 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: floppy question of the hour
In-reply-to: <483C81DE.8060002@cfl.rr.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>
Message-id: <200805271826.18320.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200805232114.20937.gene.heskett@gmail.com>
 <200805240852.58268.gene.heskett@gmail.com> <483C81DE.8060002@cfl.rr.com>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008, Phillip Susi wrote:
>Gene Heskett wrote:
>> This is a 250 kilobaud data rate format, the maximum the WD-1773 FDC chip
>> in the target machine can handle, with 18, 256 byte sectors per track, two
>> sides=73728 bits to write a track, /250000 (baud rate)=0.294912 seconds to
>> write one full tracks worth of data. 80 tracks=23.59296 seconds to write
>> the whole disk if it were streaming, but it takes 3 minutes and change? 
>> And nearly 2 to read it back as above?  Odd.  With the interleave of 3, I
>> could see 75 seconds maybe for efficient methods.  I also understand this
>> is a one size fits all scene too, and that there must be compromises.
>>
>> I format these DD discs in the target machine with an interleave factor of
>> 3 cuz that machines cpu is running at as low as .89MHZ and can't handle
>> the read data any faster than that.
>>
>> Is this non-1 interleave responsible for the slowness of the writes or
>> reads on this box?  I can control the interleave on the target box, so I
>> suppose I could test that effect easily enough.
>
>Yes, the interleave slows you down, since after accessing sector 1, the
>head must wait to pass over 3 other sectors before finally reaching
>sector 2, therefore, you can only read 1/4 of the sectors on the track
>each revolution of the disk.  That leaves 4 revolutions at 300 rpm
>giving 0.8s to read a track, or 64 seconds to read all 80 tracks, plus
>seek time.  That still does not explain 3 minutes though... not sure
>what else could be slowing you down.

Does anyone know if either the floppy driver, or dd, is doing a verification 
read after each sector is written?  That could make it just sort of ooze thru 
the data as that alone would add an additional 18 revolutions of the disk per 
track written, 256 byte sectors in this mode.  That thought has crossed my 
mind, but a full read of that same disk with dd which picks up another 200k of 
empty data, completes in maybe 10 seconds less in total elapsed time.

Also, does anyone know how long after a floppy is inserted before it is 
recognized?  From observation today, it appears to be something in the 5 minute 
territory before a getfdprm returns data instead of "/dev/fd0: no such device".

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I hear what you're saying but I just don't care.
