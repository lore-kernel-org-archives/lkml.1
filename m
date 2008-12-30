Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbYL3Kca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbYL3Kca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 05:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYL3KcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 05:32:20 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:34950 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYL3KcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 05:32:18 -0500
Date: Tue, 30 Dec 2008 11:33:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       janitors <kernel-janitors@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Many warnings from our userspace headers
Message-ID: <20081230103348.GA363@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have added a few additional validation checks of
the userspace headers:

1) extern definitions does not make sense in userspace
2) CONFIG_ symbols should not be exposed to userspace
3) We should include <linux/types.h> and not /asm/types.h>
4) If we use a __[us]{8,16,32,64} type then we must include
   <linux/types.h>

Needless to say this resulted in a high number of hits.
See the full list below for a "make heades_check on a i386 box.

Several of these are easy fixable..

You need the latest kbuild-next to see the warnings.

	Sam

  CHECK   include/asm-generic (12 files)
/home/sam/kernel/knext.git/usr/include/asm-generic/fcntl.h:127: leaks CONFIG_64BIT to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm-generic/fcntl.h:149: leaks CONFIG_64BIT to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm-generic/int-l64.h:17: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/asm-generic/int-ll64.h:17: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/drm (11 files)
  CHECK   include/linux/byteorder (4 files)
/home/sam/kernel/knext.git/usr/include/linux/byteorder/swab.h:61: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/can (3 files)
/home/sam/kernel/knext.git/usr/include/linux/can/bcm.h:29: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/dvb (8 files)
/home/sam/kernel/knext.git/usr/include/linux/dvb/audio.h:133: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/dvb/dmx.h:27: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/dvb/dmx.h:90: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/dvb/frontend.h:29: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/dvb/frontend.h:75: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/dvb/net.h:27: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/dvb/net.h:31: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/dvb/video.h:29: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/dvb/video.h:102: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/hdlc (1 files)
  CHECK   include/linux/isdn (1 files)
  CHECK   include/linux/netfilter (49 files)
/home/sam/kernel/knext.git/usr/include/linux/netfilter/xt_conntrack.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/netfilter_arp (2 files)
  CHECK   include/linux/netfilter_bridge (16 files)
  CHECK   include/linux/netfilter_ipv4 (46 files)
  CHECK   include/linux/netfilter_ipv6 (20 files)
  CHECK   include/linux/nfsd (6 files)
/home/sam/kernel/knext.git/usr/include/linux/nfsd/export.h:13: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/nfsd/nfsfh.h:17: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/nfsd/nfsfh.h:28: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/nfsd/stats.h:32: leaks CONFIG_NFSD to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/nfsd/syscall.h:12: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/nfsd/syscall.h:104: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/raid (2 files)
/home/sam/kernel/knext.git/usr/include/linux/raid/md_p.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/spi (1 files)
/home/sam/kernel/knext.git/usr/include/linux/spi/spidev.h:83: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/sunrpc (1 files)
  CHECK   include/linux/tc_act (6 files)
/home/sam/kernel/knext.git/usr/include/linux/tc_act/tc_gact.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/tc_act/tc_mirred.h:16: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/tc_act/tc_pedit.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/tc_ematch (4 files)
/home/sam/kernel/knext.git/usr/include/linux/tc_ematch/tc_em_cmp.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/tc_ematch/tc_em_meta.h:18: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/tc_ematch/tc_em_nbyte.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/tc_ematch/tc_em_text.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux/usb (8 files)
/home/sam/kernel/knext.git/usr/include/linux/usb/cdc.h:50: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/usb/gadgetfs.h:21: include of <linux/types.h> is preferred over <asm/types.h>
  CHECK   include/linux (351 files)
/home/sam/kernel/knext.git/usr/include/linux/acct.h:62: leaks CONFIG_M68K to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/agpgart.h:54: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/aio_abi.h:58: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/atalk.h:15: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/atm_idt77105.h:10: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/atm_idt77105.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/atmbr2684.h:88: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/atmdev.h:103: leaks CONFIG_COMPAT to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/auto_fs4.h:78: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/bfs_fs.h:24: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/blktrace_api.h:96: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/capability.h:72: leaks CONFIG_SECURITY to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/capability.h:73: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/capi.h:15: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/capi.h:24: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/cdrom.h:155: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/cgroupstats.h:31: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/cm4000_cs.h:22: leaks CONFIG_COMPAT to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/coda_psdev.h:90: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/connector.h:25: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/connector.h:57: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/cyclades.h:153: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/dlm_plock.h:25: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/dn.h:75: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/edd.h:70: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/efs_fs_sb.h:49: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/elf-fdpic.h:61: leaks CONFIG_MMU to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/elf-fdpic.h:62: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/elf.h:379: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/elf.h:387: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/elf.h:401: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/elf.h:402: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/elfcore.h:59: leaks CONFIG_BINFMT to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/errqueue.h:6: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/fb.h:4: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/fb.h:152: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/fb.h:381: leaks CONFIG_FB to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/flat.h:16: leaks CONFIG_BINFMT to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/fs.h:24: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/fs.h:41: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/fs.h:42: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/fs.h:49: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/fs.h:51: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/fs.h:53: leaks CONFIG_DNOTIFY to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/fs.h:54: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/fuse.h:28: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/fuse.h:50: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/genetlink.h:12: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/gfs2_ondisk.h:109: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/hid.h:66: leaks CONFIG_HID to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/hid.h:74: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/hiddev.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/icmpv6.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_addr.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_addrlabel.h:15: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_fc.h:37: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_frad.h:29: leaks CONFIG_DLCI to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/if_frad.h:129: leaks CONFIG_DLCI to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/if_hippi.h:82: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_link.h:9: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_ppp.h:96: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_pppol2tp.h:18: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_pppol2tp.h:32: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_pppox.h:20: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_pppox.h:105: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_strip.h:22: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/if_tr.h:37: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/igmp.h:31: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/in6.h:47: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/in6.h:49: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/inet_diag.h:16: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/input.h:15: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/input.h:23: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/ip6_tunnel.h:21: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/ipv6.h:26: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/ipv6_route.h:42: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/ipx.h:13: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/irda.h:127: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/joystick.h:30: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/joystick.h:48: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/kernel.h:39: leaks CONFIG_NUMA to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/kernel.h:40: leaks CONFIG_NUMA to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/kernel.h:46: leaks CONFIG_FTRACE to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/kernel.h:47: leaks CONFIG_FTRACE to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/kvm.h:10: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/kvm.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/kvm.h:61: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/kvm.h:64: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/kvm.h:386: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/loop.h:27: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/loop.h:27: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/matroxfb.h:5: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/matroxfb.h:9: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/minix_fs.h:34: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/msdos_fs.h:100: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/neighbour.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/nfs_idmap.h:55: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/nubus.h:232: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/nubus.h:296: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/nubus.h:298: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/nubus.h:302: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/phantom.h:13: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/phantom.h:17: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/phonet.h:50: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/pkt_cls.h:122: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/pkt_cls.h:306: leaks CONFIG_NET to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/pkt_cls.h:307: leaks CONFIG_NET to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/pkt_sched.h:32: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/pktcdvd.h:36: leaks CONFIG_CDROM to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/ppp_defs.h:50: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/qnx4_fs.h:59: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/qnxtypes.h:16: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/radeonfb.h:5: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/random.h:38: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/raw.h:16: leaks CONFIG_MAX to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:64: leaks CONFIG_REISERFS to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:81: leaks CONFIG_REISERFS to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:687: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:995: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:997: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1467: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1587: leaks CONFIG_QUOTA to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1760: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1764: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1766: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1769: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1771: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1805: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1908: leaks CONFIG_PROC to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1948: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1949: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1950: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1951: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1962: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1963: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/reiserfs_fs.h:1964: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/rtnetlink.h:328: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/serial.h:164: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/signalfd.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/socket.h:27: leaks CONFIG_PROC to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/socket.h:29: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/socket.h:262: leaks CONFIG_COMPAT to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/sound.h:33: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/sound.h:34: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/sound.h:35: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/sound.h:36: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/sound.h:37: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/sound.h:39: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/sound.h:40: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/sound.h:41: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/sound.h:42: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1047: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1048: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1049: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1050: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1051: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1053: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1055: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1056: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1061: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1062: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1078: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/soundcard.h:1079: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/linux/synclink.h:209: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/taskstats.h:44: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/types.h:6: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/linux/types.h:10: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/types.h:112: leaks CONFIG_LBD to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/types.h:121: leaks CONFIG_LSF to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/video_decoder.h:7: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/video_encoder.h:5: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/videodev.h:18: leaks CONFIG_VIDEO to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/videodev.h:53: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/videodev.h:313: leaks CONFIG_VIDEO to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/videodev2.h:1448: leaks CONFIG_VIDEO to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/linux/virtio_blk.h:21: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/linux/virtio_net.h:28: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/mtd (6 files)
/home/sam/kernel/knext.git/usr/include/mtd/inftl-user.h:61: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/mtd/jffs2-user.h:20: extern's make no sense in userspace
  CHECK   include/rdma (1 files)
  CHECK   include/sound (9 files)
/home/sam/kernel/knext.git/usr/include/sound/hdsp.h:33: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/video (3 files)
/home/sam/kernel/knext.git/usr/include/video/edid.h:4: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/video/sisfb.h:25: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/video/sisfb.h:78: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/video/uvesafb.h:5: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include (0 files)
  CHECK   include/asm (51 files)
/home/sam/kernel/knext.git/usr/include/asm/boot.h:14: leaks CONFIG_PHYSICAL to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/boot.h:15: leaks CONFIG_PHYSICAL to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/boot.h:16: leaks CONFIG_PHYSICAL to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/boot.h:18: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/byteorder.h:4: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/asm/byteorder.h:9: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/asm/byteorder.h:12: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/byteorder.h:42: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/e820.h:13: leaks CONFIG_NODES to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/e820.h:27: leaks CONFIG_EFI to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/e820.h:44: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/asm/kvm.h:9: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/asm/kvm.h:16: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/asm/mce.h:7: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/asm/mce.h:29: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/asm/prctl.h:9: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/prctl.h:10: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/asm/prctl.h:11: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/ptrace-abi.h:83: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/ptrace-abi.h:86: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/asm/ptrace-abi.h:93: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/asm/ptrace-abi.h:143: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/setup.h:15: leaks CONFIG_X86 to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/setup.h:16: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/asm/setup.h:17: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/asm/setup.h:23: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/asm/setup.h:24: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/asm/setup.h:51: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/asm/setup.h:52: extern's make no sense in userspace
/home/sam/kernel/knext.git/usr/include/asm/setup.h:54: leaks CONFIG_PARAVIRT to userspace where it is not valid
/home/sam/kernel/knext.git/usr/include/asm/sigcontext.h:5: include of <linux/types.h> is preferred over <asm/types.h>
/home/sam/kernel/knext.git/usr/include/asm/sigcontext.h:24: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/sam/kernel/knext.git/usr/include/asm/sigcontext32.h:20: found __[us]{8,16,32,64} type without #include <linux/types.h>
