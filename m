Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYAWAgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYAWAgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYAWAgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:36:07 -0500
Received: from mail.tmr.com ([64.65.253.246]:52983 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYAWAgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:36:05 -0500
Message-ID: <4796924D.1030503@tmr.com>
Date: Tue, 22 Jan 2008 20:03:09 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Massive IDE problems. Who leaves data here?
References: <fn5ivo$ck2$1@ger.gmane.org>
In-Reply-To: <fn5ivo$ck2$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Reimer wrote:
> Hello,
> 
> anything started with a try to burn Slackware 12.0 from the original DVD 
> to an new medium with different boot settings. I always got corrupted 
> results and didn't know why.
> 
> So I started with an "md5sum -c CHECKSUMS.md5" directly on the original 
> media. This resulted in "anything OK".
> 
> Now I copied the whole DVD to my hard drive and created an ISO from it. 
> I mounted the ISO locally and my md5sum now results in 5 corrupted files.
> 
> --> A Bug in mkisofs?
> 
> No, unfortunately not, as a md5sum on the copy, I have created from the 
> original DVD by using "cp -vr" is corrupted, too!
> 
Possibly a known kernel problem, you may have read past the end of data 
into the pad sectors of the DVD and gotten garbage at the end of the ISO 
image. Use isoinfo to determine the correct size of the ISO filesystem, 
and compare. You can try setting readahead on the DVD reader to zero 
with blockdev.

If the file is smaller, other bug, if readahead hit EOF it returns no 
data instead of a short read, the blockdev fix should handle that as 
well. This was supposed to be fixed in recent kernels, that may be true.

I suggest the cdwrite@other.debian.org mailing list is a better forum 
for CD/DVD/BR problems, good technical people, unfortunately with 
personal agendas in some cases.

> So md5sum on the original DVD is OK, but after copying to my hard drive, 
> several files are corrupted.
> 
That's odd, I would expect the data on the disk to just be the wrong 
size, and get a CRC on that. You might also use readcd to pull the data, 
that almost always does what it should.

> I'm using kernel 2.6.21.5. Distribution is Slackware 12.0
> All my "partitions" are LVs in LVM2
> 
> I also updated the kernel to 2.6.23.12 to test with this one, but I 
> still get corrupted files.
> 
> Is this a LVM bug? Do I already have a corrupted LVM filesystem? How to 
> check/fix it? Is this a known kernel bug? Which may be the reason for 
> corrupted files?
> 
> I've created a backup of my important data to a second disc to a "real 
> ext2 partition" (without LVM), but this is connected to the same IDE 
> controller and I don't even know if I may still trust my mainboard...
> 
> I also get those kernel messages via dmesg:
> 
> http://pastebin.org/16537
> 
Could be anything, in no order dirty lens, bad drive, bad DVD, firmware 
error, cable, power supply, acpi confused... could even be a poorly 
handled end of data on the DVD. Not enough info for me to tell, for 
sure. Trying readcd is cheap, turning off readahead on the DVD drive is 
easy, if the problem persists you probably want to take it to the 
mailing list.

> Thank you very much in advance for any help!
> 
I'm not sure I helped, but you now have more and better things about 
which to be confused.  ;-)

> Yours
> 
> Manuel
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
