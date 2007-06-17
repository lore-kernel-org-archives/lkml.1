Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbXFQSUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbXFQSUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 14:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbXFQSUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 14:20:23 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59141
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165AbXFQSUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 14:20:22 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: QEMU's scsi controller no longer works on arm.
Date: Sun, 17 Jun 2007 14:20:30 -0400
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_utXdG25Aj1y2Kvq"
Message-Id: <200706171420.31003.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_utXdG25Aj1y2Kvq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

In 2.6.20, I can boot an arm kernel up to a shell prompt including a virtual 
scsi hard drive.  In 2.6.21-rc1, this stopped working.

I tried "git bisect" and found out there's a range of about 5000 commits 
between the two where arm doesn't compile.  At the start of this range, the 
controller worked.  At the end, it didn't anymore.

How can YOU reproduce this problem?  I'm glad you asked:

The miniconfig I'm using is attached.  You'll need an arm compiler to build 
it, of course.  (If you haven't got one, the cross compiler I made is 
at "http://landley.net/code/firmware/downloads/cross-compiler/".  Download 
the armv4l version for the appropriate host, extract the tarball and add 
the "bin" directory under that to your path.  The x86 version should work on 
Ubuntu 6.06 or newer, the x86-64 version was built on 7.04.)

Configure with:

make ARCH=arm allnoconfig KCONFIG_ALLCONFIG=miniconfig-linux
make ARCH=arm CROSS_COMPILE=armv4l-

And then run qemu on it:

qemu-system-arm -M versatilepb -nographic -no-reboot \
  -hda /dev/null -kernel zImage-armv4l -append \
  'rw panic=1 root=/dev/sdaconsole=ttyAMA0'

The failing system will loop resetting the scsi controller with lots of 
timeouts, and takes several minutes to get the the panic where it can't mount 
root.  The working system will panic due to root being /dev/null fairly 
quickly, without pages of error messages and a very long wait first.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

--Boundary-00=_utXdG25Aj1y2Kvq
Content-Type: text/plain;
  charset="utf-8";
  name="miniconfig-linux"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="miniconfig-linux"

CONFIG_EXPERIMENTAL=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
CONFIG_ARCH_VERSATILE_PB=y
CONFIG_MACH_VERSATILE_AB=y
CONFIG_CPU_ARM926T=y
CONFIG_ARM_THUMB=y
CONFIG_PCI=y
CONFIG_CMDLINE="mem=128M console=ttyAMA0 user_debug=31"
CONFIG_FPE_NWFPE=y
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_MISC=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_NET_KEY=y
CONFIG_INET=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_BRIDGE=y
CONFIG_VLAN_8021Q=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_BLK_DEV_INITRD=y
CONFIG_SCSI=y
CONFIG_SCSI_PROC_FS=y
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=0
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
CONFIG_TUN=y
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPPOE=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_N_HDLC=y
CONFIG_SERIAL_AMBA_PL011=y
CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
CONFIG_HW_RANDOM=y
CONFIG_FIRMWARE_EDID=y
CONFIG_EXT2_FS=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_ROMFS_FS=y
CONFIG_TMPFS=y
CONFIG_CRAMFS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
CONFIG_SMB_FS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_UTF8=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_INFO=y
CONFIG_FORCED_INLINING=y
CONFIG_DEBUG_USER=y
CONFIG_DEBUG_ERRORS=y
CONFIG_DEBUG_LL=y
CONFIG_CRYPTO_CRC32C=y

--Boundary-00=_utXdG25Aj1y2Kvq--
