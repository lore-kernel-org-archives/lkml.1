Return-Path: <linux-kernel-owner+w=401wt.eu-S1030424AbXCCVOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030424AbXCCVOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030429AbXCCVOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:14:21 -0500
Received: from mail.tmr.com ([64.65.253.246]:56762 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030424AbXCCVOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:14:20 -0500
Message-ID: <45E9E58C.1060405@tmr.com>
Date: Sat, 03 Mar 2007 16:15:56 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Uwe Bugla <uwe.bugla@gmx.de>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: bugs in kernel 2.6.21 (both two release candidates) and kernel
 2.6.20
References: <20070303155536.65380@gmx.net>
In-Reply-To: <20070303155536.65380@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Bugla wrote:
> Hi folks,
> the floppy mount error I mentioned is gone now in 2.6.21-rc2, and my kernel is smaller. Good decision to rip out Stephane's stuff, Linus!
> As I did not get a reply from Andrew I hope that the buggy stuff residing in 2.6.20-mm1 ( freezing my apache services
> - I already mentioned the problem some days ago - mm2 I did not try yet ) will never be pushed into vanilla mainline.
> I owe some old CDROM and CDRW devices manufactured by TEAC (bought somewhen in 1999): CDR 540 and CDRW 54.
> Those old CD devices sometimes get confused with drive seek errors and status errors shown in dmesg.
> The newer DVD devices (LG reading device and Yamakawa burning device) do not show those errors at all.
> As I have finished an enourmous project 6 weeks ago (transforming some 500 Audio CDs to MP3 format
> with kaudiocreator and lame 3.97 (320 kbit quality - preset insane) and then burning the material on DVDs)
> those old devices were an incredible help in some cases where the newer DVD devices refused to read some audio
> CDs without errors. That's why I do not want to kick them off at all. Never had those troubles with kernel 2.6.19 and former ones.

Other than wanting to stay current, is there a reason why you need to go 
to a newer kernel to do this process? Would it be an option just to run 
on a kernel which works for the moment?

Assuming that you don't want to use these drives unless you can't read a 
CD any other way, would it be practical to (a) move these drives to 
another machine and run and old kernel, (b) try a newer CD (not DVD) 
reader, or (c) install one or both of these antiques in a USB external 
enclosure which would allow you to reinsert the drive rather than reboot?

It may take a while for this problem to be identified, I doubt there are 
many around for developers to test. If I have one in the "old junk" 
closet anyone is welcome to it, but I have donated a lot of built from 
parts machines to various people and causes, so anything that old is 
unlikely to be found.

> Dmesg 1 says on my AMD machine with a CDR540 as /dev/hdd during boot process:
> hdd: media error (bad sector): status=0x51 { DriveReady SeekComplete Error }
> hdd: media error (bad sector): error=0x34 { AbortedCommand LastFailedSense=0x03 }
> ide: failed opcode was: unknown
> ATAPI device hdd:
>   Error: Medium error -- (Sense key=0x03)
>   (reserved error code) -- (asc=0x02, ascq=0x00)
>   The failed "Read 10" packet command was:
>   "28 00 00 00 00 10 00 00 02 00 00 00 00 00 00 00 "
> end_request: I/O error, dev hdd, sector 64
> Buffer I/O error on device hdd, logical block 8
> hdd: media error (bad sector): status=0x51 { DriveReady SeekComplete Error }
> hdd: media error (bad sector): error=0x34 { AbortedCommand LastFailedSense=0x03 }
> ide: failed opcode was: unknown
> ATAPI device hdd:
>   Error: Medium error -- (Sense key=0x03)
>   (reserved error code) -- (asc=0x02, ascq=0x00)
>   The failed "Read 10" packet command was:
>   "28 00 00 00 00 10 00 00 02 00 00 00 00 00 00 00 "
> end_request: I/O error, dev hdd, sector 64
> Buffer I/O error on device hdd, logical block 8
> 
> But even more crucial is this one:
> Dmesg 2 says on the Intel machine with a TEAC CDRW54 as /dev/hdd:
> hdd: status error: status=0x7f { DriveReady DeviceFault SeekComplete DataRequest CorrectedError Index Error }
> hdd: status error: error=0x7f { IllegalLengthIndication EndOfMedia AbortedCommand MediaChangeRequested LastFailedSense=0x07 }
> ide: failed opcode was: unknown
> For about 1 second the whole system hangs while /dev/hdd is executing some kind of reinitialization, just like as if you unconnect
> the data and the 12 V / 6V cable and reconnect them again while the machine is up and running.
> For a DVB-S record f. ex. the breakdown of the recording can be one consequence.
> Question: Can someone reading this please confirm these errors? Please take old CD devices to find out, not newer ones or even DVD devices!
> I am using the standard IDE driver with the following chipsets: Intel ICH4 and SIS 5513. And please take time, as these crucial errors do not happen
> immediately, but about 4 times in about 8 - 10 hours while the machine is up and running.
> 
> Yours sincerely and thanks for all your efforts
> 
> Uwe
> P. S.: I do not think this is a hardware error as I did not have those problems with kernels <= 2.6.19.
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
