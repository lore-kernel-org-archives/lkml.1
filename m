Return-Path: <linux-kernel-owner+w=401wt.eu-S1765856AbXG2PYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765856AbXG2PYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932956AbXG2PK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:10:59 -0400
Received: from web52009.mail.re2.yahoo.com ([206.190.48.58]:41074 "HELO
	web52009.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932943AbXG2PK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:10:58 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jul 2007 11:10:57 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=vzQyo0Gdwys6GsTKEnGerPBhpEMvi9TAWgRzUXR/S0rW7+YhwT+X8VUpTiTnriqrsmI2THRokLvtnCnFYHTRo2PkEzJhnuX+wYPDx+H7Ql1D26K8/zHfPXD96ybme+wfDzpV+77xGPm7Iby5c+p9RKF9R5IFkiCjfFHl1r5EdYw=;
X-YMail-OSG: guRyncgVM1mzL7h8CUy8WYjck0U_hHgKJBMLZlIgD2Wa6r7Qghscqjl7JGxDPBxEsYibIiOuxixX3QrT6rs3IcbPQD1RVxNMRvQtrmehpiUUrjIGKglHRiH7cks1ZwlVR5Qu31fRZvsChtH.PgpQ4o6WlQ--
Date: Sun, 29 Jul 2007 08:04:17 -0700 (PDT)
From: "Hendrik ." <chasake@yahoo.com>
Subject: Reading a bad sector does not report failure as 'read error' but hangs PC with 'Machine Check Exception'
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <708631.35535.qm@web52009.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Last night I discovered a problem in my RAID5 array
and finally after a lot of tests I narrowed it down to
a bad sector on one of the hard disks and some goofy
kernels.

I just yesterday build a new PC using an existing
array of 5 disks in RAID 5. I did build the array with
only 4 out of 5 disks in the system but the rebuild
processes stopped over and over again apparently at
the same position. At last I found out that the
harddisk at the first SATA port had developed some bad
sectors which made the kernel stop completely when it
tried to read that sector with the following error on
the screen:

HARDWARE ERROR
CPU 0: Machine Check Exception: 4  Bank 4:
b200000000070f0f
TSC b7d4a144d0
This is not a software problem!
Run through mcelog --ascii to decode and contact your
hardware vendor
Kernel panic - not syncing: Machine check

Googling around made me check memory, upgrade the BIOS
and things like that but now i DO think that this IS a
software problem, which is in the linux kernel.

I was running the standard 2.6.20-16 kernel series
from Ubuntu Feisty Fawn (using the generic and server
built) and I built my own 2.6.22.1 but the problem
still persisted. When copying manually with dd_rescue
I was not able to copy past the bad sector or the MCE
error reappeared. Only when using the standard Ubuntu
Edgy Eft kernel (2.6.17-12-server) the problem went
away completely and the syslog was filled with normal
lines like: 

Jul 28 22:58:26 mediaserver kernel: [ 6562.446868]
ata2: error=0x40 { UncorrectableError }
Jul 28 22:58:26 mediaserver kernel: [ 6562.446875] sd
1:0:0:0: SCSI error: return code = 0x8000002
Jul 28 22:58:26 mediaserver kernel: [ 6562.446880]    
Additional sense: Unrecovered read error - auto
reallocate failed
Jul 28 22:58:26 mediaserver kernel: [ 6562.446887]
end_request: I/O error, dev sda, sector 205534870

So in the end I was able to copy my stuff off the bad
harddisk to a new disk (losing some bytes because of
my already dirty RAID5 array) but I do think this is a
kernel bug or at least strange behavior as an old
kernel is willing to continue operation on something
'minor' as a bad sector. In the end when I will start
scrubbing the drive array overnight a simple bad
sector on the array will take down the complete system
instead of just continuing with 1 faulty drive in the
array!

Some information about the hardware:
AMD Athlon 64 3000+
Asus A8N-E Deluxe motherboard
1 GB RAM
4 Seagate 7200.9 drives on the NVIDIA SATA controller
(sda ... sdd)
2 WD drives on the IDE controller (hda, hdc)
Running Feisty Fawn 64 bit Server edition

Faulty drive is /dev/sda and on thus on the first SATA
port. Changing this to a different port on the
motherboard gives the same lockup. There is also a SIL
3114 controller on the motherboard but I have not
tried to dd_rescue with the faulty drive on that
controller to see if it locks up the kernel.

Regards,
Hendrik van den Boogaard




      ____________________________________________________________________________________
Luggage? GPS? Comic books? 
Check out fitting gifts for grads at Yahoo! Search
http://search.yahoo.com/search?fr=oni_on_mail&p=graduation+gifts&cs=bz
