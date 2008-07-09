Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYGIR5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYGIR5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYGIR4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:56:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:62133 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbYGIR4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:56:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,332,1212390000"; 
   d="scan'208";a="350688932"
Date: Wed, 9 Jul 2008 10:56:21 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] tip/x86_64: fix e820 merge issue which broke max_pfn_mapped
Message-ID: <20080709175621.GG1678@linux-os.sc.intel.com>
References: <20080708230837.GD1678@linux-os.sc.intel.com> <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com> <86802c440807081856y17eb1f1cs5647b2c2a765f429@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807081856y17eb1f1cs5647b2c2a765f429@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 06:56:38PM -0700, Yinghai Lu wrote:
> On Tue, Jul 8, 2008 at 5:59 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Tue, Jul 8, 2008 at 4:08 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> >> With out this 64bit tip/master doesn't boot using ACPI on my system.
> >> ---
> >>
> >> max_pfn_mapped should include all e820 entries.
> >> The direct mapping extends to max_pfn_mapped, so that we can directly access
> >> apertures, ACPI and other tables without having to play with fixmaps.
> >>
> >> With this, my system with 1GB memory boots fine with ACPI enabled.
> >
> > so without this patch, your system doesn't boot?
> 
> how about attached patch?
> 
> [PATCH] x86: make max_pfn cover acpi table below 4g
> 
> when system have 4g less ram installed, and acpi table sit
> near end of ram. make max_pfn cover them too.
> so 64bit kernel don't need to mess up fixmap

Now the latest 64bit x86 tip/master (latest commit d1f7cb8) doesn't boot
on any of my test systems :( It gets a very early exception..

I can't even revert your max_pfn patch, to see if this early exception is
caused by this patch.. There seems to be more changes on top of it
already overnight...

BTW, please explain the need for your patch which has more changes, instead
of my simple patch which was test booted on 3 different systems with both
32bit and 64bit kernels...

thanks,
suresh
