Return-Path: <linux-kernel-owner+w=401wt.eu-S964785AbXBFQPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbXBFQPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964860AbXBFQPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:15:38 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:47002 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785AbXBFQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:15:37 -0500
Date: Tue, 06 Feb 2007 11:15:23 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: [PATCH][5/5] floppy.c: Fix device_create_file() warning
In-reply-to: <45C820EF.3030502@zytor.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jesper Juhl <jesper.juhl@gmail.com>,
       Andi Kleen <ak@suse.de>, Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <200702061115.24568.gene.heskett@verizon.net>
Organization: Not detectable
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200702060030.33671.jesper.juhl@gmail.com>
 <200702060059.18345.gene.heskett@verizon.net> <45C820EF.3030502@zytor.com>
User-Agent: KMail/1.9.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 February 2007 01:32, H. Peter Anvin wrote:
>Gene Heskett wrote:
>> On Monday 05 February 2007 18:30, Jesper Juhl wrote:
>>
>> And this is almost OT for this, but I'd like to interject here that in
>> recent history, it has been very very difficult to properly access
>> LSN0 of a floppy.  Some formats, such as those laid down by a WD-1773
>> floppy controller, do indeed use a sector marking of '0' (zero) on all
>> tracks.
>
>I thought the sector numbers of floppy discs were software programmable
>(at formatting time.)  I believe different OSes used different offsets,
>with 1, 2, 3... being the way IBM did it in the PC, but all kinds of
>variants were used, including things like 0xa0, 0xa1, ... for no
>apparent reason.
>
>	-hpa
>-
What I'm referring to hpa, is the suite of floppy tools that isn't even in 
the FC6 catalog for some reason, fdutils-x.x.  In the past when I was 
running fc2, I had to go find version 5.4, not 5.5 of that kit, build and 
install that, and then revert the floppy stuffs to something borrowed 
from a much older kernel before a command of 'setfdprm /dev/fd0 COCO720' 
could even get past the syntax error stage, and we traced it down to an 
inability to set a track format whose sector numbering scheme included a 
sector number of zero as the first sector of the track.

I have a copy of fdutils-5.4 here, which I have not done a make install of 
yet for FC6, so I should do a make clean;make;checkinstall --inspect and 
see if it will work.  I have not be able to do that since about 2.6.8 or 
so.

I just installed & tested it, and it appears to work correctly with the 
floppy driver in 2.6.20, but I'll see if I can dd a bootable floppy to 
it, the acid test for this user anyway... 10 minutes later, looking at 
the recovered image with khexedit, it looks good, everything is in the 
right place AFAICT, no little one byte offsets apparent.  So as long as 
I'm using the older fdutils version-5.4, it looks like it works.

If it does not work, then we have locked at least one vintage computer 
that I have several of, The TRS-80 Color Computer family, out of talking 
to linux by any means.  I have also spent the equ of several days trying 
to get its file transfer utility rzsz-3.36 based on Chuck Foresburgs 
code, to work through a pl2303 usb-serial convertor.  Something in the 
flow controls I think, I can type back and forth with terminal programs 
but nothing that sends large quantities of data works.

Maybe my fears are unfounded ATM, but I did want to voice them.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Yahoo.com and AOL/TW attorneys please note, additions to the above
message by Gene Heskett are:
Copyright 2007 by Maurice Eugene Heskett, all rights reserved.
