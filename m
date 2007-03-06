Return-Path: <linux-kernel-owner+w=401wt.eu-S965356AbXCFR1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbXCFR1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965363AbXCFR1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:27:35 -0500
Received: from mail.gmx.net ([213.165.64.20]:34869 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965356AbXCFR1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:27:33 -0500
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 06 Mar 2007 18:27:30 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <200703031925.29551.bzolnier@gmail.com>
Message-ID: <20070306172730.276350@gmx.net>
MIME-Version: 1.0
References: <20070303155536.65380@gmx.net>
 <200703031925.29551.bzolnier@gmail.com>
Subject: Re: bugs in kernel 2.6.21 (both two release candidates) and kernel
 2.6.20
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19SOKZNye9S8D+vdWm7zsNuVEGn/xsbF9bBzTBC76
 +v2UJ7HFVifC2xN7J1tWyrHEVTQigKdJdaXw== 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Sat, 3 Mar 2007 19:25:29 +0100
Von: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
An: "Uwe Bugla" <uwe.bugla@gmx.de>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>
Betreff: Re: bugs in kernel 2.6.21 (both two release candidates) and kernel 2.6.20

> 
> Hi Uwe,
> 
> On Saturday 03 March 2007, Uwe Bugla wrote:
> > Hi folks,
> > the floppy mount error I mentioned is gone now in 2.6.21-rc2, and my
> kernel is smaller. Good decision to rip out Stephane's stuff, Linus!
> > As I did not get a reply from Andrew I hope that the buggy stuff
> residing in 2.6.20-mm1 ( freezing my apache services
> > - I already mentioned the problem some days ago - mm2 I did not try yet
> ) will never be pushed into vanilla mainline.
> > I owe some old CDROM and CDRW devices manufactured by TEAC (bought
> somewhen in 1999): CDR 540 and CDRW 54.
> > Those old CD devices sometimes get confused with drive seek errors and
> status errors shown in dmesg.
> > The newer DVD devices (LG reading device and Yamakawa burning device) do
> not show those errors at all.
> > As I have finished an enourmous project 6 weeks ago (transforming some
> 500 Audio CDs to MP3 format
> > with kaudiocreator and lame 3.97 (320 kbit quality - preset insane) and
> then burning the material on DVDs)
> > those old devices were an incredible help in some cases where the newer
> DVD devices refused to read some audio
> > CDs without errors. That's why I do not want to kick them off at all.
> Never had those troubles with kernel 2.6.19 and former ones.
> 
> > Dmesg 1 says on my AMD machine with a CDR540 as /dev/hdd during boot
> process:
> > hdd: media error (bad sector): status=0x51 { DriveReady SeekComplete
> Error }
> > hdd: media error (bad sector): error=0x34 { AbortedCommand
> LastFailedSense=0x03 }
> > ide: failed opcode was: unknown
> > ATAPI device hdd:
> >   Error: Medium error -- (Sense key=0x03)
> >   (reserved error code) -- (asc=0x02, ascq=0x00)
> >   The failed "Read 10" packet command was:
> >   "28 00 00 00 00 10 00 00 02 00 00 00 00 00 00 00 "
> > end_request: I/O error, dev hdd, sector 64
> 
> Hmm. why does it try to read sector 64 during boot?
> 
> Could you make sure that there are not configuration files/options
> incorrectly
> referring to /dev/hdd (please grep you /etc and /boot for for "/dev/hdd")?
Thanks, I will try to do so.
> 
> [ ... ]
> 
> > But even more crucial is this one:
> > Dmesg 2 says on the Intel machine with a TEAC CDRW54 as /dev/hdd:
> > hdd: status error: status=0x7f { DriveReady DeviceFault SeekComplete
> DataRequest CorrectedError Index Error }
> > hdd: status error: error=0x7f { IllegalLengthIndication EndOfMedia
> AbortedCommand MediaChangeRequested LastFailedSense=0x07 }
> > ide: failed opcode was: unknown
> > For about 1 second the whole system hangs while /dev/hdd is executing
> some kind of reinitialization, just like as if you unconnect
> > the data and the 12 V / 6V cable and reconnect them again while the
> machine is up and running.
> 
> It really looks like a hardware related problem (power supply/power
> cable).
But it is none, definitely not. There are also system hangups without that stupid reinitialization of the burning device. No idea where the reason for that may stay, but I swear I am gonna do my best to find out.
> 
> > For a DVB-S record f. ex. the breakdown of the recording can be one
> consequence.
> > Question: Can someone reading this please confirm these errors? Please
> take old CD devices to find out, not newer ones or even DVD devices!
> > I am using the standard IDE driver with the following chipsets: Intel
> ICH4 and SIS 5513. And please take time, as these crucial errors do not
> happen
> > immediately, but about 4 times in about 8 - 10 hours while the machine
> is up and running.
> 
> The "randomness" of the issue is another indicator that it could be power
> related.  Could it be that the issue happens when the system is rather
> busy?
It is not busy at all, but it happens.
> 
> > Yours sincerely and thanks for all your efforts
> > 
> > Uwe
> > P. S.: I do not think this is a hardware error as I did not have those
> problems with kernels <= 2.6.19.
> 
> I went through 2.6.19 -> 2.6.20 IDE changes and it is highly unlikely that
> the breakage is caused by IDE driver.  Anyway to be sure I've prepared a
> patch for you:
> 
> 	http://kernel.org/pub/linux/kernel/people/bart/ide-2.6.20.patch#
Great! I am gonna revert this one and keep on testing. But it takes time and the machine must run several hours. If it is not IDE related then it may be time related. Anyway that is the most crucial bug I have ever tried to trace. More evil like a virus!
> 
> it contains all 2.6.19 -> 2.6.20 IDE changes - we need to know whether the
> 2.6.20 kernel with the above patch reversed (applied with -R) works.
> 
> [ If it still won't work with the patch applied that must be some other
> thing
>   and we are left with trying git bisect or a lot of unreliable guesswork.
> ]
> 
> Please also post (preferably by filling bug at http://bugzilla.kernel.org)
> outputs of dmesg and lspci -vvvxxx commands from 2.6.19 and 2.6.20 so we
> can
> check if anything changed in the way that ATA devices/hosts are programmed
> on your systems between 2.6.19 and 2.6.20.
> 
> I'm also cc:ing our new ide-cd Maintainer (Hi Alan) who may shed some more
> light on the problems.
> 
> PS please always cc: linux-ide mailing list on ATA problems, problems
> won't
> get fixed if information about them doesn't reach the right people...
> 
> Thanks,
> Bart

1000 thanks to you

Uwe

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: www.gmx.net/de/go/mailfooter/topmail-out
