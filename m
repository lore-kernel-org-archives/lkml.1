Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0BUV2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:28:16 -0500
Received: from n12.bullet.mail.tp2.yahoo.com ([203.188.202.125]:37133 "HELO
	n12.bullet.mail.tp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752990Ab0BUV2O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:28:14 -0500
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 16:28:13 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 773517.45328.bm@omp220.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2N/hDePio24fxhHSDYFUolOPghou5AzUhFikSioNjWl8v+u3dctkA5N0UMx11h30QSH21ub91HrL6bQJW4LtFbSva4SHlQ1poUW6cN+4JADWD7/R7/8VxbbCGjHjR7Rt0OvZbuLDdpAU9MPknA7JarvqEOotm9+uIXfJdJ2uk2o=;
Message-ID: <557752.35099.qm@web23604.mail.ird.yahoo.com>
X-YMail-OSG: p7zm6ucVM1mhyCBVBPbCKGa1.clpoZ3.o56plNf2NdymZbMN7IBGCVTfrPO7ZjYWrFdz1u9YIp9_EFkYVQdol9Hj3u8nJ2nEQpPTynFBvSUUqjCvk5a2NI8MmUejadMRt5tiR.xv.ZhtMRuw7GEwI0Hm8Yx1fiYa8c.RRxhMkd6_.GObNJ6UHvszkuHtBo5.ooqe6Lr3VTkRPcyMA60hm4.DB7N9.2IIH2nuGJq14vvVFukn8fmR5d5LWPBzc5socbY4_vkSHy7EtSJqfaHO_vYPmzpUjTQ3Fxc.px91Be1tjx_vumX9acB5wJAsE8R.8Xf2vhY-
X-Mailer: YahooMailClassic/9.2.12 YahooMailWebService/0.8.100.260964
Date: Sun, 21 Feb 2010 21:22:34 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: [announce] gujin GPL bootloader version 2.8
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new version v2.8 of the Gujin bootloader at
http://gujin.org with bugfixes and improvements, and
Debian/Fedora packages for easy installation on i386/amd64 PC.
The Debian package can be installed on Ubuntu and the
Fedora package can be installed on Mandriva, those
packages have very few dependencies.

The main improvements are in the handling of languages,
Linux command line parameters description in /boot/gujin.cmd,
GPT partition tables, and handling of file images like iso images.

First, thanks to benny59 for the rewrite of italian messages;
messages in russian, spanish, portugese, german, and dutch
would probably improve with a human reader. There is a
single bootloader containing all those languages plus
french and english, switch-able by Control-T/Alt-T,
with the needed support of UTF-8 on 8x16 and 10x20 fonts.

The "distributed Linux kernel description" file named gujin.cmd is a file
parsed in every filesystem where it is found, containing lines like:
:filesystemlabel:kernelname:initrdname:timeout:menuname:commandline
for instance:
::vmlinuz-bluehat-2.6*:::bluehat standard boot:quiet noacpi
to boot the bluehat kernel with parameters "quiet noacpi" when
clicking on the menu choice "bluehat standard boot".
More description in the gujin.cmd file in the source package.

For the handling of filesystem images, Gujin can now emulate BIOS
disks on discontiguous files, and recognises file with extension
*.bin and *.img with 0xAA55 signature as "*.bdi" files, so you
can directly run "memtest+.bin" present in /boot of some
distributions or some live CD (for instance KANOTIX-2005-04.iso),
you can also boot "hal91.img", "rescue-0.4.1.img", "tomsrtbt*.img",
and if you have a small DOS bootable USB/floppy, you can copy it
like "cat /dev/sdc > /boot/usb.bin" and boot it, /boot/usb.bin will
be writeable under DOS if Gujin is allowed to write to disks.
You can disable the display of files with bdi/bin/img extension by the
"probe bdi file" checkbox.

There is two kind of Linux based live CD: the ones self contained
in the two files kernel and initial RAM disk (excluding license files and
documentation) - like Fedora and Debian net-install CD or the
tinycore_2.6.iso distribution; and more complete Linux live CD which
need to access other files of the ISO image to properly boot.
There is four ways to start those ISO images without first writing the
ISO image file on a real CD. 

1- The first one is to copy the complete content into a partition of
a hard or USB disk - that was already handled in Gujin-2.7 and often
works because most live CD will search every CDROM, hard disks and
hard disks partitions to find their other files. The Fedora net-install
CD needs to change the directory probed by Gujin from "/boot" to
"/isolinux", that can now be set with Gujin-2.8.

2- The bootloader extract the kernel and initial RAM disk from
the ISO image file (by loop-mounting) and load them in memory,
and then pass a parameter on the Linux command line to tell
where the distribution will find its other files. That supposes
that the initial RAM disk has some init-scripts which handle
such parameter, the three possible parameter names are "fromiso=",
"isoscan=" or "bootfrom=".
Unfortunately, I have only found one single distribution which
correctly handle that parameter, that is:
sidux-2009-03-momos-xfce-i386-200911110039.iso
and it correctly manages "fromiso=", so that is the only thing
Gujin supports. The only details are to rename that file to a shorter
name like "sidux-2009.iso", copy it in the root or /boot directory
of one of your FAT/Ext2/3/4 partition, and in Gujin setup (at boot
time) enable probing files in ISO images and set the Linux command
line to "boot=fll quiet" to acheive a complete boot.
Obviously the "self contained" live CD will also work as long as
Gujin can find the kernel and the initial RAM disk files.
The maximum length of the string "/boot/<filename>.iso" is 64 chars.
That Sidux live CD do not boot with the first method (copy the
complete filesystem in a partition), do not loose your time there.

3- Gujin can also fully manage an El-Torito boot from an ISO image
file, so you will chain-load the EL-Torito boot loader of the real
live CD. It will work for self contained live CD, and probably most
non Linux CD like UBCD (Universal Boot CD), but most complete
Linux live CD distribution wil not find their "other" files.
For this boot to succeed, you will need to replace the El-Torito
boot file of the live CD by the Gujin El-Torito boot file, which can
generate/analyse the signature to rebuild the bootfrom= parameter.
For instance, to complete the boot of Sidux with this method, you
have to modify the iso file by typing these commands, assuming
you have sidux-2009-04-moros-kde-lite-i386-200912310312.iso in the
current directory and are root for the loop-mount (mirrors at
http://sidux.com/module-Content-view-pid-2.html):
$ sudo -s
# mkdir siduxdir
# mount -o loop -t iso9660 sidux-2009-04-moros-kde-lite-i386-200912310312.iso siduxdir
# cp -a siduxdir sidux-2009
# umount siduxdir
# ./install/gujin -t sidux-2009/boot/gujin.bcd --cmdline="boot=fll quiet" \
    --read_retry --default_video_mode=0x117   # real VESA mode number, i.e. not 791
# mv sidux-2009/boot/memtest sidux-2009/boot/memtest.img # not really needed
# genisoimage -r -b boot/gujin.bcd -no-emul-boot -boot-load-size 4 \
    -boot-info-table -o sidux-2009.iso sidux-2009
# ^D
The resulting file "sidux-2009.iso", once copied in the root or /boot
directory, is directly bootable by Gujin installed on the booting device if
"search El-Torito" checkbox is ticked (just click sidux-2009.iso:noemul),
you can also boot sidux-2009.iso:/boot/{vmlinuz,initrd}0.686 if the
command line is set to "quiet boot=fll", or directly boot "memtest.img".
If sidux-2009.iso is written to a CDROM, it will also boot.
Note: UBCD-5.0-rc1 El-Torito loader tries to read after the size of
the CD, to get Gujin to load it, you have to do:
dd if=/dev/zero of=ubcdadd bs=512 count=560
cat ubcdadd >> /boot/ubcd.iso

4- Some ISO images can be copied to a USB stick (by a "dd" command)
and will produce a bootable USB stick - those ISO images contain
a boot record that Gujin can find, and so Gujin will emulate a BIOS
disk for you to boot that way. The previous problem of regenerating
the bootfrom= parameter also exists, with the same solution.

The full list of change is:
- Generate and use a "distributed Linux kernel description" file named
/boot/gujin.cmd, see example/description in the source tar file.
- Handle GPT partitions (support for B.E.E.R. installation in /dev/sda0
cannot work because of the GPT copy at end of disk, replaced by
install in first Mbyte if space is free)
- UTF8 UNIFONT for the 8x16 and 10x20 font, range 0x0..0x200 and
0x400..0x600 (higher often need variable width chars)
- Handle FAT long filename UTF16 to UTF8 mapping
- Language handling completely re-written; support "en", "fr", "ru",
"sp", "it", "pt", "de", "nl" in the same executable
- Add two "xstring" segments to support all those strings, that
increases also the stack available for Gujin
- Debug version only support English, i.e. reducing the number
of language is possible with recompilation
- Remove the restriction that BDI file are contiguous, handle *.bin
and *.img files as *.bdi if they have the 0xAA55 signature.
- Find ISOFS MBR/El-Torito in files *.iso and enable booting (For
Linux, Gujin may have to be the El-Torito bootloader, bootfrom
int 0x13 signature)
- Support filename "linux*" (without iso extension) like "bzImage*" and
"vmlinuz*", to directly boot debian iso netinstall in *.iso file
- Support filename "tinycore*" like "initrd*" to directly boot
tinycore_2.6.iso CD image
- sort kernels by date (newest first) in the menu
- Rename tickbox "download_ansi_font" as "use_gujin_embedded_font"
- Reproble the disk subsystem if "probe_file_in_iso_image" has changed
going from setup to application screen
- Support an efficient way to store block numbers and size of very
large (*.iso) file on an EXT2 filesystem, to analyse its internal FS
- Handle EXT2/3/4 partitions bigger than 32 bits sectors, support
blocks bigger than 4 Kbytes on EXT2FS
- Fix timezone offset of file dates on ISO9660
- Fix bugs with tinycdrom (load kernel/initrd or *.kgz from El-Torito
CDROM without user intervention, see Makefile/CDtiny:)
- Fix an overflow bug in all BIOS tiny* versions when number of
kernels & initrd bigger than 5 in the same partition
- Accept under DOS "vmlinu~1" and "bzImag~1" filenames
- If running on DOS, select the default language with the DOS
environment LANG=.
- Updated man page, installer support of --lang= parameter
- Refuse to create a superfloppy format on a disk which has a valid
partition table, if no --force flag
- Reduce complain with screens without EDID, then assumes 13 inches
display to find default resolution
- Do not show the "alternate" button when no alternative (same
definition & BPP) video mode exists.
- Fix the page number displayed when autoboot of newest file after
few seconds
- When booting kernel/initrd from an ISO file image, replace "bootfrom="
by "fromiso=", works at least with sidux distribution (cmd line "boot=fll")
- increase size of filename booted (but one can still use too long filename
for fromiso= parameter)
- Add option to change default directory name "boot" at runtime (on
some iso like Fedora net-install, set it to "isolinux" and keep iso file in root).
- Detect if the default font of the (simulated) PC is ANSI instead of
the CP437 font
- Fix CRLF problem with serial interface (use GtkTerm 9600,n,8,1 no flow
control & fully wired null-modem cable - else can't see any output)
- Always add a "BOOT_IMAGE=" command line parameter (with the filename
loaded) when booting Linux kernels.
- Enable by default code to set IDE master/user password (like hdparm
--security-set-pass) (See FAQ: What is the option "ignore kernel IDE options"?)
- Do not report the number of "wasted" sector in a partition with ISO9660
filesystem (cat /dev/cdrom > /dev/sda9)
- Change the default partition created (when creating a hard disk image) to
the last partition to enable booting ASUS EeePC
- The pseudo kernel parameter vga= is now initialised to the last graphic
video mode used by Gujin
- Detect two partitions having the same label (causes major problems
with root=LABEL=, fails back to root=/dev/* for those partitions)
- default compiler now gcc-4.4.3/gmp-5.0.0/mpfr-2.4.2/binutils-2.20 (but
for rpm/deb packages, use the default distribution compiler)
- docs updates

There are still some misfeatures, like Gujin cannot be installed on a GPT 
partition over /dev/sda16; the Gujin installer calls sync() so if you copy
an ISO image to a USB drive while installing Gujin on the hard drive - you'll have to wait for the ISO image copy to be finished; I got my Fedora
distributions booting only after setting the label of the filesystem,
I just hope there won't be too many regressions.

Also, note that booting an ISO live system file image solves the problem
of permanent storage: an ext2 filesystem image can be inside the ISO file,
and that filesystem image can be mounted read/write by the live system.
That ext2 internal filesystem can also be mounted read/write if the
distribution is on a DVD-RAM.

Downloads at:
http://sourceforge.net/projects/gujin/files/

Note that I do like success/failure stories about Gujin!

Have fun,
Etienne. 


      

