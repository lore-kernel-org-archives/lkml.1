Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0BBIUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:20:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:63563 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730Ab0BBIUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:20:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,389,1262592000"; 
   d="scan'208";a="536840299"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Cc: xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org
Subject: 
Date: Tue,  2 Feb 2010 16:19:01 +0800
Message-Id: <1265098747-10117-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jeremy & Keir

Here is the second version of patchset to enable Xen Hybrid extension support
in Linux kernel.

The Hybrid Extension is started from real mode like HVM guest, but also with a
a range of PV features(e.g. PV halt, PV timer, event channel, as well as PV
drivers). So guest with Hybrid extension feature can takes the advantages of
both H/W virtualization and Para-Virtualization.

The first two of the patchset imported several header file from Jeremy's tree
and Xen tree, respect to Jeremy and Keir's works.

The whole patchset based on Linux upstream.

Current the patchset support x86_64 only.

The major change from v1:
1. SMP support.
2. Modify the entrance point to avoid most of genernic kernel modification.
3. Binding PV timer with event channel mechanism.

You need a line like:

cpuid = [ '0x40000002:edx=0x3' ]

in HVM configuration file to expose hybrid feature to guest, and

CONFIG_XEN

in the guest kernel configuration file to enable the hybrid support.

And the compiled image can be used as native/pv domU/hvm guest/hybrid kernel.

Comments are welcome!

BTW: For the MSI/MSI-X support, pv_ops dom0 can share the solution with hybrid.
We would try to figure out a elegant way to deal with it later.

--
regards
Yang, Sheng

--
 arch/x86/include/asm/xen/cpuid.h     |   73 +++++++++++++
 arch/x86/include/asm/xen/hypercall.h |    6 +
 arch/x86/kernel/setup.c              |    8 ++
 arch/x86/xen/enlighten.c             |  192 ++++++++++++++++++++++++++++++++++
 arch/x86/xen/irq.c                   |   54 ++++++++++
 arch/x86/xen/smp.c                   |  144 +++++++++++++++++++++++++-
 arch/x86/xen/xen-head.S              |    6 +
 arch/x86/xen/xen-ops.h               |    4 +
 drivers/block/xen-blkfront.c         |    3 +
 drivers/input/xen-kbdfront.c         |    4 +
 drivers/net/xen-netfront.c           |    3 +
 drivers/video/xen-fbfront.c          |    4 +
 drivers/xen/events.c                 |   66 +++++++++++-
 drivers/xen/grant-table.c            |   67 ++++++++++++-
 drivers/xen/xenbus/xenbus_probe.c    |   23 ++++-
 include/xen/events.h                 |    1 +
 include/xen/hvm.h                    |   28 +++++
 include/xen/interface/hvm/hvm_op.h   |   79 ++++++++++++++
 include/xen/interface/hvm/params.h   |  111 ++++++++++++++++++++
 include/xen/interface/xen.h          |    6 +-
 include/xen/xen.h                    |   12 ++
 21 files changed, 883 insertions(+), 11 deletions(-)

