Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZBEGht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZBEGht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 01:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZBEGhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 01:37:40 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:6899 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZBEGhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 01:37:38 -0500
X-IronPort-AV: E=Sophos;i="4.37,383,1231113600"; 
   d="scan'208";a="138087379"
From: Roland Dreier <rdreier@cisco.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Floris Kraak <randakar@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	<20090204221451.GA27254@uranus.ravnborg.org>
	<adavdrplty2.fsf@cisco.com> <498A295A.4090008@gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 04 Feb 2009 22:37:32 -0800
In-Reply-To: <498A295A.4090008@gmail.com> (Robert Hancock's message of "Wed,
	04 Feb 2009 17:48:42 -0600")
Message-ID: <adaskmtjsnn.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Feb 2009 06:37:35.0497 (UTC) FILETIME=[3B187790:01C9875C]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Just how many of these warnings are showing up? In the cases you
 > posted it's presumably no problem, but if the string could either a)
 > be potentially set by a malicious user or b) accidentally contain
 > printk format characters then this code has a risk that things could
 > blow up..

I get ~150 of them on an x86 allyesconfig build here (see below).  Many
but not all are trivial; some at least appear to be passing in strings
that come from random hardware/firmware or DNS names etc (ie there's at
least a chance of a '%'); and I didn't exhaustively audit to make sure
none of them could print something from an unprivileged user.

init/main.c:557: warning: format not a string literal and no format arguments
init/initramfs.c:582: warning: format not a string literal and no format arguments
arch/x86/kernel/dumpstack.c:115: warning: format not a string literal and no format arguments
arch/x86/kernel/dumpstack.c:137: warning: format not a string literal and no format arguments
arch/x86/kernel/e820.c:1177: warning: format not a string literal and no format arguments
arch/x86/kernel/e820.c:1178: warning: format not a string literal and no format arguments
arch/x86/kernel/cpu/mcheck/mce_64.c:149: warning: format not a string literal and no format arguments
kernel/power/main.c:717: warning: format not a string literal and no format arguments
kernel/cpuset.c:2447: warning: format not a string literal and no format arguments
fs/gfs2/glock.c:901: warning: format not a string literal and no format arguments
fs/gfs2/locking.c:180: warning: format not a string literal and no format arguments
fs/lockd/svc.c:303: warning: format not a string literal and no format arguments
fs/nfs/nfs4proc.c:2929: warning: format not a string literal and no format arguments
fs/partitions/check.c:455: warning: format not a string literal and no format arguments
fs/reiserfs/prints.c:292: warning: format not a string literal and no format arguments
fs/ubifs/super.c:425: warning: format not a string literal and no format arguments
fs/ubifs/super.c:1204: warning: format not a string literal and no format arguments
fs/ubifs/super.c:1557: warning: format not a string literal and no format arguments
fs/dquot.c:175: warning: format not a string literal and no format arguments
fs/dquot.c:175: warning: format not a string literal and no format arguments
fs/dquot.c:175: warning: format not a string literal and no format arguments
crypto/api.c:218: warning: format not a string literal and no format arguments
crypto/algapi.c:427: warning: format not a string literal and no format arguments
crypto/cryptd.c:547: warning: format not a string literal and no format arguments
drivers/atm/iphase.c:982: warning: format not a string literal and no format arguments
drivers/base/core.c:1250: warning: format not a string literal and no format arguments
drivers/base/sys.c:140: warning: format not a string literal and no format arguments
drivers/base/platform.c:247: warning: format not a string literal and no format arguments
drivers/base/attribute_container.c:170: warning: format not a string literal and no format arguments
drivers/base/firmware_class.c:318: warning: format not a string literal and no format arguments
drivers/block/nbd.c:657: warning: format not a string literal and no format arguments
drivers/block/aoe/aoechr.c:289: warning: format not a string literal and no format arguments
drivers/cdrom/cdrom.c:3379: warning: format not a string literal and no format arguments
drivers/char/mem.c:994: warning: format not a string literal and no format arguments
drivers/char/tty_io.c:2850: warning: format not a string literal and no format arguments
drivers/char/hw_random/intel-rng.c:315: warning: format not a string literal and no format arguments
drivers/char/riscom8.c:1500: warning: format not a string literal and no format arguments
drivers/char/riscom8.c:1510: warning: format not a string literal and no format arguments
drivers/char/n_hdlc.c:945: warning: format not a string literal and no format arguments
drivers/char/n_hdlc.c:968: warning: format not a string literal and no format arguments
drivers/cpufreq/cpufreq.c:244: warning: format not a string literal and no format arguments
drivers/hwmon/adt7470.c:1294: warning: format not a string literal and no format arguments
drivers/ide/ide-probe.c:650: warning: format not a string literal and no format arguments
drivers/ide/ide-probe.c:664: warning: format not a string literal and no format arguments
drivers/infiniband/core/sysfs.c:781: warning: format not a string literal and no format arguments
drivers/infiniband/hw/ipath/ipath_file_ops.c:2452: warning: format not a string literal and no format arguments
drivers/infiniband/hw/ipath/ipath_file_ops.c:2462: warning: format not a string literal and no format arguments
drivers/input/mousedev.c:881: warning: format not a string literal and no format arguments
drivers/input/joydev.c:803: warning: format not a string literal and no format arguments
drivers/input/evdev.c:822: warning: format not a string literal and no format arguments
drivers/input/tablet/aiptek.c:1373: warning: format not a string literal and no format arguments
drivers/isdn/mISDN/dsp_pipeline.c:104: warning: format not a string literal and no format arguments
drivers/media/video/v4l2-common.c:558: warning: format not a string literal and no format arguments
drivers/media/video/v4l2-common.c:723: warning: format not a string literal and no format arguments
drivers/media/video/v4l2-common.c:741: warning: format not a string literal and no format arguments
drivers/media/video/pvrusb2/pvrusb2-hdw.c:1970: warning: format not a string literal and no format arguments
drivers/media/video/pvrusb2/pvrusb2-std.c:219: warning: format not a string literal and no format arguments
drivers/media/video/zoran/zoran_card.c:1421: warning: format not a string literal and no format arguments
drivers/media/video/zoran/zoran_card.c:1441: warning: format not a string literal and no format arguments
drivers/media/video/zoran/zoran_card.c:1465: warning: format not a string literal and no format arguments
drivers/media/video/zoran/zoran_card.c:1477: warning: format not a string literal and no format arguments
drivers/media/video/tvaudio.c:1916: warning: format not a string literal and no format arguments
drivers/media/video/cx2341x.c:474: warning: format not a string literal and no format arguments
drivers/misc/enclosure.c:122: warning: format not a string literal and no format arguments
drivers/misc/enclosure.c:259: warning: format not a string literal and no format arguments
drivers/mtd/chips/gen_probe.c:215: warning: format not a string literal and no format arguments
drivers/mtd/ubi/build.c:851: warning: format not a string literal and no format arguments
drivers/net/hamradio/mkiss.c:994: warning: format not a string literal and no format arguments
drivers/net/hamradio/mkiss.c:997: warning: format not a string literal and no format arguments
drivers/net/hamradio/6pack.c:800: warning: format not a string literal and no format arguments
drivers/net/hamradio/yam.c:1117: warning: format not a string literal and no format arguments
drivers/net/hamradio/bpqether.c:617: warning: format not a string literal and no format arguments
drivers/net/pcmcia/axnet_cs.c:1716: warning: format not a string literal and no format arguments
drivers/net/phy/mdio_bus.c:101: warning: format not a string literal and no format arguments
drivers/net/tulip/dmfe.c:378: warning: format not a string literal and no format arguments
drivers/net/tulip/dmfe.c:2191: warning: format not a string literal and no format arguments
drivers/net/tulip/winbond-840.c:1666: warning: format not a string literal and no format arguments
drivers/net/tulip/de4x5.c:1268: warning: format not a string literal and no format arguments
drivers/net/tulip/uli526x.c:277: warning: format not a string literal and no format arguments
drivers/net/tulip/uli526x.c:1819: warning: format not a string literal and no format arguments
drivers/net/wan/lapbether.c:441: warning: format not a string literal and no format arguments
drivers/net/wireless/b43/main.c:2008: warning: format not a string literal and no format arguments
drivers/net/wireless/b43/main.c:2010: warning: format not a string literal and no format arguments
drivers/net/wireless/hostap/hostap_ioctl.c:3272: warning: format not a string literal and no format arguments
drivers/net/wireless/ipw2x00/libipw_wx.c:611: warning: format not a string literal and no format arguments
drivers/net/wireless/airo.c:1887: warning: format not a string literal and no format arguments
drivers/net/rrunner.c:137: warning: format not a string literal and no format arguments
drivers/net/3c59x.c:1018: warning: format not a string literal and no format arguments
drivers/net/3c59x.c:2886: warning: format not a string literal and no format arguments
drivers/net/ne2k-pci.c:234: warning: format not a string literal and no format arguments
drivers/net/sis900.c:428: warning: format not a string literal and no format arguments
drivers/net/yellowfin.c:393: warning: format not a string literal and no format arguments
drivers/net/acenic.c:503: warning: format not a string literal and no format arguments
drivers/net/natsemi.c:816: warning: format not a string literal and no format arguments
drivers/net/fealnx.c:506: warning: format not a string literal and no format arguments
drivers/net/via-rhine.c:655: warning: format not a string literal and no format arguments
drivers/net/starfire.c:685: warning: format not a string literal and no format arguments
drivers/net/sundance.c:489: warning: format not a string literal and no format arguments
drivers/net/hamachi.c:604: warning: format not a string literal and no format arguments
drivers/net/forcedeth.c:926: warning: format not a string literal and no format arguments
drivers/net/defxx.c:534: warning: format not a string literal and no format arguments
drivers/net/eql.c:587: warning: format not a string literal and no format arguments
drivers/scsi/aacraid/commctrl.c:320: warning: format not a string literal and no format arguments
drivers/scsi/aacraid/commsup.c:1223: warning: format not a string literal and no format arguments
drivers/scsi/sd.c:1833: warning: format not a string literal and no format arguments
drivers/scsi/advansys.c:2899: warning: format not a string literal and no format arguments
drivers/scsi/sg.c:2540: warning: format not a string literal and no format arguments
drivers/serial/serial_core.c:1758: warning: format not a string literal and no format arguments
drivers/usb/atm/usbatm.c:1034: warning: format not a string literal and no format arguments
drivers/usb/atm/usbatm.c:1089: warning: format not a string literal and no format arguments
drivers/usb/storage/libusual.c:190: warning: format not a string literal and no format arguments
drivers/uwb/lc-dev.c:440: warning: format not a string literal and no format arguments
drivers/video/backlight/lcd.c:211: warning: format not a string literal and no format arguments
drivers/video/backlight/backlight.c:247: warning: format not a string literal and no format arguments
drivers/video/output.c:99: warning: format not a string literal and no format arguments
drivers/xen/xenbus/xenbus_probe.c:510: warning: format not a string literal and no format arguments
sound/sound_core.c:225: warning: format not a string literal and no format arguments
sound/core/sound.c:91: warning: format not a string literal and no format arguments
sound/core/seq/seq_clientmgr.c:2449: warning: format not a string literal and no format arguments
sound/drivers/opl3/opl3_seq.c:238: warning: format not a string literal and no format arguments
sound/pci/rme32.c:1473: warning: format not a string literal and no format arguments
sound/pci/rme96.c:1673: warning: format not a string literal and no format arguments
sound/pci/hda/hda_codec.c:600: warning: format not a string literal and no format arguments
sound/pci/korg1212/korg1212.c:2062: warning: format not a string literal and no format arguments
net/802/psnap.c:106: warning: format not a string literal and no format arguments
net/appletalk/ddp.c:1894: warning: format not a string literal and no format arguments
net/core/net-sysfs.c:499: warning: format not a string literal and no format arguments
net/decnet/af_decnet.c:2377: warning: format not a string literal and no format arguments
net/ipv4/ipip.c:836: warning: format not a string literal and no format arguments
net/ipx/af_ipx.c:2002: warning: format not a string literal and no format arguments
net/ipx/af_ipx.c:2008: warning: format not a string literal and no format arguments
net/ipx/af_ipx.c:2012: warning: format not a string literal and no format arguments
net/ipx/af_ipx.c:2016: warning: format not a string literal and no format arguments
net/llc/af_llc.c:1140: warning: format not a string literal and no format arguments
net/llc/af_llc.c:1145: warning: format not a string literal and no format arguments
net/llc/af_llc.c:1150: warning: format not a string literal and no format arguments
net/netfilter/nf_conntrack_proto_dccp.c:450: warning: format not a string literal and no format arguments
net/netfilter/nf_conntrack_proto_dccp.c:596: warning: format not a string literal and no format arguments
net/netfilter/ipvs/ip_vs_sync.c:876: warning: format not a string literal and no format arguments
net/sunrpc/svc.c:668: warning: format not a string literal and no format arguments
net/tipc/bcast.c:803: warning: format not a string literal and no format arguments
net/tipc/node.c:706: warning: format not a string literal and no format arguments
net/tipc/dbg.c:261: warning: format not a string literal and no format arguments
net/tipc/dbg.c:281: warning: format not a string literal and no format arguments
net/tipc/dbg.c:328: warning: format not a string literal and no format arguments
lib/kobject.c:797: warning: format not a string literal and no format arguments
