Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbYICRbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbYICRbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYICRbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:31:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:54627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbYICRbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:31:03 -0400
Date: Wed, 3 Sep 2008 10:24:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/42] 2.6.26-stable review
Message-ID: <20080903172447.GA7731@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.26.4 release.
There are 42 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by September 6 10:00:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.26.4-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team

 Makefile                           |    2 
 arch/sparc64/mm/init.c             |   30 ++++++++---
 arch/x86/kernel/cpu/cyrix.c        |   18 ------
 arch/x86/kernel/cpu/mtrr/generic.c |   20 ++++++-
 arch/x86/kvm/paging_tmpl.h         |    2 
 crypto/authenc.c                   |   10 ++-
 drivers/ata/sata_mv.c              |   34 +++----------
 drivers/char/random.c              |   19 +++----
 drivers/misc/eeepc-laptop.c        |    2 
 drivers/net/atlx/atl1.c            |    1 
 drivers/net/forcedeth.c            |    4 -
 drivers/net/r8169.c                |    2 
 drivers/net/tg3.c                  |   53 ++++++++++++++------
 drivers/net/tg3.h                  |    3 +
 drivers/pci/search.c               |    2 
 drivers/rtc/rtc-lib.c              |    5 +
 drivers/s390/block/dasd_eckd.h     |    2 
 drivers/serial/8250.c              |   16 ++++--
 drivers/serial/8250.h              |    1 
 drivers/usb/class/cdc-acm.c        |    2 
 drivers/video/fb_defio.c           |   19 +++++++
 drivers/video/fbmem.c              |    4 +
 fs/binfmt_misc.c                   |    4 -
 fs/bio.c                           |   48 ++++++++++++------
 fs/cifs/file.c                     |    4 +
 fs/cramfs/inode.c                  |   84 ++++++++++++++------------------
 fs/nfsd/nfs4acl.c                  |    2 
 include/linux/Kbuild               |    1 
 include/linux/fb.h                 |    3 +
 include/linux/mroute.h             |   25 ++++++++-
 include/linux/pim.h                |   45 -----------------
 include/net/addrconf.h             |    3 -
 include/net/ip6_route.h            |    1 
 mm/page_alloc.c                    |    7 ++
 net/ax25/sysctl_net_ax25.c         |   14 +----
 net/ipv4/udp.c                     |    6 +-
 net/ipv6/addrconf.c                |    3 -
 net/ipv6/fib6_rules.c              |    3 -
 net/ipv6/ip6_fib.c                 |    1 
 net/ipv6/ip6_output.c              |    2 
 net/ipv6/ndisc.c                   |    2 
 net/ipv6/route.c                   |   13 +++--
 net/ipv6/udp.c                     |    6 +-
 net/ipv6/xfrm6_policy.c            |    4 +
 net/sched/act_api.c                |    5 -
 net/sched/sch_htb.c                |   20 ++++---
 net/sched/sch_prio.c               |   16 ++++--
 net/sched/sch_tbf.c                |   11 ----
 net/sctp/auth.c                    |    7 ++
 net/sctp/endpointola.c             |    4 -
 net/sctp/ipv6.c                    |    3 -
 net/sctp/socket.c                  |   96 ++++++++++++++++++++++++++++---------
 net/sunrpc/sysctl.c                |   18 +-----
 net/xfrm/xfrm_state.c              |   32 ++++++++----
 sound/pci/oxygen/oxygen_mixer.c    |    5 +
 55 files changed, 438 insertions(+), 311 deletions(-)
