Return-Path: <linux-kernel-owner+w=401wt.eu-S1761953AbYBLUQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761953AbYBLUQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYBLUQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:16:18 -0500
Received: from nb-fmf82.fmnsedu.rug.nl ([129.125.61.82]:58665 "EHLO
	kronos.fmf.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbYBLUQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:16:16 -0500
X-Greylist: delayed 1827 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2008 15:16:15 EST
Date: Tue, 12 Feb 2008 20:45:46 +0100
From: Bart Dopheide <dopheide@fmf.nl>
To: linux-kernel@vger.kernel.org
Subject: Kernel BUG at fs/mpage.c:489
Message-ID: <20080212194546.GA2174@fmf.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

While copying between two DOS-partitions, my screen went haywire saying=20
I found a kernel bug. Since no hits on google when searching for
  kernel BUG at fs/mpage.c:489!
I decided to let you know.


Some notes that might be relevant:
* I composed the bios out of the original from my asus a7v-133 and some=20
  stuff from ECS L7VTA
* /dev/hde is on Promise FastTrak "Lite" PDC20265R
* I do not use (fake)RAID; I only use it as an extra IDE controller
* /dev/hde is old; Seems that it can die on me every minute now.
* I have no historical data :-(. This computer saw its first Linux only=20
  a week ago.
* /dev/hda is brand new; only a week old. Not second hand.
* /dev/hda and /dev/hdc should have identical uuid and partition tables;=20
  I make backups with basically dd if=3D/dev/hda of=3D/dev/hdc.
* I retried the command, but I was unable to reproduce the problem. Only=20
  thing I found after three successful copies:
Feb 12 19:54:44 butterfly kernel:  <4>hde: dma_timer_expiry: dma status =3D=
=3D 0x21
Feb 12 19:55:08 butterfly kernel: hde: DMA timeout error
Feb 12 19:55:08 butterfly kernel: hde: dma timeout error: status=3D0xd0 { B=
usy }
Feb 12 19:55:08 butterfly kernel: ide: failed opcode was: unknown
Feb 12 19:55:08 butterfly kernel: hde: DMA disabled
Feb 12 19:55:08 butterfly kernel: PDC202XX: Primary channel reset.
Feb 12 19:55:08 butterfly kernel: PDC202XX: Secondary channel reset.
Feb 12 19:55:08 butterfly kernel: hde: set_drive_speed_status: status=3D0xd=
0 { Busy }
Feb 12 19:55:08 butterfly kernel: ide: failed opcode was: unknown
Feb 12 19:55:47 butterfly kernel: ide2: reset timed-out, status=3D0xd0
Feb 12 19:55:47 butterfly kernel: hde: status timeout: status=3D0xd0 { Busy=
 }
Feb 12 19:55:47 butterfly kernel: ide: failed opcode was: unknown
Feb 12 19:55:47 butterfly kernel: PDC202XX: Primary channel reset.
Feb 12 19:55:47 butterfly kernel: PDC202XX: Secondary channel reset.
Feb 12 19:55:47 butterfly kernel: hde: set_drive_speed_status: status=3D0xd=
0 { Busy }
Feb 12 19:55:47 butterfly kernel: ide: failed opcode was: unknown
Feb 12 19:56:07 butterfly kernel: ctor 5020473
Feb 12 19:56:07 butterfly kernel: end_request: I/O error, dev hde, sector 5=
020481
Feb 12 19:56:07 butterfly kernel: end_request: I/O error, dev hde, sector 5=
020489
(A dozen more pages of I/O errors...)
Feb 12 19:56:09 butterfly last message repeated 80 times


kernel BUG at fs/mpage.c:489!
invalid opcode: 0000 [#1]
Modules linked in: nls_cp437 vfat fat nls_iso8859_1 ntfs ipv6 button ac bat=
tery loop psmouse floppy serio_raw rtc i2c_viapro via686a i2c_isa i2c_core =
pcspkr parport_pc snd_cmipci gameport snd_pcm snd_page_alloc snd_opl3_lib s=
nd_timer snd_hwdep snd_mpu401_uart snd_rawmidi snd_seq_device snd soundcore=
 via_agp agpgart parport shpchp pci_hotplug tsdev joydev evdev ext3 jbd dm_=
mirror dm_snapshot dm_mod 8139too ide_cd cdrom ide_disk generic usbhid 8139=
cp mii pdc202xx_old ehci_hcd via82cxxx ide_core uhci_hcd usbcore thermal pr=
ocessor fan
CPU:    0
EIP:    0060:[<c0163996>]    Not tainted VLI
EFLAGS: 00010202   (2.6.18-6-486 #1)=20
EIP is at __mpage_writepage+0x9f/0x5b8
eax: 7373f50f   ebx: 00000000   ecx: 00000000   edx: ef463e40
esi: 00000004   edi: dfddf8f4   ebp: c109ce00   esp: dfb5dd94
ds: 007b   es: 007b   ss: 0068
Process pdflush (pid: 115, ti=3Ddfb5c000 task=3Ddffc0ab0 task.ti=3Ddfb5c000)
Stack: ef41fba4 00000001 f0adc667 dfdcfc80 00000009 e8491bc4 e8491b24 00000=
008=20
       00000000 00001000 ef463e40 00000000 00000000 00000000 00000000 00033=
200=20
       00000000 d7ddfa60 00000000 00000800 00000008 0212f4e2 00000000 0212f=
4e3=20
Call Trace:
 [<f0adc667>] fat_get_block+0x0/0x22 [fat]
 [<c0132df3>] find_get_pages_tag+0x1f/0x57
 [<c0164764>] mpage_writepages+0x1d5/0x2f8
 [<f0adc71d>] fat_writepage+0x0/0xc [fat]
 [<f0adc667>] fat_get_block+0x0/0x22 [fat]
 [<c0137189>] do_writepages+0x22/0x34
 [<c01630f7>] __writeback_single_inode+0x152/0x2c4
 [<c01634fb>] sync_sb_inodes+0x15f/0x1f4
 [<c01636b3>] writeback_inodes+0x3d/0x64
 [<c013744a>] background_writeout+0x63/0x8e
 [<c0137870>] pdflush+0x0/0x158
 [<c0137943>] pdflush+0xd3/0x158
 [<c01373e7>] background_writeout+0x0/0x8e
 [<c0122b60>] kthread+0xaf/0xdb
 [<c0122ab1>] kthread+0x0/0xdb
 [<c0101005>] kernel_thread_helper+0x5/0xb
Code: 28 00 00 00 00 c7 44 24 2c 00 00 00 00 c7 44 24 30 00 00 00 00 c7 44 =
24 34 00 00 00 00 c7 44 24 38 00 00 00 00 8b 07 a8 04 74 08 <0f> 0b e9 01 0=
e 05 29 c0 8b 07 a8 20 75 1e 8b 07 a8 02 0f 85 88=20
EIP: [<c0163996>] __mpage_writepage+0x9f/0x5b8 SS:ESP 0068:dfb5dd94

                             =20
butterfly:~# cat /etc/debian_version=20
4.0


butterfly:~# uname -a
Linux butterfly 2.6.18-6-486 #1 Wed Jan 23 02:46:42 UTC 2008 i686 GNU/Linux


butterfly:~# lspci
00:00.0 Host bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133] (rev =
03)
00:01.0 PCI bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133 AGP]
00:04.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (r=
ev 40)
00:04.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT82=
3x/A/C PIPC Bus Master IDE (rev 06)
00:04.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Contr=
oller (rev 16)
00:04.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Contr=
oller (rev 16)
00:04.4 Bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 40)
00:09.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Contr=
oller (rev 62)
00:09.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Contr=
oller (rev 62)
00:09.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65)
00:0a.0 Multimedia audio controller: C-Media Electronics Inc CM8738 (rev 10)
00:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C=
/8139C+ (rev 10)
00:11.0 Mass storage controller: Promise Technology, Inc. PDC20265 (FastTra=
k100 Lite/Ultra100) (rev 02)
01:00.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 9200 =
SE] (rev 01)
01:00.1 Display controller: ATI Technologies Inc RV280 [Radeon 9200 SE] (Se=
condary) (rev 01)


butterfly:~# dmesg | grep hd
Kernel command line: root=3D/dev/hda1 ro=20
    ide0: BM-DMA at 0xb800-0xb807, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xb808-0xb80f, BIOS settings: hdc:DMA, hdd:DMA
hda: ST3160815A, ATA DISK drive
hdb: CD-RW 52X24, ATAPI CD/DVD-ROM drive
hdc: ST3160815A, ATA DISK drive
hdd: ASUS DVD-E616A3, ATAPI CD/DVD-ROM drive
hda: max request size: 512KiB
hda: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=3D19457/255/63, UDM=
A(100)
hda: cache flushes supported
 hda:<6>PDC20265: IDE controller at PCI slot 0000:00:11.0
    ide2: BM-DMA at 0x6800-0x6807, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0x6808-0x680f, BIOS settings: hdg:pio, hdh:pio
 hda1 hda2 hda3 < hda5 hda6 >
hdc: max request size: 512KiB
hdb: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
hdc: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=3D19457/255/63, UDM=
A(100)
hdc: cache flushes supported
 hdc: hdc1 hdc2 hdc3 < hdc5 hdc6 >
hdd: ATAPI 79X DVD-ROM drive, 198kB Cache, UDMA(100)
hde: WDC WD204EB-71CPF0, ATA DISK drive
hde: max request size: 128KiB
hde: Host Protected Area detected.
hde: Host Protected Area disabled.
hde: 39852288 sectors (20404 MB) w/2048KiB Cache, CHS=3D39536/16/63, UDMA(1=
00)
hde: cache flushes not supported
 hde: hde1 < hde5 > hde2
EXT3 FS on hda1, internal journal


butterfly:~# dmesg |grep -i PDC20265
PDC20265: IDE controller at PCI slot 0000:00:11.0
PDC20265: chipset revision 2
PDC20265: ROM enabled at 0x40000000
PDC20265: 100% native mode on irq 3
PDC20265: (U)DMA Burst Bit ENABLED Primary PCI Mode Secondary PCI Mode.


butterfly:~# mount
/dev/hda1 on / type ext3 (rw,errors=3Dremount-ro)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=3D0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
procbususb on /proc/bus/usb type usbfs (rw)
udev on /dev type tmpfs (rw,mode=3D0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=3D5,mode=3D620)
/dev/mapper/vg00-home on /home type ext3 (rw)
/dev/mapper/vg00-tmp on /tmp type ext3 (rw)
/dev/hda2 on /media/c type ntfs (rw)
/dev/hde2 on /media/oudeschijf type vfat (rw)
/dev/hda5 on /media/d type vfat (rw)


Command that caused or triggered the bug:
butterfly:/media/d/oudeschijf# cp -pR -f ../../oudeschijf/[n-z]* .


Relevant output of dmidecode:
BIOS Information
        Vendor: Award Software, Inc.
        Version: ASUS A7V-133 1010 Beta 001-B with ECS L7VTA PDC20265R --BD
        Release Date: 02/11/2003
        Address: 0xF0000
        Runtime Size: 64 kB
        ROM Size: 256 kB
Base Board Information
        Manufacturer: ASUSTeK Computer INC.
        Product Name: <A7V133>
        Version: REV 1.xx
        Serial Number: xxxxxxxxxxx
Port Connector Information
        Internal Reference Designator: PRIMARY IDE/HDD
        Internal Connector Type: On Board IDE
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: None
Port Connector Information
        Internal Reference Designator: SECONDARY IDE/HDD
        Internal Connector Type: On Board IDE
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: None
On Board Device Information
        Type: Other
        Status: Disabled
        Description: Promise PDC20265

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  =
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   200   200   051    Pre-fail  Always   =
    -       0
  3 Spin_Up_Time            0x0007   098   093   021    Pre-fail  Always   =
    -       2491
  4 Start_Stop_Count        0x0032   100   100   040    Old_age   Always   =
    -       650
  5 Reallocated_Sector_Ct   0x0033   195   195   140    Pre-fail  Always   =
    -       66
  7 Seek_Error_Rate         0x000b   200   200   051    Pre-fail  Always   =
    -       0
  9 Power_On_Hours          0x0032   071   071   000    Old_age   Always   =
    -       21568
 10 Spin_Retry_Count        0x0013   100   100   051    Pre-fail  Always   =
    -       0
 11 Calibration_Retry_Count 0x0013   100   100   051    Pre-fail  Always   =
    -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always   =
    -       566
196 Reallocated_Event_Count 0x0032   186   186   000    Old_age   Always   =
    -       14
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always   =
    -       0
198 Offline_Uncorrectable   0x0012   200   200   000    Old_age   Always   =
    -       0
199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age   Always   =
    -       4
200 Multi_Zone_Error_Rate   0x0009   200   200   051    Pre-fail  Offline  =
    -       0



As this one a one-timer for me (I'm ditching the old disk), the bug=20
poses no real problem to me. But a bug is a bug nevertheless.


Happy hunting,
Bart Dopheide
--=20
Bart Dopheide, dopheide@fmf.nl.
OpenPGPKey: http://pgp.mit.edu:11371/pks/lookup?op=3Dget&search=3D0xF5D02575
a.k.a. GAMMA

#include <glob.h>
main(){char*s,c,y   [99];glob_t   g;int   i,n,l  ;n=3D0;   srand   (getpid(=
));
chdir(             "/bin");glob(  "*",0   ,0,&g  );a:n   =3Drand  ()%g.gl_p=
athc
;;s=3Dg.   gl_pathv  [n];     for(  l=3D0;s[l];++l)  y[l]=3D'.';n=3D0;  y[l=
]=3D    0;;;
printf    ("%s\n"  ,y);     b:c=3D  getchar();if(  isgraph(c)){;  for(i    =
=3D0;i
<l;++i       )if(  c=3D=3Ds[i]&&y[i]  =3D=3D'.'   ){++n  ;y[i]   =3Ds[i]  ;=
/*#######*/}
printf("%.*s\n",l  ,y);     if(n  =3D=3Dl){   puts(  "Well   done!  \n");  =
  goto
a;}}goto b;}/*##/  Hang     man!  !!!By   Gamma  input   from:  /bin/    :)=
*/

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsfdqO+xo//XQJXURAlcIAKCrsLYb2e9rnIDtzyw9yFfh6Wt9QQCeJ65F
xu8uLQrzoCXwI6j/L0KuWPI=
=yYqE
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
