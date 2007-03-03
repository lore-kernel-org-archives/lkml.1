Return-Path: <linux-kernel-owner+w=401wt.eu-S1030695AbXCCRp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030695AbXCCRp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 12:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030697AbXCCRp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 12:45:58 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42112 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030695AbXCCRp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 12:45:57 -0500
Date: Sat, 3 Mar 2007 09:45:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: bugs in kernel 2.6.21 (both two release candidates) and kernel
 2.6.20
Message-Id: <20070303094546.9334b18c.akpm@linux-foundation.org>
In-Reply-To: <20070303155536.65380@gmx.net>
References: <20070303155536.65380@gmx.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 16:55:36 +0100 "Uwe Bugla" <uwe.bugla@gmx.de> wrote:

> Hi folks,
> the floppy mount error I mentioned is gone now in 2.6.21-rc2, and my kernel is smaller. Good decision to rip out Stephane's stuff, Linus!
> As I did not get a reply from Andrew I hope that the buggy stuff residing in 2.6.20-mm1 ( freezing my apache services
> - I already mentioned the problem some days ago - mm2 I did not try yet ) will never be pushed into vanilla mainline.

Please do test rc2-mm1.

There are around seventy different developers' trees in -mm.  Quite a few of them
could have caused this.  It's indeed possible that the bug will get into 2.6.22
if few people are hitting it.

> I owe some old CDROM and CDRW devices manufactured by TEAC (bought somewhen in 1999): CDR 540 and CDRW 54.
> Those old CD devices sometimes get confused with drive seek errors and status errors shown in dmesg.
> The newer DVD devices (LG reading device and Yamakawa burning device) do not show those errors at all.
> As I have finished an enourmous project 6 weeks ago (transforming some 500 Audio CDs to MP3 format
> with kaudiocreator and lame 3.97 (320 kbit quality - preset insane) and then burning the material on DVDs)
> those old devices were an incredible help in some cases where the newer DVD devices refused to read some audio
> CDs without errors. That's why I do not want to kick them off at all. Never had those troubles with kernel 2.6.19 and former ones.
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

Cc's added.
