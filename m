Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbXHaIP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbXHaIP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 04:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXHaIPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 04:15:09 -0400
Received: from gg.genua.de ([151.136.100.2]:41861 "EHLO gg.genua.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbXHaIPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 04:15:05 -0400
X-Greylist: delayed 1145 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2007 04:15:04 EDT
Date: Fri, 31 Aug 2007 09:54:35 +0200
From: Christian Ehrhardt <lk@c--e.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: New x86-Setup code breaks HVM-XEN boot
Message-ID: <20070831075434.GF20195@genua.de>
References: <20070830141528.GA307@lisa.in-ulm.de> <46D714A9.4060103@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <46D714A9.4060103@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 12:04:09PM -0700, Jeremy Fitzhardinge wrote:
> Are there any messages on the xen console ("xm dmesg")?  Or logs ("xm
> log")?  What version of Xen are you using?  What does your domain config
> file look like?

Domain Config:
| kernel = "hvmloader"
| builder='hvm'
| memory = 256
| shadow_memory = 16
| name = "ceh-lin-hvm"
| vif = [ 'type=ioemu, mac=00:16:3e:aa:00:08, bridge=xenbr0,
| model=ne2k_pci' ]
| disk = [ 'file:/xen/ceh-lin-hvm.img,ioemu:hda,w', 'file:/xen/cd/debian-40r0-i386-netinst.iso,hdc:cdrom,r' ]
| device_model = 'qemu-dm'
| boot="cad"
| sdl=0
| vnc=1
| vncunused=0
| stdvga=0
| serial='pty'

------------- xm dmesg output ---------------------------------

(XEN) vmx_do_launch(): GUEST_CR3<=00bbfda0, HOST_CR3<=a1f47000
(XEN) (GUEST: 353) HVM Loader
(XEN) (GUEST: 353) Detected Xen v3.0.3-1
(XEN) (GUEST: 353) Writing SMBIOS tables ...
(XEN) (GUEST: 353) Loading ROMBIOS ...
(XEN) (GUEST: 353) Loading Cirrus VGABIOS ...
(XEN) (GUEST: 353) Loading VMXAssist ...
(XEN) (GUEST: 353) VMX go ...
(XEN) (GUEST: 353) VMXAssist (Nov  2 2006)
(XEN) (GUEST: 353) Memory size 256 MB
(XEN) (GUEST: 353) E820 map:
(XEN) (GUEST: 353) 0000000000000000 - 000000000009F000 (RAM)
(XEN) (GUEST: 353) 000000000009F000 - 00000000000A0000 (Reserved)
(XEN) (GUEST: 353) 00000000000A0000 - 00000000000C0000 (Type 16)
(XEN) (GUEST: 353) 00000000000F0000 - 0000000000100000 (Reserved)
(XEN) (GUEST: 353) 0000000000100000 - 000000000FFF0000 (RAM)
(XEN) (GUEST: 353) 000000000FFF0000 - 000000000FFFA000 (ACPI Data)
(XEN) (GUEST: 353) 000000000FFFA000 - 000000000FFFD000 (ACPI NVS)
(XEN) (GUEST: 353) 000000000FFFD000 - 000000000FFFE000 (Type 19)
(XEN) (GUEST: 353) 000000000FFFE000 - 000000000FFFF000 (Type 18)
(XEN) (GUEST: 353) 000000000FFFF000 - 0000000010000000 (Type 17)
(XEN) (GUEST: 353) 00000000FEC00000 - 0000000100000000 (Type 16)
(XEN) (GUEST: 353) 
(XEN) (GUEST: 353) Start BIOS ...
(XEN) (GUEST: 353) Starting emulated 16-bit real-mode: ip=F000:FFF0
(XEN) (GUEST: 353)  rombios.c,v 1.138 2005/05/07 15:55:26 vruppert Exp $
(XEN) (GUEST: 353) Remapping master: ICW2 0x8 -> 0x20
(XEN) (GUEST: 353) Remapping slave: ICW2 0x70 -> 0x28
(XEN) (GUEST: 353) VGABios $Id: vgabios.c,v 1.61 2005/05/24 16:50:50 vruppert Exp $
(XEN) (GUEST: 353) HVMAssist BIOS, 1 cpu, $Revision: 1.138 $ $Date: 2005/05/07 15:55:26 $
(XEN) (GUEST: 353) 
(XEN) (GUEST: 353) ata0-0: PCHS=5079/16/63 translation=lba LCHS=634/128/63
(XEN) (GUEST: 353) ata0 master: QEMU HARDDISK ATA-7 Hard-Disk (2500 MBytes)
(XEN) (GUEST: 353) ata0  slave: Unknown device
(XEN) (GUEST: 353) ata1 master: QEMU CD-ROM ATAPI-4 CD-Rom/DVD-Rom
(XEN) (GUEST: 353) ata1  slave: Unknown device
(XEN) (GUEST: 353) 
(XEN) (GUEST: 353) Booting from Hard Disk...
(XEN) (GUEST: 353) KBD: unsupported int 16h function 03
(XEN) (GUEST: 353) *** int 15h function AX=E980, BX=0000 not yet supported!
(XEN) (GUEST: 353) int13_harddisk: function 41, unmapped device for ELDL=81
(XEN) (GUEST: 353) int13_harddisk: function 42, unmapped device for ELDL=81
(XEN) (GUEST: 353) int13_harddisk: function 02, unmapped device for ELDL=81
(XEN) (GUEST: 353) int13_harddisk: function 41, unmapped device for ELDL=82
(XEN) (GUEST: 353) int13_harddisk: function 42, unmapped device for ELDL=82
(XEN) (GUEST: 353) int13_harddisk: function 02, unmapped device for ELDL=82
(XEN) (GUEST: 353) int13_harddisk: function 41, unmapped device for ELDL=83
(XEN) (GUEST: 353) int13_harddisk: function 42, unmapped device for ELDL=83
(XEN) (GUEST: 353) int13_harddisk: function 02, unmapped device for ELDL=83
(XEN) (GUEST: 353) int13_harddisk: function 41, unmapped device for ELDL=84
(XEN) (GUEST: 353) int13_harddisk: function 42, unmapped device for ELDL=84
(XEN) (GUEST: 353) int13_harddisk: function 02, unmapped device for ELDL=84
(XEN) (GUEST: 353) int13_harddisk: function 41, unmapped device for ELDL=85
(XEN) (GUEST: 353) int13_harddisk: function 42, unmapped device for ELDL=85
(XEN) (GUEST: 353) int13_harddisk: function 02, unmapped device for ELDL=85
(XEN) (GUEST: 353) int13_harddisk: function 41, unmapped device for ELDL=86
(XEN) (GUEST: 353) int13_harddisk: function 42, unmapped device for ELDL=86
(XEN) (GUEST: 353) int13_harddisk: function 02, unmapped device for ELDL=86
(XEN) (GUEST: 353) int13_harddisk: function 41, unmapped device for ELDL=87
(XEN) (GUEST: 353) int13_harddisk: function 42, unmapped device for ELDL=87
(XEN) (GUEST: 353) int13_harddisk: function 02, unmapped device for ELDL=87
(XEN) (GUEST: 353) int13_harddisk: function 41, ELDL out of range 88
(XEN) (GUEST: 353) int13_harddisk: function 42, ELDL out of range 88
(XEN) (GUEST: 353) int13_harddisk: function 02, ELDL out of range 88
(XEN) (GUEST: 353) int13_harddisk: function 41, ELDL out of range 89
(XEN) (GUEST: 353) int13_harddisk: function 42, ELDL out of range 89
(XEN) (GUEST: 353) int13_harddisk: function 02, ELDL out of range 89
(XEN) (GUEST: 353) int13_harddisk: function 41, ELDL out of range 8A
(XEN) (GUEST: 353) int13_harddisk: function 42, ELDL out of range 8A
(XEN) (GUEST: 353) int13_harddisk: function 02, ELDL out of range 8A
(XEN) (GUEST: 353) int13_harddisk: function 41, ELDL out of range 8B
(XEN) (GUEST: 353) int13_harddisk: function 42, ELDL out of range 8B
(XEN) (GUEST: 353) int13_harddisk: function 02, ELDL out of range 8B
(XEN) (GUEST: 353) int13_harddisk: function 41, ELDL out of range 8C
(XEN) (GUEST: 353) int13_harddisk: function 42, ELDL out of range 8C
(XEN) (GUEST: 353) int13_harddisk: function 02, ELDL out of range 8C
(XEN) (GUEST: 353) int13_harddisk: function 41, ELDL out of range 8D
(XEN) (GUEST: 353) int13_harddisk: function 42, ELDL out of range 8D
(XEN) (GUEST: 353) int13_harddisk: function 02, ELDL out of range 8D
(XEN) (GUEST: 353) int13_harddisk: function 41, ELDL out of range 8E
(XEN) (GUEST: 353) int13_harddisk: function 42, ELDL out of range 8E
(XEN) (GUEST: 353) int13_harddisk: function 02, ELDL out of range 8E
(XEN) (GUEST: 353) int13_harddisk: function 41, ELDL out of range 8F
(XEN) (GUEST: 353) int13_harddisk: function 42, ELDL out of range 8F
(XEN) (GUEST: 353) int13_harddisk: function 02, ELDL out of range 8F
(XEN) Failed vm entry (exit reason 0x80000021) caused by invalid guest state (0).
(XEN) ************* VMCS Area **************
(XEN) 	 16-bit Guest-State Fields
(XEN) 		0x00000800: 0x0018 0x0010 0x0018 0x0018 
(XEN) 		0x00000808: 0x0018 0x0018 0x0000 0x0008 
(XEN) 	 16-bit Host-State Fields
(XEN) 		0x00000c00: 0xe010 0xe008 0xe010 0xe010 
(XEN) 		0x00000c08: 0xe010 0xe010 0xe050 
(XEN) 	 64-bit Control Fields
(XEN) 		0x00002000: 0x0000000000bd5000 0x0000000000000000 0x0000000000bd4000 0x0000000000000000 
(XEN) 		0x00002004: 0x0000000000000000 0x0000000000000000 0x0000000000000000 0x0000000000000000 
(XEN) 		0x00002008: 0x0000000000000000 0x0000000000000000 0x0000000000000000 0x0000000000000000 
(XEN) 		0x0000200c: 0x0000000000000000 0x0000000000000000 ------------------ ------------------ 
(XEN) 		0x00002010: 0x00000000d8ba12e5 0x00000000ffd5e176 0x0000000000000000 0x0000000000000000 
(XEN) 	 64-bit Guest-State Fields
(XEN) 		0x00002800: 0x00000000ffffffff 0x00000000ffffffff 0x0000000000000000 0x0000000000000000 
(XEN) 	 32-bit Control Fields
(XEN) 		0x00004000: 0x0000001f 0x0681e7fa 0x00004008 0x00000000 
(XEN) 		0x00004008: 0x00000000 0x00000000 0x0003edff 0x00000000 
(XEN) 		0x00004010: 0x00000000 0x000011ff 0x00000000 0x00000020 
(XEN) 		0x00004018: 0x00000000 0x00000000 0x00000000 
(XEN) 	 32-bit RO Data Fields
(XEN) 		0x00004400: 0x0000000c 0x80000021 0x00000000 0x00050033 
(XEN) 		0x00004408: 0x00000000 0x00000000 0x00000003 0x00000000 
(XEN) 	 32-bit Guest-State Fields
(XEN) 		0x00004800: 0xffffffff 0xffffffff 0xffffffff 0xffffffff 
(XEN) 		0x00004808: 0xffffffff 0xffffffff 0x00000000 0x00002067 
(XEN) 		0x00004810: 0x00006fb5 0x00000000 0x0000d0ff 0x0000d0ff 
(XEN) 		0x00004818: 0x0000d0ff 0x0000d0ff 0x0000d0ff 0x0000d0ff 
(XEN) 		0x00004820: 0x00000082 0x0000008b 0x00000000 0x00000000 
(XEN) 		0x00004828: 0x00000000 0x00000000 
(XEN) 	 32-bit Host-State Fields
(XEN) 		0x00004c00: 0x00000000 
(XEN) 	 Natural 64-bit Control Fields
(XEN) 		0x00006000: 0x00000000ffffffff 0x00000000ffffffff 0x0000000000050033 0x0000000000000651 
(XEN) 		0x00006008: 0x0000000000000000 0x0000000000000000 0x0000000000000000 0x0000000000000000 
(XEN) 	 64-bit RO Data Fields
(XEN) 		0x00006400: 0x0000000000000000 0x0000000000010002 0x00000000003f7fd5 0x00000000001a2000 
(XEN) 		0x00006408: 0x00000000000d11b2 0x0000000000000000 
(XEN) 	 Natural 64-bit Guest-State Fields
(XEN) 		0x00006800: 0x0000000080050033 0x0000000000bbfda0 0x0000000000002671 0x00000000ffffffff 
(XEN) 		0x00006808: 0x00000000ffffffff 0x00000000ffffffff 0x00000000ffffffff 0x00000000ffffffff 
(XEN) 		0x00006810: 0x00000000ffffffff 0x0000000000000000 0x00000000000d7264 0x00000000190df0bc 
(XEN) 		0x00006818: 0x0000000000000000 0x0000000000000400 0x000000000000f9e8 0x0000000000100000 
(XEN) 		0x00006820: 0x0000000000010002 0x0000000000000000 0x0000000000000000 0x0000000000000000 
(XEN) 	 Natural 64-bit Host-State Fields
(XEN) 		0x00006c00: 0x000000008005003b 0x00000000a1f47000 0x00000000000026f0 0x0000000000000000 
(XEN) 		0x00006c08: 0x0000000000000000 0x00000000ff1cf380 0x00000000fe800000 0x00000000ffbeb080 
(XEN) 		0x00006c10: 0x0000000000000000 0x0000000000000000 0x00000000ffbf3fe8 0x00000000ff14ab10 
(XEN) **************************************
(XEN) domain_crash_sync called from vmx.c:2154
(XEN) Domain 353 (vcpu#0) crashed on cpu#1:
(XEN) ----[ Xen-3.0.3-1  x86_32p  debug=n  Not tainted ]----
(XEN) CPU:    1
(XEN) EIP:    0010:[<00100000>]
(XEN) EFLAGS: 00010002   CONTEXT: hvm
(XEN) eax: 00100000   ebx: 00000000   ecx: f0000018   edx: 00050013
(XEN) esi: 000932a0   edi: 000042d0   ebp: 000d0000   esp: 0000f9e8
(XEN) cr0: 00050033   cr4: 00000651   cr3: 00bbfda0   cr2: 00000000
(XEN) ds: 0018   es: 0018   fs: 0018   gs: 0018   ss: 0018   cs: 0010


------------------ xm log output -------------------------
[2007-08-31 09:35:55 xend.XendDomainInfo 3121] INFO (__init__:1072) Domain has shutdown: name=ceh-lin-hvm id=352 reason=reboot.
[2007-08-31 09:35:55 xend.XendDomainInfo 3121] DEBUG (__init__:1072) XendDomainInfo.destroyDomain(352)
[2007-08-31 09:35:55 xend 3121] DEBUG (__init__:1072) hvm shutdown watch unregistered
[2007-08-31 09:35:56 xend.XendDomainInfo 3121] DEBUG (__init__:1072) XendDomainInfo.create([\047domain\047, [\047domid\047, 352], [\047uuid\047, \0477735d90d-842c-0e56-d5d6-545a72d1b944\047], [\047vcpus\047, 1], [\047vcpu_avail\047, 1], [\047cpu_weight\047, 1.0], [\047memory\047, 256], [\047shadow_memory\047, 16], [\047maxmem\047, 256], [\047features\047, \047\047], [\047name\047, \047ceh-lin-hvm\047], [\047on_poweroff\047, \047destroy\047], [\047on_reboot\047, \047restart\047], [\047on_crash\047, \047restart\047], [\047image\047, [\047hvm\047, [\047kernel\047, \047/usr/lib/xen-3.0.3-1/boot/hvmloader\047], [\047vcpus\047, 1], [\047boot\047, \047cad\047], [\047serial\047, \047pty\047], [\047vnc\047, 1], [\047xauthority\047, \047/home/ehrhardt/.Xauthority\047], [\047device_model\047, \047/usr/lib/xen-3.0.3-1/bin/qemu-dm\047]]], [\047device\047, [\047vif\047, [\047backend\047, 0], [\047script\047, \047vif-bridge\047], [\047bridge\047, \047xenbr0\047], [\047mac\047, \04700:16:3e:aa:00:08\047], [\047type\047, \047ioemu\047]]], [\047device\047, [\047vbd\047, [\047backend\047, 0], [\047dev\047, \047hda:disk\047], [\047uname\047, \047file:/xen/ceh-lin-hvm.img\047], [\047mode\047, \047w\047]]], [\047device\047, [\047vbd\047, [\047backend\047, 0], [\047dev\047, \047hdc:cdrom\047], [\047uname\047, \047file:/xen/cd/debian-40r0-i386-netinst.iso\047], [\047mode\047, \047r\047]]], [\047state\047, \047--ps--\047], [\047shutdown_reason\047, \047reboot\047], [\047cpu_time\047, 346.25154584799998], [\047online_vcpus\047, 1], [\047up_time\047, \04764017.2058749\047], [\047start_time\047, \0471188481738.75\047], [\047store_mfn\047, 521134]])
[2007-08-31 09:35:56 xend.XendDomainInfo 3121] DEBUG (__init__:1072) parseConfig: config is [\047domain\047, [\047domid\047, 352], [\047uuid\047, \0477735d90d-842c-0e56-d5d6-545a72d1b944\047], [\047vcpus\047, 1], [\047vcpu_avail\047, 1], [\047cpu_weight\047, 1.0], [\047memory\047, 256], [\047shadow_memory\047, 16], [\047maxmem\047, 256], [\047features\047, \047\047], [\047name\047, \047ceh-lin-hvm\047], [\047on_poweroff\047, \047destroy\047], [\047on_reboot\047, \047restart\047], [\047on_crash\047, \047restart\047], [\047image\047, [\047hvm\047, [\047kernel\047, \047/usr/lib/xen-3.0.3-1/boot/hvmloader\047], [\047vcpus\047, 1], [\047boot\047, \047cad\047], [\047serial\047, \047pty\047], [\047vnc\047, 1], [\047xauthority\047, \047/home/ehrhardt/.Xauthority\047], [\047device_model\047, \047/usr/lib/xen-3.0.3-1/bin/qemu-dm\047]]], [\047device\047, [\047vif\047, [\047backend\047, 0], [\047script\047, \047vif-bridge\047], [\047bridge\047, \047xenbr0\047], [\047mac\047, \04700:16:3e:aa:00:08\047], [\047type\047, \047ioemu\047]]], [\047device\047, [\047vbd\047, [\047backend\047, 0], [\047dev\047, \047hda:disk\047], [\047uname\047, \047file:/xen/ceh-lin-hvm.img\047], [\047mode\047, \047w\047]]], [\047device\047, [\047vbd\047, [\047backend\047, 0], [\047dev\047, \047hdc:cdrom\047], [\047uname\047, \047file:/xen/cd/debian-40r0-i386-netinst.iso\047], [\047mode\047, \047r\047]]], [\047state\047, \047--ps--\047], [\047shutdown_reason\047, \047reboot\047], [\047cpu_time\047, 346.25154584799998], [\047online_vcpus\047, 1], [\047up_time\047, \04764017.2058749\047], [\047start_time\047, \0471188481738.75\047], [\047store_mfn\047, 521134]]
[2007-08-31 09:35:56 xend.XendDomainInfo 3121] DEBUG (__init__:1072) parseConfig: result is {\047shadow_memory\047: 16, \047uuid\047: \0477735d90d-842c-0e56-d5d6-545a72d1b944\047, \047on_crash\047: \047restart\047, \047on_reboot\047: \047restart\047, \047localtime\047: None, \047image\047: [\047hvm\047, [\047kernel\047, \047/usr/lib/xen-3.0.3-1/boot/hvmloader\047], [\047vcpus\047, 1], [\047boot\047, \047cad\047], [\047serial\047, \047pty\047], [\047vnc\047, 1], [\047xauthority\047, \047/home/ehrhardt/.Xauthority\047], [\047device_model\047, \047/usr/lib/xen-3.0.3-1/bin/qemu-dm\047]], \047on_poweroff\047: \047destroy\047, \047bootloader_args\047: None, \047cpus\047: None, \047name\047: \047ceh-lin-hvm\047, \047backend\047: [], \047vcpus\047: 1, \047cpu_weight\047: 1.0, \047features\047: \047\047, \047vcpu_avail\047: 1, \047memory\047: 256, \047device\047: [(\047vif\047, [\047vif\047, [\047backend\047, 0], [\047script\047, \047vif-bridge\047], [\047bridge\047, \047xenbr0\047], [\047mac\047, \04700:16:3e:aa:00:08\047], [\047type\047, \047ioemu\047]]), (\047vbd\047, [\047vbd\047, [\047backend\047, 0], [\047dev\047, \047hda:disk\047], [\047uname\047, \047file:/xen/ceh-lin-hvm.img\047], [\047mode\047, \047w\047]]), (\047vbd\047, [\047vbd\047, [\047backend\047, 0], [\047dev\047, \047hdc:cdrom\047], [\047uname\047, \047file:/xen/cd/debian-40r0-i386-netinst.iso\047], [\047mode\047, \047r\047]])], \047bootloader\047: None, \047cpu\047: None, \047maxmem\047: 256}
[2007-08-31 09:35:56 xend.XendDomainInfo 3121] DEBUG (__init__:1072) XendDomainInfo.construct: None
[2007-08-31 09:35:56 xend.XendDomainInfo 3121] DEBUG (__init__:1072) XendDomainInfo.initDomain: 353 1.0
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: boot, val: cad
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: fda, val: None
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: fdb, val: None
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: soundhw, val: None
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: localtime, val: None
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: serial, val: pty
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: std-vga, val: None
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: isa, val: None
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: vcpus, val: 1
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: acpi, val: None
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: usb, val: None
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) args: usbdevice, val: None
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) Balloon: 540112 KiB free; need 291432; done.
[2007-08-31 09:35:56 xend 3121] INFO (__init__:1072) buildDomain os=hvm dom=353 vcpus=1
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) dom            = 353
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) image          = /usr/lib/xen-3.0.3-1/boot/hvmloader
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) store_evtchn   = 1
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) memsize        = 256
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) vcpus          = 1
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) pae            = 0
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) acpi           = 0
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) apic           = 0
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) hvm shutdown watch registered
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) DevController: writing {\047state\047: \0471\047, \047backend-id\047: \0470\047, \047backend\047: \047/local/domain/0/backend/vif/353/0\047} to /local/domain/353/device/vif/0.
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) DevController: writing {\047bridge\047: \047xenbr0\047, \047domain\047: \047ceh-lin-hvm\047, \047handle\047: \0470\047, \047script\047: \047/etc/xen/scripts/vif-bridge\047, \047state\047: \0471\047, \047frontend\047: \047/local/domain/353/device/vif/0\047, \047mac\047: \04700:16:3e:aa:00:08\047, \047online\047: \0471\047, \047frontend-id\047: \047353\047, \047type\047: \047ioemu\047} to /local/domain/0/backend/vif/353/0.
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) DevController: writing {\047backend-id\047: \0470\047, \047virtual-device\047: \047768\047, \047device-type\047: \047disk\047, \047state\047: \0471\047, \047backend\047: \047/local/domain/0/backend/vbd/353/768\047} to /local/domain/353/device/vbd/768.
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) DevController: writing {\047domain\047: \047ceh-lin-hvm\047, \047frontend\047: \047/local/domain/353/device/vbd/768\047, \047dev\047: \047hda\047, \047state\047: \0471\047, \047params\047: \047/xen/ceh-lin-hvm.img\047, \047mode\047: \047w\047, \047online\047: \0471\047, \047frontend-id\047: \047353\047, \047type\047: \047file\047} to /local/domain/0/backend/vbd/353/768.
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) exception looking up device number for hdc: [Errno 2] No such file or directory: \047/dev/hdc\047
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) DevController: writing {\047backend-id\047: \0470\047, \047virtual-device\047: \0475632\047, \047device-type\047: \047cdrom\047, \047state\047: \0471\047, \047backend\047: \047/local/domain/0/backend/vbd/353/5632\047} to /local/domain/353/device/vbd/5632.
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) DevController: writing {\047domain\047: \047ceh-lin-hvm\047, \047frontend\047: \047/local/domain/353/device/vbd/5632\047, \047dev\047: \047hdc\047, \047state\047: \0471\047, \047params\047: \047/xen/cd/debian-40r0-i386-netinst.iso\047, \047mode\047: \047r\047, \047online\047: \0471\047, \047frontend-id\047: \047353\047, \047type\047: \047file\047} to /local/domain/0/backend/vbd/353/5632.
[2007-08-31 09:35:56 xend 3121] INFO (__init__:1072) spawning device models: /usr/lib/xen-3.0.3-1/bin/qemu-dm [\047/usr/lib/xen-3.0.3-1/bin/qemu-dm\047, \047-d\047, \047353\047, \047-m\047, \047256\047, \047-boot\047, \047cad\047, \047-serial\047, \047pty\047, \047-vcpus\047, \0471\047, \047-domain-name\047, \047ceh-lin-hvm\047, \047-net\047, \047nic,vlan=1,macaddr=00:16:3e:aa:00:08,model=rtl8139\047, \047-net\047, \047tap,vlan=1,bridge=xenbr0\047, \047-vnc\047, \047353\047, \047-k\047, \047en-us\047, \047-vnclisten\047, \0470.0.0.0\047]
[2007-08-31 09:35:56 xend 3121] INFO (__init__:1072) device model pid: 20157
[2007-08-31 09:35:56 xend.XendDomainInfo 3121] DEBUG (__init__:1072) Storing VM details: {\047shadow_memory\047: \04716\047, \047uuid\047: \0477735d90d-842c-0e56-d5d6-545a72d1b944\047, \047on_reboot\047: \047restart\047, \047start_time\047: \0471188545756.64\047, \047on_poweroff\047: \047destroy\047, \047name\047: \047ceh-lin-hvm\047, \047vcpus\047: \0471\047, \047vcpu_avail\047: \0471\047, \047memory\047: \047256\047, \047on_crash\047: \047restart\047, \047image\047: \047(hvm (kernel /usr/lib/xen-3.0.3-1/boot/hvmloader) (vcpus 1) (boot cad) (serial pty) (vnc 1) (xauthority /home/ehrhardt/.Xauthority) (device_model /usr/lib/xen-3.0.3-1/bin/qemu-dm))\047, \047maxmem\047: \047256\047}
[2007-08-31 09:35:56 xend.XendDomainInfo 3121] DEBUG (__init__:1072) Storing domain details: {\047console/port\047: \0472\047, \047name\047: \047ceh-lin-hvm\047, \047console/limit\047: \0471048576\047, \047vm\047: \047/vm/7735d90d-842c-0e56-d5d6-545a72d1b944\047, \047domid\047: \047353\047, \047cpu/0/availability\047: \047online\047, \047memory/target\047: \047262144\047, \047store/ring-ref\047: \047423623\047, \047store/port\047: \0471\047}
[2007-08-31 09:35:56 xend 3121] DEBUG (__init__:1072) hvm_shutdown fired, shutdown reason=None
[2007-08-31 09:35:56 xend.XendDomainInfo 3121] DEBUG (__init__:1072) XendDomainInfo.handleShutdownWatch
[2007-08-31 09:36:07 xend.XendDomainInfo 3121] WARNING (__init__:1072) Domain has crashed: name=ceh-lin-hvm id=353.
[2007-08-31 09:36:07 xend.XendDomainInfo 3121] ERROR (__init__:1072) VM ceh-lin-hvm restarting too fast (11.676922 seconds since the last restart).  Refusing to restart to avoid loops.
[2007-08-31 09:36:07 xend.XendDomainInfo 3121] DEBUG (__init__:1072) XendDomainInfo.destroy: domid=353
[2007-08-31 09:36:07 xend.XendDomainInfo 3121] DEBUG (__init__:1072) XendDomainInfo.destroyDomain(353)
[2007-08-31 09:36:07 xend 3121] DEBUG (__init__:1072) hvm shutdown watch unregistered

   regards   Christian

