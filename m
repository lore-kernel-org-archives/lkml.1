Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbXBSRC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbXBSRC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 12:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932427AbXBSRC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 12:02:56 -0500
Received: from synflood.homelinux.org ([193.80.11.44]:3118 "EHLO
	synflood.homelinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbXBSRCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 12:02:55 -0500
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Feb 2007 12:02:54 EST
Message-ID: <45D9D63D.50303@synflood.homelinux.org>
Date: Mon, 19 Feb 2007 17:54:21 +0100
From: Sigmund Scheinbar <sigmund.debian@synflood.homelinux.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bugreport: SATA Problem: port is slow to respond
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there!

Here my first bugreport on the linux kernel:

[1.] One line summary of the problem:

SATA Problem: port is slow to respond

[2.] Full description of the problem/report:

The following messages appear while booting/in dmesg [1]:

[...]
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: port failed to respond (30 secs, Status 0x80)
ata2: softreset failed (device not ready)
ata2: softreset failed, retrying in 5 secs
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: port failed to respond (30 secs, Status 0x80)
ata2: COMRESET failed (device not ready)
ata2: hardreset failed, retrying in 5 secs
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: port failed to respond (30 secs, Status 0x80)
ata2: COMRESET failed (device not ready)
ata2: reset failed, giving up
scsi2 : ahci
[...]

This of course means extra long booting time :(
[1] http://wieland.homelinux.org/hp_dc5750/dmesg_2.6.19.3.txt

A further issue which -  imho is coupled w/ this one - is that my
cd/dvd+rw (also sata) combo drive simply does not work:
firstly there is no indication in dmesg that it was found and
secondly it behaves like dead: it does not open if i press the
button and it does not blink; it can be opened until
these message appear on the screen. I need to unplug and the replug
it after shutting down/reboot so that on the next bootup the bios
is able to find it (else it would still behave like dead)!
The drive itself is ok i guess (a least it works fine on a differen OS).

I found a debian bug report where the problem (but unfortunately
not a solution that worked for me) is described:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=391867

[3.] Keywords (i.e., modules, networking, kernel):

SATA, ATA

[4.] Kernel version (from /proc/version):

Linux version 2.6.19.3 (root@kvpc31) (gcc version 4.1.2 20061115
(prerelease) (Debian 4.1.1-21)) #2 SMP Thu Feb 15 02:59:14 CET 2007

[8.1.] Software (add the output of the ver_linux script here)

http://wieland.homelinux.org/hp_dc5750/ver_linux.txt

[8.2.] Processor information (from /proc/cpuinfo):

http://wieland.homelinux.org/hp_dc5750/proc_cpuinfo.txt

[8.3.] Module information (from /proc/modules):

http://wieland.homelinux.org/hp_dc5750/proc_modules.txt

[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

http://wieland.homelinux.org/hp_dc5750/proc_iomem.txt
http://wieland.homelinux.org/hp_dc5750/proc_ioports.txt

[8.5.] PCI information ('lspci -vvv' as root)

http://wieland.homelinux.org/hp_dc5750/lspci-vvv.txt

[8.6.] SCSI information (from /proc/scsi/scsi)

http://wieland.homelinux.org/hp_dc5750/proc_scsi_scsi.txt

[X.] Other notes, patches, fixes, workarounds:

Also it seems that the System is not capeable of recongnizing
the HDD:
hdparm -i /dev/sda
HDIO_GET_IDENTITY failed: Inappropriate ioctl for device

A user on an German mailinglist suggest to uses pata_atiixp
instead of atiixp but yet again this does not work for me:
http://lists.opensuse.org/archive/opensuse-mobile-de/
2007-01/msg00001.html

All the information i collected can be found at:
http://wieland.homelinux.org/hp_dc5750/

I've tried several kernel version in the meantime, starting w/
the standard debian testing i386 kernel, then tried different
vanilla versions 2.6.18.6, 2.6.19, 2.6.19.3 which are all
affected in the same way. However 2.6.20 behaves
differently: there is another error message which scrolls over
the screen so fast that I'm not able to read it, the only
thing i was able to catch that it also concerns (s)ata, looking like
'ata2.0: [...] failed [...]'

Please CC I'm *not* subscribed!

Greetings,
Sigmund

