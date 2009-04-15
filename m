Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZDOVPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZDOVPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZDOVPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:15:31 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:33868 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZDOVP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:15:29 -0400
Message-ID: <49E64E86.4080109@oracle.com>
Date: Wed, 15 Apr 2009 14:15:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: devzero@web.de, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: Should MODULE_DESCRIPTION be mandatory ?
References: <671646821@web.de> <20090415194226.GB25783@uranus.ravnborg.org>
In-Reply-To: <20090415194226.GB25783@uranus.ravnborg.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49E64E62.00C6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Apr 15, 2009 at 01:11:46PM +0200, devzero@web.de wrote:
>> Hi, 
>>
>> some time ago i spotted that around 20% of the Linux modules lacking a MODULE_DESCRIPTION field.  ( http://bugzilla.kernel.org/show_bug.cgi?id=10770 )
>>
>> I think it`s not a practicable approach to get this fixed by some single person digging trough all the modules. 
>> If itŽs fixed for a kernel release, one year later there would be another bunch of new modules lacking the description field again.
>>
>> What about a build-time or run-time warning for missing MODULE_DESCRIPTION ? (as it exists for MODULE_LICENSE in modpost.c) 
> 
> 
> You mean something like the following untested patch?
> If it works what is the output for an allmodconfig build?
> 
> 	Sam
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 8cc7061..5317d6f 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1553,6 +1553,7 @@ static void read_symbols(char *modname)
>  	const char *symname;
>  	char *version;
>  	char *license;
> +	char *description;
>  	struct module *mod;
>  	struct elf_info info = { };
>  	Elf_Sym *sym;
> @@ -1584,6 +1585,11 @@ static void read_symbols(char *modname)
>  		license = get_next_modinfo(info.modinfo, info.modinfo_len,
>  					   "license", license);
>  	}
> +	description = get_modinfo(info.modinfo, info.modinfo_len, "description");
> +	if (info.modinfo && !description && !is_vmlinux(modname))
> +		warn("modpost: missing MODULE_DESCRIPTION() in %s\n"
> +		     "see include/linux/module.h for "
> +		     "more information\n", modname);
>  
>  	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
>  		symname = info.strtab + sym->st_name;
> --

on x86_64 allmodconfig (2.6.30-rc2), here are the "missing"s that are reported:

WARNING: modpost: missing MODULE_DESCRIPTION() in Documentation/filesystems/configfs/configfs_example_explicit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in Documentation/filesystems/configfs/configfs_example_macros.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/ia32/ia32_aout.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-amd.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-intel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/mm/testmmiotrace.o
WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/xor.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/atm/atmtcp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/atm/eni.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/atm/firestream.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/atm/iphase.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/atm/suni.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/atm/uPD98402.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/atm/zatm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/DAC960.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/brd.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/floppy.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/loop.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/aten.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/bpck.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/comm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/dstr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/epat.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/epia.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/fit2.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/fit3.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/friq.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/frpw.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/kbic.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/ktti.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/on20.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/on26.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/paride.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/pcd.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/pd.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/pf.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/pg.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/paride/pt.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/ub.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/cdrom/cdrom.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/agp/intel-agp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/agp/sis-agp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/agp/via-agp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/cyclades.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/epca.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/generic_serial.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/lp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/n_hdlc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/n_r3964.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/nvram.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/pcmcia/cm4000_cs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/pcmcia/cm4040_cs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/pcmcia/synclink_cs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/ppdev.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/raw.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/riscom8.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/specialix.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/sx.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/synclink.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/synclink_gt.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/synclinkmp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/tlclk.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dca/dca.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dma/dmatest.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dma/ioatdma.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/gpio/mcp23s08.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/gpio/pcf857x.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-a4tech.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-apple.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-belkin.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-cherry.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-chicony.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-cypress.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-drff.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-ezkey.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-gaff.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-gyration.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-kensington.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-kye.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-logitech.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-microsoft.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-monterey.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-ntrig.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-petalynx.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-pl.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-samsung.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-sony.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-sunplus.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-tmff.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-topseed.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid-zpff.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hid/hid.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hwmon/asus_atk0110.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/hwmon/sht15.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/i2c/busses/i2c-ali1563.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/ide/cmd640.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/ide/ide-core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/ide/ide-generic.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/ide/ide-pnp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/ieee1394/ieee1394.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/ieee1394/raw1394.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/input/gameport/fm801-gp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/input/tablet/gtco.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/isdn/hardware/mISDN/hfcmulti.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/isdn/hardware/mISDN/hfcpci.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/isdn/hardware/mISDN/hfcsusb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/isdn/mISDN/l1oip.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/isdn/mISDN/mISDN_core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/isdn/mISDN/mISDN_dsp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/md/faulty.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/md/linear.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/md/md-mod.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/md/multipath.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/md/raid0.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/md/raid1.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/md/raid10.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/md/raid456.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/md/raid6_pq.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/common/ir-common.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/common/tuners/tda9887.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/dvb/bt8xx/bt878.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/dvb/dvb-usb/dvb-usb-dibusb-common.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/dvb/ttpci/budget-core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/bw-qcam.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/cpia_usb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/ivtv/ivtvfb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/saa7134/saa7134-alsa.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/saa7134/saa7134-dvb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/saa7134/saa7134-empress.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/stradis.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/usbvideo/ultracam.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/usbvideo/usbvideo.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/v4l2-compat-ioctl32.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/v4l2-int-device.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/media/video/videobuf-dvb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mfd/mfd-core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mfd/wm8400-core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/misc/lkdtm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mmc/card/sdio_uart.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mmc/core/mmc_core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mtd/chips/cfi_cmdset_0020.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mtd/chips/cfi_util.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mtd/maps/map_funcs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/mtd/nand/alauda.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/8390.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/appletalk/ipddp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/arcnet/arc-rawmode.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/arcnet/arc-rimi.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/arcnet/arcnet.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/arcnet/capmode.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/arcnet/com20020-pci.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/arcnet/com20020.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/arcnet/com90io.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/arcnet/com90xx.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/arcnet/rfc1051.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/arcnet/rfc1201.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/bsd_comp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/de600.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/de620.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/dummy.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/eql.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/ifb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/pcmcia/com20020_cs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/pcmcia/ibmtr_cs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/phy/mdio-bitbang.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/plip.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/ppp_async.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/ppp_deflate.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/ppp_generic.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/ppp_synctty.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/s2io.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/skfp/skfp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/slhc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/slip.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/smsc9420.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/sungem_phy.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/tokenring/abyss.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/tokenring/tms380tr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/tokenring/tmspci.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/tulip/de4x5.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/wan/lmc/lmc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/wan/sbni.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/wan/x25_asy.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/wireless/netwave_cs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/wireless/p54/p54spi.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/wireless/wavelan_cs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/parport/parport.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/pci/pci-stub.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/pcmcia/i82092.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/pcmcia/rsrc_nonstatic.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/pcmcia/yenta_socket.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/power/pda_power.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/rtc/rtc-lib.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/BusLogic.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/advansys.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/aic7xxx_old.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/atp870u.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/gdth.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/imm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/ppa.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/serial/serial_cs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/spi/spi_bitbang.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/telephony/ixj_pcmcia.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/telephony/phonedev.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/uio/uio.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/uio/uio_aec.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/uio/uio_cif.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/uio/uio_smx.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/class/usbtmc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/core/usbcore.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/gadget/g_midi.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/gadget/g_zero.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/misc/berry_charge.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/misc/isight_firmware.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/mon/usbmon.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/serial/ark3116.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/serial/ch341.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/serial/funsoft.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/serial/moto_modem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/serial/navman.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/serial/opticon.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/serial/symbolserial.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/serial/usb_debug.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/storage/libusual.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/video/backlight/platform_lcd.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/video/console/fbcon.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/video/kyro/kyrofb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/video/macmodes.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/video/matrox/matroxfb_DAC1064.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/video/matrox/matroxfb_Ti3026.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/video/matrox/matroxfb_accel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/video/vfb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/video/via/viafb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/virtio/virtio.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/virtio/virtio_ring.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/9p/9p.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/adfs/adfs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/autofs/autofs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/autofs4/autofs4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/binfmt_misc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/btrfs/btrfs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/cramfs/cramfs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/efs/efs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/exportfs/exportfs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/fat/fat.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/hfs/hfs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/hpfs/hpfs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/isofs/isofs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/jbd/jbd.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/jbd2/jbd2.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/minix/minix.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/ncpfs/ncpfs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nfs/nfs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nfs_common/nfs_acl.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nfsd/nfsd.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_ascii.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_base.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp1250.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp1251.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp1255.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp437.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp737.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp775.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp850.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp852.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp855.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp857.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp860.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp861.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp862.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp863.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp864.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp865.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp866.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp869.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp874.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp932.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp936.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp949.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_cp950.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_euc-jp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_iso8859-1.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_iso8859-13.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_iso8859-14.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_iso8859-15.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_iso8859-2.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_iso8859-3.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_iso8859-4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_iso8859-5.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_iso8859-6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_iso8859-7.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_iso8859-9.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_koi8-r.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_koi8-ru.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_koi8-u.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nls/nls_utf8.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/qnx4/qnx4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/smbfs/smbfs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/sysv/sysv.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/ufs/ufs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in kernel/backtracetest.o
WARNING: modpost: missing MODULE_DESCRIPTION() in kernel/rcutorture.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/ts_bm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/ts_fsm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/ts_kmp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/zlib_deflate/zlib_deflate.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/802/fddi.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/802/garp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/802/p8022.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/802/p8023.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/802/psnap.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/802/stp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/802/tr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/8021q/8021q.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/9p/9pnet.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/atm/atm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/atm/lec.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/atm/mpoa.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/bridge/bridge.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/bridge/netfilter/ebtable_broute.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/bridge/netfilter/ebtable_filter.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/bridge/netfilter/ebtable_nat.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/bridge/netfilter/ebtables.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/econet/econet.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/ah4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/esp4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/inet_diag.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/ip_gre.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/ipip.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/netfilter/iptable_nat.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/netfilter/iptable_raw.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/netfilter/nf_conntrack_ipv4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/netfilter/nf_defrag_ipv4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/netfilter/nf_nat.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/tcp_diag.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/tunnel4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/xfrm4_mode_beet.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/xfrm4_mode_transport.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/xfrm4_mode_tunnel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/xfrm4_tunnel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/ah6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/esp6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/mip6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/netfilter/ip6table_raw.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/netfilter/nf_conntrack_ipv6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/sit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/tunnel6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/xfrm6_mode_beet.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/xfrm6_mode_ro.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/xfrm6_mode_transport.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/xfrm6_mode_tunnel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv6/xfrm6_tunnel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipx/ipx.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/key/af_key.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_dh.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_ftp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_lblc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_lblcr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_lc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_nq.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_rr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_sed.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_sh.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_wlc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/ipvs/ip_vs_wrr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nf_conntrack.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nf_conntrack_netlink.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nf_conntrack_proto_gre.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nf_conntrack_proto_udplite.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/netfilter/nfnetlink.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/packet/af_packet.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/cls_basic.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/cls_fw.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/cls_route.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/cls_rsvp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/cls_rsvp6.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/cls_tcindex.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/cls_u32.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/em_cmp.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/em_meta.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/em_nbyte.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/em_text.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/em_u32.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_atm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_cbq.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_drr.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_dsmark.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_gred.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_hfsc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_htb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_ingress.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_multiq.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_netem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_prio.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_red.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_sfq.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_tbf.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sched/sch_teql.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sunrpc/auth_gss/auth_rpcgss.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sunrpc/auth_gss/rpcsec_gss_krb5.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sunrpc/auth_gss/rpcsec_gss_spkm3.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/sunrpc/sunrpc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/unix/unix.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/wanrouter/wanrouter.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/xfrm/xfrm_user.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kobject/kobject-example.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kobject/kset-example.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kprobes/jprobe_example.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kprobes/kprobe_example.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kprobes/kretprobe_example.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/ac97_bus.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/oss/ad1848.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/oss/mpu401.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/oss/opl3.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/oss/pas2.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/oss/sb_lib.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/oss/sscape.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/oss/trix.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/oss/uart401.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/oss/uart6850.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/oss/v_midi.o
WARNING: modpost: missing MODULE_DESCRIPTION() in sound/sound_firmware.o



-- 
~Randy
