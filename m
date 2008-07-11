Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbYGKBvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbYGKBvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYGKBvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:51:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:50460 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbYGKBvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:51:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,341,1212390000"; 
   d="scan'208";a="353247470"
Date: Thu, 10 Jul 2008 18:50:59 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 26/26] x64, x2apic/intr-remap: introduce CONFIG_INTR_REMAP
Message-ID: <20080711015059.GO1678@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710182239.635284000@linux-os.sc.intel.com> <m1r6a1fhc8.fsf@frodo.ebiederm.org> <20080710233733.GA21085@ywang-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710233733.GA21085@ywang-dev>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 04:37:33PM -0700, Yong Wang wrote:
> > Is it possible to run in x2apic mode without running in interrupt remapping mode?
> > Just send the irqs directly to the cpu?  It feels like it should be if an iommu
> > doesn't get in the way.
> >
> 
> Yes, it is possible to run in x2apic mode without intr-remap. However, the extended
> cpu addressability will not be fully utilized that way.

No. CPU can't be in x2apic mode with out enabling interrupt-remapping.
Interrupts may not work (even when we have few cpu's). For example, in logical
cluster mode, logical x2apic id (initialized by HW) will be > 16 bit,
in a smaller DP configuration.

In general, enabling x2apic with out enabling interrupt-remapping is not
recommended, as the platform will be using legacy interrupt format and the
CPU will be using extended ID mode.

thanks,
suresh
