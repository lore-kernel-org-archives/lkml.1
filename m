Return-Path: <linux-kernel-owner+w=401wt.eu-S934084AbZHWUQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbZHWUQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 16:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934021AbZHWUQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 16:16:24 -0400
Received: from web23606.mail.ird.yahoo.com ([87.248.115.49]:43256 "HELO
	web23606.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933782AbZHWUQX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 16:16:23 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Aug 2009 16:16:22 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=NuCvhdXJFJW7Y7r/GrlPGcAjL3WuOhVX8nJstafS/SRBPwCF3Bc8ZNrupsl+a57EgdkYYQv+EKa4q792sq226QXMt9kdoDFoA1Akkyn0AGGn0UC1l8/yE8fWwNMwbokAgvX+PRKfuil8+Y8BNy8yPK3zQ+rdOl2YNxeN7siMfdA=;
Message-ID: <692259.70475.qm@web23606.mail.ird.yahoo.com>
X-YMail-OSG: Z6DUvB0VM1n8LI1va0Jlw.Ah66KzQG84dwfqx8TvuM8rIbJ_5_nEYMfIjKzTGt.dhqj42pEYqJvolfbpJuSUWnM2PB5bYFtmXl00qTYvB9VMpoBlaxRp7iRNspfMIrhnjKjqofUqic7_ig2FKBbAxDZ.D3oipITNIH1u1jx7riDip_YLJgNnlvxiqziY5f19cj8bu.UHK8yXzhzE.Prm5aE35LixAVRh6BWIp77wVdaICBg6kx.XZmjNkxI6DDG9cMIr24gLGg5HJ.Pq2N7Dh3Ze5WHJddmOYwD3WbFWWcDA0jRH_uMw3N.DSD4KdLttEFSyf1REqUPl778qj0ddNKXe0o6GaFw-
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.2
Date: Sun, 23 Aug 2009 20:09:44 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: [ANNOUNCE] Gujin GPL bootloader version 2.7
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new version v2.7 of the Gujin bootloader at
http://gujin.sf.net with bugfixes and improvements, and
debian/fedora packages for easy installation on i386/amd64 PC.
The Gujin installer named "gujin" has now his manpage.

Gujin is now able to search files with *.iso extension in the
root and the /boot directory of each partitions, and analyse
the filesystem inside them (not limited to iso9660).
If a set of vmlinuz/initrd is found in root or /boot of the iso
file, then they can be selected and the parameter "bootfrom=" is
automagically added in the linux command line.
There are few limitations, like max 15 ISO files per partitions,
each iso file should have less than 128 fragments (better use ext4fs),
it can be quite slow for very big ISO files on ext2/3fs (so disabled
by default by a tick box), and most live CD images do not put
their kernels with standard names in the /boot directory.
Also, kernels on CD/DVD live distributions do not usually use the
linux menuconfig way to initialise the command line they need, and
Gujin cannot guess it, so (very) few live images can be used right now.
Also, full DVD images cannot be copied to FAT filesystem because of the
maximum file size of FAT.

The full list of change is:
- make targets: install, uninstall, debian (for i386/amd64 .deb),
 fedora (for i386/amd64 .rpm)

- parse *.ISO files found like disks, scanning their filesystems
 for kernels or ELF files (not for El-torito), add "bootfrom="

- autoselect the latest modified kernel if timeout autoboot >= 2s and
 no previous loaded kernel stored (write disabled)

- manual page for "gujin" installer in section 8

- manages FAT bad-block list in FAT when --full on a real device

- create a file with holes when --full on a device image

- installation refuse to overwrite /boot/gujin.ebios if already exists

- installer autodetect second level bootloader / device image depending
 on file size

- check /boot/gujin.ebios is the file referenced by Gujin boot-chain
 in MBR before removing it

- uninstall from an ISO modified image to get back initial ISO image

- fix FAT32 and --full parameter

- fix an ISO9660 aligment problem for directories > 2048 bytes

- fix ext4fs driver when non contiguous files (like *.iso) are used.

- defaults to "--stop_emulation=2" when using the tiny El-Torito gujin
 bootloader (tiny.bcd)

- select the right tinyusb.bin file when only --mbr is given (before you
 had to use --mbr-device=)

- boots MBR on superfloppy with FAT32 (512 bytes/sectors, i.e. BIOS or IDE)

- if IDE disk probed with initial HPA and no B.E.E.R. and HPA after all
 partitions, set it back before running kernel

- fix data comparisson problem when creating a full disk image on 2048
 sector size device

- better default management on --geometry= parameters, only first
 parameter needed.

- fix size autodetection for /dev/mmcblk0 device

- no more opens output device for writing with O_EXCL

- fix FIBMAP parameter size of 64 bits systems

- better message when what is read is not what was written

- accept unwriteable/unreadable sectors in FAT reserved sectors or sectors
 after all clusters

- handle --report / --remove without equal sign

- handle pref_address field in vmlinuz header (untested)

- support older "make" without "else if"

- noexecstack and no-strict-aliasing for the installer

- default compiler now gcc-4.4.1

- docs updates

Downloads at:
https://sourceforge.net/projects/gujin/files

Have fun,
Etienne.




      
