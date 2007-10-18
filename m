Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbXJRUcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbXJRUcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbXJRUb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:31:57 -0400
Received: from smtp115.sbc.mail.re3.yahoo.com ([66.196.96.88]:45455 "HELO
	smtp115.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755454AbXJRUb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:31:56 -0400
X-YMail-OSG: VM97TNoVM1lEluH6ynM4d2w8q3mP.02vwlF9epoSWUe2YT2U2VvrhKCJB3eYTDOC1aEQ8GwpVwAM5RDPg5qDFrcsn0TTxzCrGt4jDe4NlZR3DseB8DHFVYqVVZN3C0UPro8Oj5TQQ_E2_w--
Date: Thu, 18 Oct 2007 15:31:51 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, cornelia.huck@de.ibm.com,
       heiko.carstens@de.ibm.com, sam@ravnborg.org, schwidefsky@de.ibm.com
Subject: Re: 2.6.23-mm1 s390 driver problem
Message-ID: <20071018203151.GA15382@vino.hallyn.com>
References: <20071018200148.GA14234@vino.hallyn.com> <200710182215.56428.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710182215.56428.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Christian Borntraeger (borntraeger@de.ibm.com):
> Am Donnerstag, 18. Oktober 2007 schrieb Serge E. Hallyn:
> > Sigh, well this turned out less informative than I'd liked.
> > After bisecting 2.6.23 to 2.6.23-mm1, I found that
> > git-s390.patch is the one breaking my s390 boot :(
> > (Frown bc it's a conglomeration of patches0
> > 
> > Symptom is:
> > 	"Cannot open root device "dasdd2" or unknown-block(94,14)"
> > even though dasdd2 appeared to be found earlier in the boot.  I also
> > get
> 
> Can you post the full console output from IPL to the unsuccessful end?

Yeah, sorry, appended below.

I had thought that the line
	sysctl table check failed: /sunrpc/transports .7249.14 Missing strategy
meant that the fix referenced in http://lkml.org/lkml/2007/10/11/48
would fix it, but it appeared to have no effect.

thanks,
-serge

========================================================================
========================================================================

Linux version 2.6.23-mm1-g7692ccd6 (hallyn@elg11.watson.ibm.com) (gcc version 3.
4.2 20040907 (Red Hat 3.4.2-1)) #314 SMP PREEMPT Thu Oct 18 16:27:04 EDT 2007
We are running under VM (64 bit mode)
Detected 2 CPU's
Boot cpu address  0
Zone PFN ranges:
  DMA             0 ->   524288
  Normal     524288 ->   524288
Movable zone start PFN for each node
early_node_mapÝ1¨ active PFN ranges
    0:        0 ->    65535
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 63872
Kernel command line: dasd=0.0.0201,0.0.0202,0.0.0250,0.0.0251 mem=256M root=/dev
/dasdd2 ro           noinitrd
PID hash table entries: 1024 (order: 10, 8192 bytes)
console ÝttyS0¨ enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1712 kB
 per task-struct memory footprint: 2160 bytes
Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
Memory: 243712k/262144k available (3217k kernel code, 0k reserved, 1651k data, 5
76k init)
Write protected kernel read-only data: 0x12000 - 0x477fff
Mount-cache hash table entries: 256
cpu 0 phys_idx=0 vers=FF ident=0210BC machine=2084 unused=8000
cpu 1 phys_idx=1 vers=FF ident=0210BC machine=2084 unused=8000
Brought up 2 CPUs
net_namespace: 152 bytes
NET: Registered protocol family 16
debug: Initialization complete
SCSI subsystem initialized
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
00000000fffffffe 0000000000000002 0000000000000000 00000000015afc10
       00000000015afb88 00000000003c09d6 00000000003c09d6 0000000000014ef2
       0000000000000000 0000000000000002 0000000000486040 0000000000000000
       0000000000000000 000000000000000d 00000000015afb70 00000000015afbe8
       0000000000329368 0000000000014ef2 00000000015afb70 00000000015afbc0
Call Trace:
(Ý<0000000000014e24>¨ show_trace+0x9c/0xd0)
 Ý<0000000000014f10>¨ show_stack+0xb8/0xc8
 Ý<0000000000014f4e>¨ dump_stack+0x2e/0x3c
 Ý<000000000005c3d4>¨ __lock_acquire+0x21c/0x1010
 Ý<000000000005d4f0>¨ lock_acquire+0x98/0xc0
 Ý<00000000000499e2>¨ run_workqueue+0x13e/0x240
 Ý<0000000000049ba4>¨ worker_thread+0xc0/0xd8
 Ý<000000000004faf0>¨ kthread+0x68/0xa0
 Ý<0000000000018f66>¨ kernel_thread_starter+0x6/0xc
 Ý<0000000000018f60>¨ kernel_thread_starter+0x0/0xc

INFO: lockdep is turned off.
Time: tod clocksource has been installed.
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 2, 16384 bytes)
TCP established hash table entries: 8192 (order: 7, 589824 bytes)
TCP bind hash table entries: 8192 (order: 7, 589824 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
audit: initializing netlink socket (disabled)
audit(1192739358.161:1): initialized
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
nbd: registered device at major 43
Ethernet Channel Bonding Driver: v3.1.3 (June 13, 2007)
bonding: Warning: either miimon or arp_interval and arp_ip_target module paramet
ers must be specified, otherwise bonding will not detect link failures! see bond
ing.txt for details.
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com
)
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
st: Version 20070203, fixed bufsize 32768, s/g segs 256
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: multipath personality registered for level -4
cio: Channel measurement facility using extended format (autodetected)
qdio: loading QDIO base support version 2
dasd(eckd): 0.0.0250: 3390/0C(CU:3990/01) Cyl:10016 Head:15 Sec:224
dasd(eckd): 0.0.0250: (4kB blks): 7211520kB at 48kB/trk compatible disk layout
 dasdc:VOL1/  0X0250: dasdc1
dasd(eckd): 0.0.0251: 3390/0C(CU:3990/01) Cyl:10016 Head:15 Sec:224
dasd(eckd): 0.0.0251: (4kB blks): 7211520kB at 48kB/trk compatible disk layout
 dasdd:VOL1/  ES2612: dasdd1 dasdd2
dasd(eckd): 0.0.0201: 3390/0C(CU:3990/01) Cyl:50 Head:15 Sec:224
dasd(eckd): 0.0.0201: (4kB blks): 36000kB at 48kB/trk linux disk layout
 dasda:CMS1/  SCRTCH: dasda1
dasd(eckd): 0.0.0202: 3390/0C(CU:3990/01) Cyl:200 Head:15 Sec:224
dasd(eckd): 0.0.0202: (4kB blks): 144000kB at 48kB/trk linux disk layout
 dasdb:CMS1/  SCRTCH: dasdb1
xpram error:expanded storage lost!
xpram warning:No expanded memory available
cpi: no system name specified
TAPE_CHAR: tape gets major 254 for character devices
TAPE_BLOCK: tape gets major 253 for block device
vmur: z/VM virtual unit record device driver loaded.
CTC driver initialized
 lcs: Loading LCS driver
qeth: loading qeth S/390 OSA-Express driver
u32 classifier
    Actions configured
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
sysctl table check failed: /sunrpc/transports .7249.14 Missing strategy
sysctl table check failed: /sunrpc/transports .7249.14 Unknown sysctl binary pat
h
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
VFS: Cannot open root device "dasdd2" or unknown-block(94,14)
Please append a correct "root=" boot option; here are the available partitions:
5e08    7211520 dasdc driver: dasd-eckd
  5e09    7211424 dasdc1
5e0c    7211520 dasdd driver: dasd-eckd
  5e0d     262128 dasdd1
  5e0e    6949296 dasdd2
5e00      36000 dasda driver: dasd-eckd
  5e01      35988 dasda1
5e04     144000 dasdb driver: dasd-eckd
  5e05     143988 dasdb1
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(94,14)

00: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
 CPU 01.
01: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 004C72F8
