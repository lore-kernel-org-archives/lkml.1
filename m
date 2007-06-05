Return-Path: <linux-kernel-owner+w=401wt.eu-S1763121AbXFESoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763121AbXFESoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbXFESny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:43:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:21412 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514AbXFESny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:43:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,386,1175497200"; 
   d="scan'208";a="93757392"
Date: Tue, 5 Jun 2007 11:40:15 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070605184015.GF17143@linux-os.sc.intel.com>
References: <20070601004427.GI30788@tree.beaverton.ibm.com> <20070605172310.GD17143@linux-os.sc.intel.com> <20070605173647.GC12782@tree.beaverton.ibm.com> <20070605181342.GE17143@linux-os.sc.intel.com> <20070605183300.GD12782@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605183300.GD12782@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 11:33:01AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 05, 2007 at 11:13:42AM -0700, Siddha, Suresh B wrote:
> > I see. Your system should have 4 or 8 logical cpu's right. So you must be
> > using logical flat mode, right?
> 
> I believe so.  The system has two Xeon 5150s with an Intel 5000 chipset
> of some sort.
> 
> > When this bug happens, what does /proc/irq/<irq-no>/smp_affinity show?
> 
> root@elm3a188:~# cat /proc/irq/114/smp_affinity 
> 02

Ok. What this shows is that fixup_irqs() failed to move the irq properly.
Ideally we should see cpu_online_map here (i.e., 0xfd).

So most likely __assign_irq_vector() failed for some reason and I am
puzzled for the reason...

Does this problem happen only under certain stress or something simple, like

boot the kernel
echo 2 > /proc/irq/114/smp_affinity
wait for irq to hit the cpu1.
echo 0 > /sys/devices/system/cpu/cpu1/online

will immmd trigger this?

thanks,
suresh
