Return-Path: <linux-kernel-owner+w=401wt.eu-S1751282AbXLAGcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbXLAGcC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 01:32:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbXLAGbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 01:31:47 -0500
Received: from loadbalancer1.orcon.net.nz ([219.88.242.3]:43398 "EHLO
	mx5.orcon.net.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbXLAGbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 01:31:45 -0500
X-Greylist: delayed 28895 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Dec 2007 01:31:44 EST
Message-ID: <47508EE9.9030304@orcon.net.nz>
Date: Sat, 01 Dec 2007 11:30:01 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Bob Tracy <rct@gherkin.frus.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
References: <20071126134819.8FE56DBA2@gherkin.frus.com>
In-Reply-To: <20071126134819.8FE56DBA2@gherkin.frus.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx5.orcon.net.nz on Sat, 01 Dec 2007 11:30:04 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat Dec  1 11:30:06 2007
X-DSPAM-Confidence: 0.7621
X-DSPAM-Improbability: 1 in 321 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Tracy wrote:
> Andrew Morton wrote:
>> Could be something change in sysfs.  Please double-check the config
>> options, make sure that something important didn't get disabled.
>>
>  Here's
> hoping someone else is seeing this or can replicate it in the meantime.

Snap.

2.6.24-rc2 works fine.   2.6.24-rc3 boots on Alpha but once /dev is 
populated no partitions of the scsi sub-system are seen.  Looks like ide 
sub-system similarly affected.

Managed to get boot log.  Follows below (with output of various /proc info).

Cheerz
Michael.


Linux version 2.6.24-rc3 (mjc@alpha) (gcc version 4.1.3 20071019 
(prerelease) (Debian 4.1.2-17)) #1 Mon Nov 26 19:28:58 NZDT 2007
Booting on Tsunami variation Monet using machine vector Monet from SRM
Major Options: EV67 LEGACY_START VERBOSE_MCHECK
Command line: ro root=/dev/sda3 console=ttyS0
memcluster 0, usage 1, start        0, end      215
memcluster 1, usage 0, start      215, end   131062
memcluster 2, usage 1, start   131062, end   131072
freeing pages 215:384
freeing pages 930:131062
reserving pages 930:932
4096K Bcache detected; load hit latency 21 cycles, load miss latency 127 
cycles
Console graphics on hose 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130167
Kernel command line: ro root=/dev/sda3 console=ttyS0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Using epoch = 2000
Turning on RTC interrupts.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 6, 524288 bytes)
Memory: 1030896k/1048496k available (2786k kernel code, 15216k reserved, 
370k data, 168k init)
Mount-cache hash table entries: 512
net_namespace: 120 bytes
NET: Registered protocol family 16
PCI: Bridge: 0001:01:08.0
   IO window: 8000-8fff
   MEM window: 09000000-090fffff
   PREFETCH window: disabled.
SMC37c669 Super I/O Controller found @ 0x3f0
Linux Plug and Play Support v0.97 (c) Adam Belay
SCSI subsystem initialized
NET: Registered protocol family 2
IP route cache hash table entries: 8192 (order: 3, 65536 bytes)
TCP established hash table entries: 32768 (order: 6, 524288 bytes)
TCP bind hash table entries: 32768 (order: 5, 262144 bytes)
TCP: Hash tables configured (established 32768 bind 32768)
TCP reno registered
srm_env: version 0.0.6 loaded successfully
io scheduler noop registered
io scheduler cfq registered (default)
tridentfb: Trident framebuffer 0.7.8-NEWAPI initializing
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
rtc: SRM (post-2000) epoch (2000) detected
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 2.88M
FDC 0 is a post-1991 82077
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
CY82C693: IDE controller (0x1080:0xc693 rev 0x00) at  PCI slot 0000:00:07.1
CY82C693: not 100% native mode: will probe irqs later
CY82C693U driver v0.34 99-13-12 Andreas S. Krebs (akrebs@altavista.net)
     ide0: BM-DMA at 0x8400-0x8407, BIOS settings: hda:pio, hdb:pio
CY82C693: port 0x01f0 already claimed by ide0
ALI15X3: IDE controller (0x10b9:0x5228 rev 0xc6) at  PCI slot 0001:02:09.1
ALI15X3: 100% native mode on irq 28
     ide1: BM-DMA at 0x200008410-0x200008417, BIOS settings: hdc:DMA, 
hdd:DMA
     ide2: BM-DMA at 0x200008418-0x20000841f, BIOS settings: hde:pio, 
hdf:pio
hdf: LITE-ON DVDRW SOHW-1653S, ATAPI CD/DVD-ROM drive
hde: ST3200822A, ATA DISK drive
ide2 at 0x200008438-0x20000843f,0x20000844e on irq 28
hde: max request size: 512KiB
hde: 390721968 sectors (200049 MB) w/8192KiB Cache, CHS=24321/255/63, 
UDMA(100)
hde: cache flushes supported
  hde: hde1
qla1280: QLA1040 found on PCI bus 1, dev 6
scsi(0:0): Resetting SCSI BUS
scsi0 : QLogic QLA1040 PCI to SCSI Host Adapter
        Firmware version:  7.65.06, Driver version 3.26
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
scsi 0:0:1:0: Direct-Access     SEAGATE  ST336706LW       0109 PQ: 0 ANSI: 3
scsi(0:0:1:0): Sync: period 10, offset 12, Wide
input: AT Raw Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
atkbd.c: keyboard reset failed on isa0060/serio1
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
scsi: waiting for bus probes to complete ...
sd 0:0:1:0: [sda] 71687370 512-byte hardware sectors (36704 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
sd 0:0:1:0: [sda] 71687370 512-byte hardware sectors (36704 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
  sda: sda1 sda2 sda3 sda4 sda5
sd 0:0:1:0: [sda] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 168k freed
Mount failed for selinuxfs on /selinux:  No such file or directory
  INIT: version 2.86 booting
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...scsi_id[321]: scsi_id: unable 
to access '/block'
end_request: I/O error, dev fd0, sector 0
scsi_id[371]: scsi_id: unable to access '/block'
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
Linux Tulip driver version 1.1.15 (Feb 27, 2007)
tulip0:  EEPROM default media type Autosense.
tulip0:  Index #0 - Media 10baseT (#0) described by a 21142 Serial PHY 
(2) block.
tulip0:  Index #1 - Media 10base2 (#1) described by a 21142 Serial PHY 
(2) block.
tulip0:  Index #2 - Media AUI (#2) described by a 21142 Serial PHY (2) 
block.
tulip0:  Index #3 - Media 10baseT-FDX (#4) described by a 21142 Serial 
PHY (2) block.
tulip0:  Index #4 - Media 100baseTx (#3) described by a 21143 SYM PHY 
(4) block.
tulip0:  Index #5 - Media 100baseTx-FDX (#5) described by a 21143 SYM 
PHY (4) block.
eth0: Digital DS21142/43 Tulip rev 65 at Port 0x200009400, 
08:00:2b:87:4c:b0, IRQ 45.
Linux video capture interface: v2.00
scsi_id[402]: scsi_id: unable to access '/block'
input: PC Speaker as /devices/platform/pcspkr/input/input1
scsi_id[422]: scsi_id: unable to access '/block'
sata_uli 0001:02:09.0: version 1.3
scsi1 : sata_uli
scsi2 : sata_uli
ata1: SATA max UDMA/133 cmd 0x200008420 ctl 0x200008440 bmdma 
0x200008400 irq 28
ata2: SATA max UDMA/133 cmd 0x200008428 ctl 0x200008444 bmdma 
0x200008408 irq 28
usbcore: registered new device driver usb
hdf: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(66)
Uniform CD-ROM driver Revision: 3.20
scsi_id[469]: scsi_id: unable to access '/block'
ata1: SATA link down (SStatus 0 SControl 300)
ohci_hcd 0000:00:07.3: OHCI Host Controller
ohci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:07.3: irq 10, io mem 0x09050000
scsi_id[490]: scsi_id: unable toivtv:  Start initialization, version 1.1.0
  access '/block'
scsi_id[510]: scsi_id: unable to access '/block'
scsi_id[532]: scsi_id: unable to access '/block'
scsi_id[552]: scsi_id: unable to access '/block'
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
scsi_id[600]: scsi_id: unable to access '/block'
ivtv0: Initializing card #0
ivtv0: Autodetected Hauppauge card (cx23415 based)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
tveeprom 0-0050: Hauppauge model 48139, rev K257, serial# 2962352
tveeprom 0-0050: tuner model is Philips FM1216 ME MK3 (idx 57, type 38)
tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) 
(eeprom 0x74)
tveeprom 0-0050: audio processor is MSP4418 (idx 25)
tveeprom 0-0050: decoder processor is SAA7115 (idx 19)
tveeprom 0-0050: has radio, has IR receiver, has no IR transmitter
ivtv0: Autodetected Hauppauge WinTV PVR-350
ata2.00: configured for UDMA/133
usb 1-1: new full speed USB device using ohci_hcd and address 2
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 2:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sdb:<6>usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
  sdb1 sdb2 sdb3 sdb4
tuner 0-0043: chip found @ 0x86 (ivtv i2c driver #0)
tda9887 0-0043: tda988[5/6/7] found @ 0x43 (tuner)
tuner 0-0043: type set to tda9887
hub 1-1:1.0: 4 ports detected
sd 2:0:0:0: [sdb] Attached SCSI disk
scsi_id[686]: scusb 1-1.3: new low speed USB device using ohci_hcd and 
address 3
si_id: unable to access '/block'
scsi_id[707]: scusb 1-1.3: configuration #1 chosen from 1 choice
si_id: unable to access '/block'
tuner 0-0061: chip found @ 0xc2 (ivtv i2c driver #0)
scsi_id[727]: scsi_id: unable to access '/block'
scsi_id[739]: scsi_id: unable tousb 1-1.4: new full speed USB device 
using ohci_hcd and address 4
  access '/block'
scsi_id[752]: scsi_id: unable tosaa7115 0-0021: saa7115 found 
(1f7115d0e100000) @ 0x42 (ivtv i2c driver #0)
  access '/block'
saa7127 0-0044: saa7129 found @ 0x88 (ivtv i2c driver #0)
msp3400 0-0040: MSP4418G-B3 found @ 0x80 (ivtv i2c driver #0)
msp3400 0-0040: MSP4418G-B3 supports nicam and radio, mode is autodetect 
and autoselect
usb 1-1.4: configuration #1 chosen from 1 choice
input: HID 04d9:0499 as 
/devices/pci0000:00/0000:00:07.3/usb1/1-1/1-1.3/1-1.3:1.0/input/input2
input: USB HID v1.10 Mouse [HID 04d9:0499] on usb-0000:00:07.3-1.3
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
usblp0: USB Bidirectional printer dev 4 if 1 alt 0 proto 2 vid 0x03F0 
pid 0x3B11
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
tuner-simple 0-0061: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
tuner 0-0061: type set to Philips PAL/SECAM m
ivtv0: Registered device video0 for encoder MPG (4096 kB)
ivtv0: Registered device video32 for encoder YUV (2048 kB)
ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
ivtv0: Registered device video24 for encoder PCM (320 kB)
ivtv0: Registered device radio0 for encoder radio
ivtv0: Registered device video16 for decoder MPG (1024 kB)
ivtv0: Registered device vbi8 for decoder VBI (64 kB)
ivtv0: Registered device vbi16 for decoder VOUT
ivtv0: Registered device video48 for decoder YUV (1024 kB)
ivtv0: Initialized card #0: Hauppauge WinTV PVR-350
ivtv:  End initialization
scsi3 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
done.
Setting parameters of disc: (none).
Setting the system clock.
System Clock set to: Fri Nov 30 22:01:02 UTC 2007.
Activating swap:swapon: cannot canonicalize /dev/sdb2: No such file or 
directory
swapon on /dev/sdb2
swapon: cannot stat /dev/sdb2: No such file or directory
  [31mfailed![39;49m
Will now check root file system:fsck 1.40.2 (12-Jul-2007)
[/sbin/fsck.ext3 (1) -- /lib/init/rw/rootdev] fsck.ext3 -a -C0 
/lib/init/rw/rootdev
/lib/init/rw/rootdev: clean, 192EXT3 FS on sda3, 086/1251712 
fileinternal journal
s, 1377761/2500000 blocks
..
Setting the system clock.
System Clock set to: Fri Nov 30 22:01:03 UTC 2007.
Cleaning up ifupdown....
Loading device-mapper support.
Loading device-mapper support.
Will now check all file systems.
fsck 1.40.2 (12-Jul-2007)
Checking all file systems.
[/sbin/fsck.ext2 (1) -- /boot] fsck.ext2 -a -C0 /dev/sda2
[/sbin/fsck.ext3 (2) -- /video] fsck.ext3 -a /dev/sdb4
fsck.ext3: No such file or directory while trying to open /dev/sdb4
/dev/sdb4:
The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
     e2fsck -b 8193 <device>

fsck.ext2: No such file or directory while trying to open /dev/sda2
/dev/sda2:
The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
     e2fsck -b 8193 <device>

[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -a -C0 /dev/sda5
fsck.ext3: No such file or directory while trying to open /dev/sda5
/dev/sda5:
The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
     e2fsck -b 8193 <device>

[/sbin/fsck.ext3 (1) -- /data2] fsck.ext3 -a -C0 /dev/hde1
fsck.ext3: No such file or directory while trying to open /dev/hde1
/dev/hde1:
The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
     e2fsck -b 8193 <device>

fsck died with exit status 8
[31m*[39;49m File system check failed.
A log is being saved in /var/log/fsck/checkfs if that location is writable.
Please repair the file system manually.
[33mscsi 3:0:0:0: Direct-Access     HP                        1.00 PQ: 
0 ANSI: 2
*[39;49m A maintenance shell will now be startesd 3:0:0:0: [sdc] 
Attached SCSI removable disk
d.
CONTROL-D will terminate this shell and resume system boot.
Give root password for maintenance
(or type Control-D to continue): scsi_id[1121]: scsi_id: unable to 
access '/block'

alpha:~# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda3              9842848   5353892   3988956  58% /
tmpfs                   515864         0    515864   0% /lib/init/rw
udev                     10240        48     10192   1% /dev
tmpfs                   515864         0    515864   0% /dev/shm
alpha:~# cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / ext3 rw,errors=remount-ro,data=ordered 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid 0 0
proc /proc proc rw,nosuid,nodev,noexec 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec 0 0
/dev/root /dev/.static/dev ext3 rw,errors=remount-ro,data=ordered 0 0
tmpfs /dev tmpfs rw 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts rw,nosuid,noexec 0 0
alpha:~# ls -l /dev/s*
crw-rw---- 1 root audio 14, 1 Dec  1 11:00 /dev/sequencer
crw-rw---- 1 root audio 14, 8 Dec  1 11:00 /dev/sequencer2
lrwxrwxrwx 1 root root     24 Dec  1 11:00 /dev/sndstat -> 
/proc/asound/oss/sndstat
lrwxrwxrwx 1 root root     15 Dec  1 11:00 /dev/stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root     15 Dec  1 11:00 /dev/stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root     15 Dec  1 11:00 /dev/stdout -> /proc/self/fd/1

/dev/shm:
total 0

/dev/snd:
total 0
crw-rw---- 1 root audio 116,  0 Dec  1 11:00 controlC0
crw-rw---- 1 root audio 116, 32 Dec  1 11:01 controlC1
crw-rw---- 1 root audio 116, 36 Dec  1 11:01 hwC1D0
crw-rw---- 1 root audio 116,  8 Dec  1 11:00 midiC0D0
crw-rw---- 1 root audio 116, 40 Dec  1 11:01 midiC1D0
crw-rw---- 1 root audio 116, 24 Dec  1 11:00 pcmC0D0c
crw-rw---- 1 root audio 116, 16 Dec  1 11:00 pcmC0D0p
crw-rw---- 1 root audio 116, 56 Dec  1 11:01 pcmC1D0c
crw-rw---- 1 root audio 116, 48 Dec  1 11:01 pcmC1D0p
crw-rw---- 1 root audio 116, 49 Dec  1 11:01 pcmC1D1p
crw-rw---- 1 root audio 116, 58 Dec  1 11:01 pcmC1D2c
crw-rw---- 1 root audio 116, 50 Dec  1 11:01 pcmC1D2p
crw-rw---- 1 root audio 116,  1 Dec  1 11:00 seq
crw-rw---- 1 root audio 116, 33 Dec  1 11:00 timer
alpha:~# cat /proc/cpuinfo
cpu			: Alpha
cpu model		: EV67
cpu variation		: 7
cpu revision		: 0
cpu serial number	:
system type		: Tsunami
system variation	: Monet
system revision		: 0
system serial number	: AY0
cycle frequency [Hz]	: 666666666
timer frequency [Hz]	: 1024.00
page size [bytes]	: 8192
phys. address bits	: 44
max. addr. space #	: 255
BogoMIPS		: 1326.92
kernel unaligned acc	: 0 (pc=0,va=0)
user unaligned acc	: 0 (pc=0,va=0)
platform string		: COMPAQ Professional Workstation XP1000
cpus detected		: 1
L1 Icache		: 64K, 2-way, 64b line
L1 Dcache		: 64K, 2-way, 64b line
L2 cache		: 4096K, 1-way, 64b line
L3 cache		: n/a
alpha:~# cat /proc/modules
usb_storage 48849 0 - Live 0xfffffffc003f2000
usblp 15598 0 - Live 0xfffffffc003d2000
msp3400 35516 0 - Live 0xfffffffc00372000
saa7127 13680 0 - Live 0xfffffffc003c2000
saa7115 18260 0 - Live 0xfffffffc003ba000
usbhid 24300 0 - Live 0xfffffffc00380000
snd_cmipci 42696 0 - Live 0xfffffffc003ac000
snd_es18xx 43100 0 - Live 0xfffffffc0039e000
tuner 46548 0 - Live 0xfffffffc0038c000
tea5767 7044 1 tuner, Live 0xfffffffc00358000
snd_pcm_oss 31181 0 - Live 0xfffffffc0034e000
tda8290 13588 1 tuner, Live 0xfffffffc00338000
tuner_simple 9592 1 tuner, Live 0xfffffffc00340000
snd_mixer_oss 20609 1 snd_pcm_oss, Live 0xfffffffc00346000
mt20xx 14104 1 tuner, Live 0xfffffffc00290000
tea5761 5892 1 tuner, Live 0xfffffffc002f4000
snd_pcm 78993 3 snd_cmipci,snd_es18xx,snd_pcm_oss, Live 0xfffffffc0035c000
snd_page_alloc 10984 1 snd_pcm, Live 0xfffffffc002de000
snd_opl3_lib 12041 2 snd_cmipci,snd_es18xx, Live 0xfffffffc002d8000
snd_hwdep 9904 1 snd_opl3_lib, Live 0xfffffffc002d2000
snd_mpu401_uart 9784 2 snd_cmipci,snd_es18xx, Live 0xfffffffc002cc000
snd_seq_dummy 3852 0 - Live 0xfffffffc002b4000
snd_seq_oss 42876 0 - Live 0xfffffffc002e6000
snd_seq_midi 9192 0 - Live 0xfffffffc002ae000
snd_seq_midi_event 8256 2 snd_seq_oss,snd_seq_midi, Live 0xfffffffc002a8000
snd_seq 68264 6 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 
0xfffffffc00324000
snd_timer 24984 3 snd_pcm,snd_opl3_lib,snd_seq, Live 0xfffffffc002c2000
snd_rawmidi 26433 2 snd_mpu401_uart,snd_seq_midi, Live 0xfffffffc002b8000
snd_seq_device 9080 6 
snd_opl3_lib,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq,snd_rawmidi, 
Live 0xfffffffc00298000
ivtv 166124 0 - Live 0xfffffffc002f8000
ohci_hcd 25196 0 - Live 0xfffffffc0029e000
firmware_class 10420 1 ivtv, Live 0xfffffffc0026e000
i2c_algo_bit 8196 1 ivtv, Live 0xfffffffc00248000
snd 64992 13 
snd_cmipci,snd_es18xx,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_opl3_lib,snd_hwdep,snd_mpu401_uart,snd_seq_oss,snd_seq,snd_timer,snd_rawmidi,snd_seq_device, 
Live 0xfffffffc0025c000
ide_cd 46456 0 - Live 0xfffffffc00282000
soundcore 7744 1 snd, Live 0xfffffffc0024e000
cdrom 42408 1 ide_cd, Live 0xfffffffc00274000
cx2341x 14156 1 ivtv, Live 0xfffffffc001f6000
tveeprom 18336 1 ivtv, Live 0xfffffffc00254000
sata_uli 6740 0 - Live 0xfffffffc00240000
i2c_core 25850 12 
msp3400,saa7127,saa7115,tuner,tea5767,tda8290,tuner_simple,mt20xx,tea5761,ivtv,i2c_algo_bit,tveeprom, 
Live 0xfffffffc00208000
pcspkr 3584 0 - Live 0xfffffffc00200000
serio_raw 7556 0 - Live 0xfffffffc001fc000
evdev 12617 0 - Live 0xfffffffc001de000
videodev 31449 1 ivtv, Live 0xfffffffc001ca000
v4l2_common 19560 7 msp3400,saa7127,saa7115,tuner,ivtv,cx2341x,videodev, 
Live 0xfffffffc001d6000
v4l1_compat 14948 2 ivtv,videodev, Live 0xfffffffc001c0000
tulip 57160 0 - Live 0xfffffffc001e6000
pata_cypress 6040 0 - Live 0xfffffffc001c6000
usbcore 158580 5 usb_storage,usblp,usbhid,ohci_hcd, Live 0xfffffffc00212000
alpha:~# cat /proc/ioports
00000000-01ffffff : PCI IO bus 0
   00000000-0000001f : dma1
   00000020-0000003f : pic1
   00000040-0000005f : timer
   00000060-0000006f : keyboard
   00000070-00000080 : rtc
     00000070-00000077 : rtc
   000000a0-000000bf : pic2
   000000c0-000000df : dma2
   00000220-0000022f : ES18xx
   000002f8-000002ff : serial
   00000330-00000331 : MPU401 UART
   000003f2-000003f5 : floppy
   000003f7-000003f7 : floppy DIR
   000003f8-000003ff : serial
   00008000-000080ff : 0000:00:0b.0
   00008400-0000840f : 0000:00:07.1
     00008400-00008407 : ide0
200000000-201ffffff : PCI IO bus 1
   200008000-200008fff : PCI Bus #02
     200008000-2000080ff : 0001:02:0a.0
       200008000-2000080ff : CMI8738-MC6
     200008400-20000840f : 0001:02:09.0
       200008400-20000840f : libata
     200008410-20000841f : 0001:02:09.1
       200008410-200008417 : ide1
       200008418-20000841f : ide2
     200008420-200008427 : 0001:02:09.0
       200008420-200008427 : libata
     200008428-20000842f : 0001:02:09.0
       200008428-20000842f : libata
     200008430-200008437 : 0001:02:09.1
     200008438-20000843f : 0001:02:09.1
       200008438-20000843f : ide2
     200008440-200008443 : 0001:02:09.0
       200008440-200008443 : libata
     200008444-200008447 : 0001:02:09.0
       200008444-200008447 : libata
     200008448-20000844b : 0001:02:09.1
     20000844c-20000844f : 0001:02:09.1
       20000844e-20000844e : ide2
   200009000-2000090ff : 0001:01:06.0
   200009400-20000947f : 0001:01:03.0
     200009400-20000947f : tulip
alpha:~# cat /proc/iomem
00000000-3fffffff : PCI mem bus 0
   09000000-0901ffff : 0000:00:0b.0
   09020000-0902ffff : 0000:00:07.2
   09030000-0903ffff : 0000:00:0b.0
   09040000-0904ffff : 0000:00:0b.1
   09050000-09050fff : 0000:00:07.3
     09050000-09050fff : ohci_hcd
   0c000000-0fffffff : 0000:00:0c.0
     0c000000-0c7fffff : ivtv encoder
     0d000000-0d7fffff : ivtv decoder
     0e000000-0e00ffff : ivtv registers
   10000000-17ffffff : 0000:00:0b.0
   18000000-1fffffff : 0000:00:0b.1
200000000-23fffffff : PCI mem bus 1
   209000000-2090fffff : PCI Bus #02
     209000000-20900ffff : 0001:02:09.0
   209100000-20913ffff : 0001:01:03.0
   209140000-20914ffff : 0001:01:06.0
   209150000-209150fff : 0001:01:06.0
   209151000-2091513ff : 0001:01:03.0
     209151000-2091513ff : tulip
alpha:~# lspci -vvv
0000:00:07.0 ISA bridge: Contaq Microsystems 82c693
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

0000:00:07.1 IDE interface: Contaq Microsystems 82c693 (prog-if 80 [Master])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 14
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) 
[disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) 
[disabled] [size=1]
	Region 4: I/O ports at 8400 [size=16]

0000:00:07.2 IDE interface: Contaq Microsystems 82c693 (prog-if 00 [])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 15
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) 
[disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) 
[disabled] [size=1]
	Region 4: Memory at 09020000 (32-bit, non-prefetchable) [disabled] 
[size=64K]

0000:00:07.3 USB Controller: Contaq Microsystems 82c693 (prog-if 10 [OHCI])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 248, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at 09050000 (32-bit, non-prefetchable) [size=4K]

0000:00:0b.0 VGA compatible controller: ATI Technologies Inc RV280 
[Radeon 9200 PRO] (rev 01) (prog-if 00 [VGA])
	Subsystem: ATI Technologies Inc RV280 [Radeon 9200 PRO]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 255 (2000ns min), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 40
	Region 0: Memory at 10000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at 8000 [size=256]
	Region 2: Memory at 09030000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at 09000000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:0b.1 Display controller: ATI Technologies Inc RV280 [Radeon 9200 
PRO] (Secondary) (rev 01)
	Subsystem: ATI Technologies Inc Unknown device 5961
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 255 (2000ns min), Cache Line Size: 64 bytes
	Region 0: Memory at 18000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at 09040000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:0c.0 Multimedia video controller: Internext Compression Inc 
iTVC15 MPEG-2 Encoder (rev 01)
	Subsystem: Hauppauge computer works Inc. WinTV PVR-350
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 252 (32000ns min, 2000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 36
	Region 0: Memory at 0c000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0001:01:03.0 Ethernet controller: Digital Equipment Corporation DECchip 
21142/43 (rev 41)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 255 (5000ns min, 10000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 45
	Region 0: I/O ports at 200009400 [size=128]
	Region 1: Memory at 209151000 (32-bit, non-prefetchable) [size=1K]
	Expansion ROM at 209100000 [disabled] [size=256K]

0001:01:06.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide 
SCSI (rev 06)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 248, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 47
	Region 0: I/O ports at 200009000 [size=256]
	Region 1: Memory at 209150000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at 209140000 [disabled] [size=64K]
	Capabilities: [44] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0001:01:08.0 PCI bridge: Digital Equipment Corporation DECchip 21152 
(rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 255, Cache Line Size: 64 bytes
	Bus: primary=01, secondary=02, subordinate=02, sec-latency=255
	I/O behind bridge: 00008000-00008fff
	Memory behind bridge: 09000000-090fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=220mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+

0001:02:09.0 Mass storage controller: ALi Corporation ALi M5281 Serial 
ATA / RAID Host Controller (rev a1) (prog-if 85)
	Subsystem: ALi Corporation Unknown device 5283
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 255, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 28
	Region 0: I/O ports at 200008420 [size=8]
	Region 1: I/O ports at 200008440 [size=4]
	Region 2: I/O ports at 200008428 [size=8]
	Region 3: I/O ports at 200008444 [size=4]
	Region 4: I/O ports at 200008400 [size=16]
	Expansion ROM at 209000000 [disabled] [size=64K]

0001:02:09.1 Mass storage controller: ALi Corporation M5228 ALi ATA/RAID 
Controller (rev c6) (prog-if 85)
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 255
	Interrupt: pin A routed to IRQ 28
	Region 0: I/O ports at 200008430 [size=8]
	Region 1: I/O ports at 200008448 [size=4]
	Region 2: I/O ports at 200008438 [size=8]
	Region 3: I/O ports at 20000844c [size=4]
	Region 4: I/O ports at 200008410 [size=16]

0001:02:0a.0 Multimedia audio controller: C-Media Electronics Inc CM8738 
(rev 10)
	Subsystem: C-Media Electronics Inc CMI8738/C3DX PCI Audio Device
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 255 (500ns min, 6000ns max)
	Interrupt: pin A routed to IRQ 24
	Region 0: I/O ports at 200008000 [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

alpha:~# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 01 Lun: 00
   Vendor: SEAGATE  Model: ST336706LW       Rev: 0109
   Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi2 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: ST3320620AS      Rev: 3.AA
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: HP       Model:                  Rev: 1.00
   Type:   Direct-Access                    ANSI  SCSI revision: 02
