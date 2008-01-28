Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbYA1TIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbYA1TIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYA1TIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:08:35 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:48077 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYA1TIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:08:34 -0500
Date: Mon, 28 Jan 2008 13:59:23 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <479E1CF4.7060706@rtr.ca>
To: Mark Lord <lkml@rtr.ca>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801281359.24050.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801281156.28844.gene.heskett@gmail.com> <479E1CF4.7060706@rtr.ca>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Mark Lord wrote:
>> [   64.037975] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [   64.038102] ata1.00: BMDMA stat 0x65
>> [   64.038227] ata1.00: cmd c8/00:58:89:3d:07/00:00:00:00:00/e0 tag 0 dma
>> 45056 in [   64.038229]          res 51/40:58:8b:3d:07/00:00:00:00:00/e0
>> Emask 0x9 (media error) [   64.038432] ata1.00: status: { DRDY ERR }
>> [   64.038555] ata1.00: error: { UNC }
>> [   64.050125] ata1.00: configured for UDMA/100
>> [   64.050134] sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
>> [   64.050138] sd 0:0:0:0: [sda] Sense Key : 0x3 [current] [descriptor]
>> [   64.050142] Descriptor sense data with sense descriptors (in hex):
>> [   64.050143]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
>> [   64.050149]         00 07 3d 8b
>> [   64.050152] sd 0:0:0:0: [sda] ASC=0x11 ASCQ=0x4
>> [   64.050155] end_request: I/O error, dev sda, sector 474507
>
>..
>
>This error looks somewhat different from the samples posted earlier.
>This one is quite definitively a "bad sector".
>
>It should also show up in "smartctl -a -data /dev/sda" (near the bottom)
>if SMART was enabled on this drive at boot.
>
It does not unforch.

>You could try reading that specific sector again just to make sure.
>One way is to figure out how to use "dd" for this.
[root@coyote ~]# dd if=/dev/sda bs=512 skip=474506 count=3
��▒6
{�G���G���libkdecorations.so.1.0.0��c�®���J{�G���G���libkfontinst.so.0.0.0��c�®����"ʂ�GP�~GJ3G 
6�7�8�#��z;����{�G���G���libkhotkeys_shared.so.1.0.0��c�®���N{�G���G���libkickermain.so.1.0.0��c�®���Y{�G���G���libkonq.so.4.2.0��c�®���Z{�G���G���libkonqsidebarplugin.so.1.2.0��c�®���d{�G���G���libksgrd.so.1.2.0��c�®����▒��G7 
G▒�=G▒]��^���▒?����e{�G���G���libksplashthemes.so.0.0.0��c�®����{�G���G���libtaskbar.so.1.2.0��c�®����{�G���G���libtaskmanager.so.1.0.0��c�®�3+0 
records in
3+0 records out
1536 bytes (1.5 kB) copied, 6.1403e-05 s, 25.0 MB/s

>Another way is to use the "make_bad_sector" utility that
>is included in the source tarball for hdparm-7.7, as follows:
>
>   make_bad_sector --readback /dev/sda 474507
>
Apparently not in the rpm, darnit.

>(when invoked as above, it does *not* "make" a bad sector; no worries).
>
>If it reports an I/O error consistently on that, then the sector is
>indeed faulty, and it's contents have long been lost.
>
>You can repair the bad sector (but not the original contents) like this:
>
>   make_bad_sector --rewrite /dev/sda 474507
>
>Cheers

I'm going up to Clarksburg this afternoon to see if I can find a couple of 
drives, one a 2.5" bigger than 40Gb for my 2.5" maxtor usb housing, and 
another pata drive big enough to run this thing & just re-install the 
December respin after I save as much of this as I can, there's nearly 50GB 
here now.

Maybe it won't be so fscking picky about the next drive.

I was hoping someone could look at that last dmseg I attached, but apparently 
everybody is blinded by unrelated details as that bad sector may have been 
transient, caused by the multiple hardware reset type reboots so far today :(

The last 3 reboots have interrupted a 'smartctl -t long /dev/sda' in 
progress. :(

If I reconvert to non libata, can I do that only for the pata drives of which 
there are 3 here including the dvd writer, and still use libata for the lone 
sata drive left?

And can I do that without mucking with the device map, which will make 
amanda/tar attempt to do a level 0 on the whole system if its changed.  I see 
the drives are at 254 again, when are they going to be given a stable device 
address out of the LANANA experimental group so we can reboot without mucking 
with that and driving tar crazy?

Thanks everybody.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I just had my entire INTESTINAL TRACT coated with TEFLON!
