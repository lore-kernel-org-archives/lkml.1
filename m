Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab0BBI2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:28:18 -0500
Received: from mga06.intel.com ([134.134.136.21]:44768 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736Ab0BBI2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:28:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,389,1262592000"; 
   d="scan'208";a="592373244"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: xen-devel@lists.xensource.com
Subject: Re: [PATCH 0/6][v2] Hybrid extension for Xen guest
Date: Tue, 2 Feb 2010 16:26:44 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; x86_64; ; )
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, linux-kernel@vger.kernel.org
References: <1265098747-10117-1-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1265098747-10117-1-git-send-email-sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002021626.44958.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops... Miss the subject field when git-send-email...

-- 
regards
Yang, Sheng

On Tuesday 02 February 2010 16:19:01 Sheng Yang wrote:
> Hi, Jeremy & Keir
> 
> Here is the second version of patchset to enable Xen Hybrid extension
>  support in Linux kernel.
> 
> The Hybrid Extension is started from real mode like HVM guest, but also
>  with a a range of PV features(e.g. PV halt, PV timer, event channel, as
>  well as PV drivers). So guest with Hybrid extension feature can takes the
>  advantages of both H/W virtualization and Para-Virtualization.
> 
> The first two of the patchset imported several header file from Jeremy's
>  tree and Xen tree, respect to Jeremy and Keir's works.
> 
> The whole patchset based on Linux upstream.
> 
> Current the patchset support x86_64 only.
> 
> The major change from v1:
> 1. SMP support.
> 2. Modify the entrance point to avoid most of genernic kernel modification.
> 3. Binding PV timer with event channel mechanism.
> 
> You need a line like:
> 
> cpuid = [ '0x40000002:edx=0x3' ]
> 
> in HVM configuration file to expose hybrid feature to guest, and
> 
> CONFIG_XEN
> 
> in the guest kernel configuration file to enable the hybrid support.
> 
> And the compiled image can be used as native/pv domU/hvm guest/hybrid
>  kernel.
> 
> Comments are welcome!
> 
> BTW: For the MSI/MSI-X support, pv_ops dom0 can share the solution with
>  hybrid. We would try to figure out a elegant way to deal with it later.
> 
> --
> regards
> Yang, Sheng
> 
> --
>  arch/x86/include/asm/xen/cpuid.h     |   73 +++++++++++++
>  arch/x86/include/asm/xen/hypercall.h |    6 +
>  arch/x86/kernel/setup.c              |    8 ++
>  arch/x86/xen/enlighten.c             |  192
>  ++++++++++++++++++++++++++++++++++ arch/x86/xen/irq.c                   | 
>   54 ++++++++++
>  arch/x86/xen/smp.c                   |  144 +++++++++++++++++++++++++-
>  arch/x86/xen/xen-head.S              |    6 +
>  arch/x86/xen/xen-ops.h               |    4 +
>  drivers/block/xen-blkfront.c         |    3 +
>  drivers/input/xen-kbdfront.c         |    4 +
>  drivers/net/xen-netfront.c           |    3 +
>  drivers/video/xen-fbfront.c          |    4 +
>  drivers/xen/events.c                 |   66 +++++++++++-
>  drivers/xen/grant-table.c            |   67 ++++++++++++-
>  drivers/xen/xenbus/xenbus_probe.c    |   23 ++++-
>  include/xen/events.h                 |    1 +
>  include/xen/hvm.h                    |   28 +++++
>  include/xen/interface/hvm/hvm_op.h   |   79 ++++++++++++++
>  include/xen/interface/hvm/params.h   |  111 ++++++++++++++++++++
>  include/xen/interface/xen.h          |    6 +-
>  include/xen/xen.h                    |   12 ++
>  21 files changed, 883 insertions(+), 11 deletions(-)
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
> 
