Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbYE0V7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbYE0V7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbYE0V7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:59:31 -0400
Received: from exhub016-3.exch016.msoutlookonline.net ([207.5.72.226]:54481
	"EHLO EXHUB016-3.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757898AbYE0V7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:59:30 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2008 17:59:30 EDT
Message-ID: <483C81DE.8060002@cfl.rr.com>
Date: Tue, 27 May 2008 17:49:18 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: floppy question of the hour
References: <200805232114.20937.gene.heskett@gmail.com> <4837DFC6.9010202@s5r6.in-berlin.de> <200805240852.58268.gene.heskett@gmail.com>
In-Reply-To: <200805240852.58268.gene.heskett@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> This is a 250 kilobaud data rate format, the maximum the WD-1773 FDC chip in the 
> target machine can handle, with 18, 256 byte sectors per track, two sides=73728 
> bits to write a track, /250000 (baud rate)=0.294912 seconds to write one full 
> tracks worth of data. 80 tracks=23.59296 seconds to write the whole disk if it 
> were streaming, but it takes 3 minutes and change?  And nearly 2 to read it 
> back as above?  Odd.  With the interleave of 3, I could see 75 seconds maybe 
> for efficient methods.  I also understand this is a one size fits all scene 
> too, and that there must be compromises.
> 
> I format these DD discs in the target machine with an interleave factor of 3 cuz 
> that machines cpu is running at as low as .89MHZ and can't handle the read data 
> any faster than that.
> 
> Is this non-1 interleave responsible for the slowness of the writes or reads on 
> this box?  I can control the interleave on the target box, so I suppose I could 
> test that effect easily enough.

Yes, the interleave slows you down, since after accessing sector 1, the 
head must wait to pass over 3 other sectors before finally reaching 
sector 2, therefore, you can only read 1/4 of the sectors on the track 
each revolution of the disk.  That leaves 4 revolutions at 300 rpm 
giving 0.8s to read a track, or 64 seconds to read all 80 tracks, plus 
seek time.  That still does not explain 3 minutes though... not sure 
what else could be slowing you down.


