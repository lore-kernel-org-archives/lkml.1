Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYH3WNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYH3WNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 18:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYH3WMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 18:12:55 -0400
Received: from lucidpixels.com ([75.144.35.66]:43772 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbYH3WMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 18:12:54 -0400
Date: Sat, 30 Aug 2008 18:12:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jonas Petersson <jonas.petersson@xms.se>
cc: smartmontools-support@lists.sourceforge.net, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [smartmontools-support] exception Emask 0x0 SAct 0x0 SErr 0x0
 action 0x2 frozen
In-Reply-To: <48B9C261.4010609@xms.se>
Message-ID: <alpine.DEB.1.10.0808301804290.11166@p34.internal.lan>
References: <48B91198.3020803@xms.se> <alpine.DEB.1.10.0808300708330.19513@p34.internal.lan> <48B9AE15.7010605@xms.se> <alpine.DEB.1.10.0808301710380.11166@p34.internal.lan> <48B9C261.4010609@xms.se>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Aug 2008, Jonas Petersson wrote:

> Justin Piszcz skrev:
>> On Sat, 30 Aug 2008, Jonas Petersson wrote:
>>> [...]
>> smartctl -a would be useful (#1)
>
> # smartctl -a /dev/sda
> smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/

I have the same controller in my host as well, but it does not appear to
matter whether it happens on the ICH8 controller or other controllers.

I have noticed on Velociraptors I seem to get the same/similar error that
you do as well, and I ran all the same tests as you, to no avail as to getting
any closer to finding the root cause/problem.
(.. more so than the regular old raptor150s)

Besides the annoying messages in the kernel log/syslog/dmesg, does it
affect your system stability in any way as of yet?

I must add a very important note here though, you are using an ICH8 chipset
and so am I, we both have same/similar problems-- however, I also have
another machine setup VERY similarly (except different HDDs) for the RAID5
but the RAID1 is the same as one of my ICH8 boxes (dual raptor150s)--
and to date it has never? or rarely thrown the frozen error except when a disk 
actually failed (or when NCQ is enabled for a WD drive), (NCQ+Linux for WD) is
broken.

I have disks in a raid set (both raid1 and raid5) that get same/similar
warnings as I mentioned above and so far it has not had any impact that I have
noticed in relation to these specific errors.

I think for now we just have to live with them, I am not sure what else
to say here..

CC'ing linux-ide and linux-kernel with your original error from the start
of this e-mail thread:

Here is a snippet from this morning - this time it came back to life:

[46874.898690] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
frozen
[46874.898703] ata3.00: cmd c8/00:08:90:3c:59/00:00:00:00:00/ef tag 0
dma 4096 in
[46874.898705]          res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[46874.898709] ata3.00: status: { DRDY }
[46879.643962] ata3: port is slow to respond, please be patient (Status
0xd0)
[46884.473195] ata3: device not ready (errno=-16), forcing hardreset
[46884.473202] ata3: soft resetting link
[46912.740010] ata3.00: qc timeout (cmd 0xec)
[46912.740020] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[46912.740023] ata3.00: revalidation failed (errno=-5)
[46912.740028] ata3: failed to recover some devices, retrying in 5 secs
[46917.458070] ata3: soft resetting link
[46917.636464] ata3.00: configured for UDMA/100
[46917.636482] ata3: EH complete
[46917.699224] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors
(250059 MB)
[46917.699257] sd 2:0:0:0: [sda] Write Protect is off
[46917.699263] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[46917.699300] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA

Here is an example from my host (same/similar issue):

Aug 23 20:00:32 p34 kernel: [189770.219773] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Aug 23 20:00:32 p34 kernel: [189770.219784] ata1.00: cmd 35/00:40:9a:d9:7a/00:00:12:00:00/e0 tag 0 dma 32768 out
Aug 23 20:00:32 p34 kernel: [189770.219786]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Aug 23 20:00:32 p34 kernel: [189770.219790] ata1.00: status: { DRDY }
Aug 23 20:00:32 p34 kernel: [189770.219795] ata1: hard resetting link
Aug 23 20:00:32 p34 kernel: [189770.524770] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug 23 20:00:32 p34 kernel: [189770.543960] ata1.00: configured for UDMA/133
Aug 23 20:00:32 p34 kernel: [189770.543977] ata1: EH complete
Aug 23 20:00:32 p34 kernel: [189770.544810] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
Aug 23 20:00:32 p34 kernel: [189770.551810] sd 0:0:0:0: [sda] Write Protect is off
Aug 23 20:00:32 p34 kernel: [189770.551810] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 23 20:00:32 p34 kernel: [189770.863810] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

What is the root cause of this? It still seems to be a mystery to most as far
as I can tell, but the one thing in common is we are both using ICH8 chipsets,
which, just may happen to be part of the problem?

Justin.

