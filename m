Return-Path: <linux-kernel-owner+w=401wt.eu-S965233AbXCBT7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233AbXCBT7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 14:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965248AbXCBT7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 14:59:33 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38216 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965233AbXCBT7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 14:59:32 -0500
Subject: Re: [PATCH -mm] clocksource init adjustments (fix bug #7426)
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, andreas.friedrich@fujitsu-siemens.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@mvista.com>
In-Reply-To: <20070302021827.7edc1a23.akpm@linux-foundation.org>
References: <1172189582.5422.26.camel@localhost.localdomain>
	 <20070302021827.7edc1a23.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 11:58:11 -0800
Message-Id: <1172865491.5449.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 02:18 -0800, Andrew Morton wrote:
> On Thu, 22 Feb 2007 16:13:02 -0800 john stultz <johnstul@us.ibm.com> wrote:
> > Thus the solution here is to register clocksources earlier (ideally when
> > the hardware is being initialized), and then we enable clocksource
> > selection at fs_initcall (before device_initcall).
> > 
> > This patch should probably get some testing time in -mm, since
> > clocksource selection is one of the most important issues for correct
> > timekeeping, and I've only been able to test this on a few of my own
> > boxes.
> 
> This doornails my Nocona box early in boot:
> http://userweb.kernel.org/~akpm/s5000431.jpg
> 
> Slab isn't ready yet - time_init()->hpet_arch_init() is called before
> start_kernel() has run kmem_cache_init().

Oh! Sorry! Yea, looking at it more the ioremap isn't actually necessary,
as we can use hpet_readl() instead of re-calculating the hpet base
address pointer.

I'll fix this up (and find an HPET enabled x86_64 box to test it on) and
get a patch to you shortly.

Sorry again!
-john


