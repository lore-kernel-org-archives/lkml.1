Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbYAKJFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbYAKJFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYAKJFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:05:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:4015 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbYAKJFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:05:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,270,1196668800"; 
   d="scan'208";a="284119129"
Subject: Re: [PATCH] ACPI: Add sysfs interface for acpi device wakeup
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Zhang Rui <rui.zhang@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, david-b@pacbell.net,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       lenb@kernel.org, acpi-bugzilla@lists.sourceforge.net
In-Reply-To: <1200039383.3749.124.camel@acpi-sony.sh.intel.com>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>
	 <1199917306.9596.3.camel@yangyi-dev.bj.intel.com>
	 <200801100943.08780.maximlevitsky@gmail.com>
	 <1200039383.3749.124.camel@acpi-sony.sh.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Fri, 11 Jan 2008 07:55:42 +0800
Message-Id: <1200009342.5389.12.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think that it would be much much better to place wake-up attributes under
> > corresponding PCI and PNP devices.
> > Probably it is even better to link this code to PCI code, so PCI drivers will be aware of ACPI.
> I like this idea, maxim. :)
> And that's what we actually did about half a year ago.
> 
> Yi,
> Please refer to http://bugzilla.kernel.org/show_bug.cgi?id=6892
> and David's patch set here:
> http://marc.info/?l=linux-mm-commits&m=117701595209299&w=2
> http://marc.info/?l=linux-mm-commits&m=117701866524935&w=2
> You can have a look at this thread as well:
> http://marc.info/?l=linux-acpi&m=119982937409968&w=2
> 
I checked those patches you mentioned, they did bind two wakeup flag to
some extent, but they can't be exchanged to use and they are just partly
in current linus tree, two flags bind isn't in linus tree.

According to my test on the latest linus tree, wakeup flag of
acpi_device hasn't any association with device's, i don't know if they
are the same thing. if we enbale or disable it manually, what will
happen? From source code, it is just a flag, it doesn't trigger any
event or hardware operation.

> thanks,
> Rui
> > For example it will fix the 'EHCI instantly wakes up the system from S4' on my system, since here USB doesn't wake
> > up anything from S4, and ACPI tables correctly show that.
> > 
> > If ehci driver was aware of that it could disable #PME on entrance to S4.
> > And we even can reuse its 'wakeup' attribute, thus enabling wakeup automatically.
> > 
> > Going ever further, I think that it will be great to get rid of ACPI device tree, since
> > most acpi devices are ether PCI of PNP ones.
> > 
> > Or, even better have a small ACPI tree, that will contain 'true' ACPI devices, like cpus
> > thermal sensors, buttons, etc. 
> > 
> 
> 

