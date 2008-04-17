Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYDQDcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYDQDcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 23:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYDQDcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 23:32:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752177AbYDQDcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 23:32:04 -0400
Date: Wed, 16 Apr 2008 20:32:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.25
Message-ID: <alpine.LFD.1.00.0804162009080.2879@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been long promised, but there it is now. Special thanks to Ingo who 
found and fixed a nasty-looking regression that turned out to not be a 
regression at all, but an old bug that just had not been triggering as 
reliably before.

That said, that was just the last particular regression fix I was holding 
things up for, and it's not like there weren't a lot of other fixes too, 
they just didn't end up being the final things that triggered my 
particular worries.

The full changelog from 2.6.24 is 7.5M, with a 12MB compressed patch. Tons 
and tons has changed, but if you've been following the -rc releases, 
you'll already know about the big things. The changes from the last rc 
(-rc9) are fairly small and mostly pretty trivial, and the shortlog is 
appended.

So it's mostly one-liners, with some updates to drivers (net and usb) and 
to networking that are a bit larger (although a number of the driver 
updates are things like just new ID's etc).

For those of you who haven't followed -rc's, and want the more readable 
overview of what has changed since 2.6.24, I'd suggest the usual sites, 
notably http://kernelnewbies.org/.

And a reminder for git users: while the _full_ changelogs are huge and 
unwieldly and you easily lose sight of the big picture from just bring 
overwhelmed by the details, if you're interested in some particular 
subsystem, using "gitk v2.6.24.. <path-limiter>" is a good way to see what 
has changed in that particular area.

				Linus

---
Adrian Bunk (3):
      [libata] make ali_atapi_dma static
      sh64: add missing #include <asm/fpu.h>'s
      avr32 mustn't select HAVE_IDE

Alexey Dobriyan (1):
      fbdev: fix /proc/fb oops after module removal

Alexey Korolev (1):
      JFFS2 Fix of panics caused by wrong condition for hole frag creation in write_begin

Andrew Morton (2):
      sh: arch/sh/kernel/traps_32.c needs asm/fpu.h
      sh: export empty_zero_page

Atsushi Nemoto (2):
      macb: Call phy_disconnect on removing
      macb: Use semicolon instead of comma for statement

Ayaz Abdulla (1):
      forcedeth: mac address fix

Ben Dooks (3):
      spi: spi_s3c24xx driver must init completion
      spi: spi_s3c24xx must initialize bus_num
      spi: spi_s3c24xx must initialize num_chipselect

Ben Hutchings (1):
      [NET]: Fix kernel-doc for skb_segment

Carlos Corbacho (1):
      rfkill: Fix device type check when toggling states

Chuck Ebbert (1):
      acpi: bus: check once more for an empty list after locking it

David Howells (1):
      FRV: Correctly determine the address of an illegal instruction

David S. Miller (1):
      [IPV6]: Fix ipv6 address fetching in raw6_icmp_error().

Dmitri Vorobiev (1):
      Fix typos in Documentation/filesystems/seq_file.txt

Eric Dumazet (1):
      [SOCK] sk_stamp: should be initialized to ktime_set(-1L, 0)

Greg Kroah-Hartman (1):
      USB: remove broken usb-serial num_endpoints check

Gui Jianfeng (1):
      [SCTP]: Fix protocol violation when receiving an error lenght INIT-ACK

Herton Ronaldo Krzesinski (1):
      rtl8187: Add missing priv->vif assignments

Ingo Molnar (2):
      revert "sched: fix fair sleepers"
      mm: sparsemem memory_present() fix

Ivo van Doorn (2):
      Add rfkill to MAINTAINERS file
      Update rt2x00 MAINTAINERS entry

J. Bruce Fields (1):
      locks: fix possible infinite loop in fcntl(F_SETLKW) over nfs

James Cameron (1):
      USB: Obscure Maxon BP3-USB Device Support 16d8:6280 for option driver

Jan Kara (1):
      vfs: fix possible deadlock in ext2, ext3, ext4 when using xattrs

Jarek Poplawski (2):
      [NET_SCHED] cls_u32: refcounting fix for u32_delete()
      [NET_SCHED] sch_api: fix qdisc_tree_decrease_qlen() loop

Jeff Garzik (1):
      [libata] sata_svw: fix reversed port count

Jens Axboe (2):
      io context: increment task attachment count in ioc_task_link()
      block: update git url for blktrace

Joakim Tjernlund (1):
      ucc_geth: fix non-functional fixed phy support

Johannes Berg (1):
      mac80211: remove message on receiving unexpected unencrypted frames

KOSAKI Motohiro (1):
      add "Isolate" migratetype name to /proc/pagetypeinfo

Kay Sievers (5):
      mmc: fix platform driver hotplug/coldplug
      leds: fix platform driver hotplug/coldplug
      misc: fix platform driver hotplug/coldplug
      pcmcia: fix platform driver hotplug/coldplug
      serial: fix platform driver hotplug/coldplug

Krzysztof Halasa (1):
      Mark generic HDLC + PPP as broken.

Krzysztof Helt (1):
      acpi thermal trip points increased to 12

Kyle McMartin (1):
      [PARISC] fix signal trampoline cache flushing

Laurent Pinchart (1):
      fs_enet: Don't call NAPI functions when NAPI is not used.

Li Zefan (1):
      memcg: fix oops in oom handling

Linus Torvalds (2):
      Fix locking bug in "acquire_console_semaphore_for_printk()"
      Linux 2.6.25

Manuel Lauss (1):
      sh: fix compressed kernel build

Masakazu Mokuno (1):
      PS3: gelic: fix the oops on the broken IE returned from the hypervisor

Matthias Urlichs (1):
      USB: option.c: add more device IDs

Michael Buesch (2):
      ssb: Fix usage of struct device used for DMAing
      b43legacy: Fix usage of struct device used for DMAing

Michael Ellerman (1):
      netconsole: only set CON_PRINTBUFFER if the user specifies a netconsole

Nishanth Aravamudan (1):
      Documentation: correct overcommit caveat in hugetlbpage.txt

Oliver Hartkopp (1):
      [CAN]: Update documentation of struct sockaddr_can

Patrick McHardy (3):
      [DCCP]: Fix skb->cb conflicts with IP
      [NET]: Return more appropriate error from eth_validate_addr().
      [BRIDGE]: Fix crash in __ip_route_output_key with bridge netfilter

Paul Bolle (4):
      [ISDN]: Do not validate ISDN net device address prior to interface-up
      MAINTAINERS: isdn4linux@listserv.isdn4linux.de is subscribers-only
      AFS: Do not describe debug parameters with their value
      it821x: do not describe noraid parameter with its value

Pavel Emelyanov (3):
      [AX25]: Potential ax25_uid_assoc-s leaks on module unload.
      [SCTP]: IPv4 vs IPv6 addresses mess in sctp_inet[6]addr_event.
      [NETFILTER]: ipt_CLUSTERIP: fix race between clusterip_config_find_get and _entry_put

Reinette Chatre (1):
      MAINTAINERS: move to generic repository for iwlwifi

Rusty Russell (2):
      net: make struct tun_struct private to tun.c
      net: check for underlength tap writes

Sergei Shtylyov (4):
      tg3: fix MMIO for PPC 44x platforms
      Au1200: kill IDE driver function prototypes
      Au1200: IDE driver build fix
      Pb1200/DBAu1200: fix bad IDE resource size

Sonic Zhang (1):
      smc91x driver: fix bug: print warning only in interrupt mode

Stefano Brivio (2):
      b43legacy: fix initvals loading on bcm4303
      b43legacy: fix DMA mapping leakage

Stephen Hemminger (2):
      sky2: missing chip name for Yukon Supreme
      sc92031: sysfs link missing

Thomas Klein (1):
      ehea: Fix DLPAR memory add support

Vitaliy Gusev (2):
      [TCP]: Fix never pruned tcp out-of-order queue.
      [TCP]: Add return value indication to tcp_prune_ofo_queue().

Vlad Yasevich (1):
      [SCTP]: Fix compiler warning about const qualifiers

WANG Cong (1):
      uml: compile error fix

Wei Yongjun (1):
      [SCTP]: Add check for hmac_algo parameter in sctp_verify_param()

YOSHIFUJI Hideaki (4):
      [IPV6]: IPv6 extension header structures need to be packed.
      [IPV6]: Use appropriate sock tclass setting for routing lookup.
      [IPV6] ADDRCONF: Ensure disabling multicast RS even if privacy extensions are disabled.
      [IPV6] ADDRCONF: Don't generate temporary address for ip6-ip6 interface.

Zhao Yakui (1):
      rtc: fix the error in the function of cmos_set_alarm

fangxiaozhi (1):
      USB: support more Huawei data card product IDs

tang kai (1):
      USB: option: Add new vendor ID and device ID for AMOI HSDPA modem

yakui.zhao@intel.com (1):
      acpi: unneccessary to scan the PCI bus already scanned

