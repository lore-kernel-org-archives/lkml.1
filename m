Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZBUXdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZBUXdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 18:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbZBUXdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 18:33:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:23831 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbZBUXdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 18:33:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,247,1233561600"; 
   d="scan'208";a="667492821"
Date: Sat, 21 Feb 2009 15:33:01 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: enable x2apic early at the first point
Message-ID: <20090221233300.GB6733@linux-os.sc.intel.com>
References: <499DD40F.40102@kernel.org> <20090220095127.GK24555@elte.hu> <20090220095530.GA15186@elte.hu> <1235255001.14523.76.camel@vayu> <49A083A2.30303@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A083A2.30303@kernel.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 02:43:46PM -0800, Yinghai Lu wrote:
> for x2apic preenabled system,
> when nox2apic is used, cpu_has_x2apic will be cleared, apic will be xapic phys_flat or flat.
> is that expected?
> 
> should
> 1. ignore nox2apic
> 2. or try to disable x2apic?

This scenario might be useful for debug purposes? But it might
not be simple/straight fwd in OS to implement this, as we need to do two things.

1. Go back to xapic mode using the state transition diagram in SDM.

2. And also, we need to disable the interrupt-remapping setup by the bios,
so that chipset and cpu's are in same mode.

If BIOS has enabled x2apic, it is for a reason (mostly platform
has more logical cpus and hence need x2apic to brinup all the AP's etc).
And typically other than very high end platforms, I don't expect bios
to turn on x2apic.

thanks,
suresh
