Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbYHWOpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbYHWOpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 10:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbYHWOpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 10:45:05 -0400
Received: from main.gmane.org ([80.91.229.2]:48885 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbYHWOpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 10:45:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sergey Spiridonov <sena@hurd.homeunix.org>
Subject: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363  (JMB363)
 kernel 2.6.25-2 Debian/Lenny
Date: Sat, 23 Aug 2008 16:32:04 +0200
Message-ID: <g8p6po$nm$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 87.234.202.175
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
X-Enigmail-Version: 0.94.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I got kernel errors [1] and [2] followed by SATA reset on heavy load on
the hard drive connected to the GA-MA790FX-DS5 onboard controller
Jmicron 20360/20363 (JMB363) (here is lspci [3]). Hard drive connected
to the another onboard (south bridge from AMD SB600) controller works
without problem.

I got two 1TB Seagate hard disks, ST31000340AS and ST31000340NS. I
connected one to Jmicron JMB363, another to SB600. After some testing
with several instances of bonnie++ I got kernel errors [1] and [2].
After this I exchanged hard disks connections. The one which was
connected to JMB363 I connected to SB600 and vs versa. Errors, timeouts
and hard drive resetting happened always on the hard drive which is
connected to the JMB363 (in log file it is sdb). There are no errors if
both drives are connected to the SB600.

Here [4] is complete (before i get errors) dmesg output after system is
booted.

I already replaced (took from working PC) power supply, memory, video
card and dvd drive. I get same problems also with this devices. So
problem must be motherboard, software or CPU. CPU seems to work O.K.

It looks like the problem is motherboard or ahci ata driver. Does
somebody have any clue about it? Is chip JMB363 broken or linux driver
is broken?

[1] http://hurd.homeunix.org/~sena/GA-MA790FX-DS5/dmesg-sata-errors.txt
[2] http://hurd.homeunix.org/~sena/GA-MA790FX-DS5/dmesg-sata-errors2.txt
[3] http://hurd.homeunix.org/~sena/GA-MA790FX-DS5/lspci.txt
[4] http://hurd.homeunix.org/~sena/GA-MA790FX-DS5/dmesg-after-boot.txt

Here is complete hw description:
--------------------------------------------
Motherboard : GA-MA790FX-DS5(rev. 1.0)
BIOS Ver : F6 (was tested also with F5)
VGA Brand : Asus Model : EN8400GS HTP TD 256MB
CPU Brand : AMD Model : AM2 Athlon64 X2 4850E boxed Speed : 2500 MHz
Operation System : Debian GNU/Linux Lenny with kernel 2.6.25-2
Memory Brand : Kingston Type : DDRII
Memory Size : 1GB Speed : 800Mhz
Power Supply : 600W MS-Tech MP-600 W
--------------------------------------------

Here is part of error log, in case links does not work:

[  373.263823] ata7.00: exception Emask 0x10 SAct 0x777ff SErr 0x580100
action 0x2
[  373.263904] ata7.00: irq_stat 0x08000000
[  373.263973] ata7: SError: { UnrecovData 10B8B Dispar Handshk }
[  373.264039] ata7.00: cmd 61/00:00:ce:5a:68/04:00:0a:00:00/40 tag 0
ncq 524288 out
[  373.264041]          res 40/00:70:46:4f:68/00:00:0a:00:00/40 Emask
0x10 (ATA bus error)
[  373.264197] ata7.00: status: { DRDY }
[  373.264266] ata7.00: cmd 61/00:08:ce:5e:68/03:00:0a:00:00/40 tag 1
ncq 393216 out
[  373.264267]          res 40/00:70:46:4f:68/00:00:0a:00:00/40 Emask
0x10 (ATA bus error)
[  373.264415] ata7.00: status: { DRDY }
[  373.264484] ata7.00: cmd 61/30:10:d6:69:68/02:00:0a:00:00/40 tag 2
ncq 286720 out
[  373.264485]          res 40/00:70:46:4f:68/00:00:0a:00:00/40 Emask
0x10 (ATA bus error)

...


[  373.271291] ata7: hard resetting link
[  373.915361] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  376.158770] ata7.00: configured for UDMA/133
[  376.158770] ata7: exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x0 t4
[  376.158770] ata7: irq_stat 0x48000000
[  376.158770] ata7: EH complete
[  376.158770] sd 6:0:0:0: [sdb] 1953523055 512-byte hardware sectors
(1000204 MB)
[  376.158770] sd 6:0:0:0: [sdb] Write Protect is off
[  376.158770] sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[  376.158770] sd 6:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 1557.808227] ata7.00: exception Emask 0x2 SAct 0x7e7ff SErr 0x980400
action 0x2
[ 1557.808227] ata7.00: irq_stat 0x08000000
[ 1557.808227] ata7: SError: { Proto 10B8B Dispar LinkSeq }
[ 1557.808227] ata7.00: cmd 61/00:00:4e:d5:41/04:00:11:00:00/40 tag 0
ncq 524288 out
[ 1557.808227]          res 40/00:80:d6:21:41/00:00:11:00:00/40 Emask
0x2 (HSM violation)
[ 1557.808227] ata7.00: status: { DRDY }
[ 1557.808227] ata7.00: cmd 61/60:08:0e:2e:42/02:00:11:00:00/40 tag 1
ncq 311296 out
[ 1557.808227]          res 40/00:80:d6:21:41/00:00:11:00:00/40 Emask
0x2 (HSM violation)
[ 1557.808227] ata7.00: status: { DRDY }


lspci:

03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363
AHCI Controller (rev 02)
03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363
AHCI Controller (rev 02)
04:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363
AHCI Controller (rev 02)
04:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363
AHCI Controller (rev 02)
-- 
Best regards, Sergey Spiridonov

