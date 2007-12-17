Return-Path: <linux-kernel-owner+w=401wt.eu-S934866AbXLQCLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866AbXLQCLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760001AbXLQCLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:11:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:29387 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbXLQCLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:11:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,174,1196668800"; 
   d="scan'208";a="443835540"
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
From: Shaohua Li <shaohua.li@intel.com>
To: Mike Houston <mikeserv@bmts.com>
Cc: Adrian Bunk <bunk@stusta.de>, Elvis Pranskevichus <el@prans.net>,
       Jean Delvare <khali@linux-fr.org>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <ambx1@neo.rr.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20071209230211.1c2077cf.mikeserv@bmts.com>
References: <20071204215154.7f26285e.mikeserv@bmts.com>
	 <20071209000554.GF20441@stusta.de>
	 <20071208212234.e00b74cd.mikeserv@bmts.com>
	 <20071209105028.06ed52a6@hyperion.delvare>
	 <E1J1TRp-0000ZF-6J@asgard.prans.org> <20071209220430.GK20441@stusta.de>
	 <1197253887.27516.2.camel@sli10-desk.sh.intel.com>
	 <20071209230211.1c2077cf.mikeserv@bmts.com>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 09:59:39 +0800
Message-Id: <1197856779.7782.2.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-09 at 23:02 -0500, Mike Houston wrote:
> On Mon, 10 Dec 2007 10:31:27 +0800
> Shaohua Li <shaohua.li@intel.com> wrote:
> > This should exist in previous kernel (before we remove acpi
> > motherboard driver) too. Basically it's a broken BIOS. Could below
> > patch work around it?
> > 
> > Thanks,
> > Shaohua
> > 
> > Index: linux/drivers/pnp/system.c
> > ===================================================================
> > --- linux.orig/drivers/pnp/system.c	2007-12-10
> > 10:17:46.000000000 +0800 +++ linux/drivers/pnp/system.c
> 
> Thanks Shaohua, I tested this as well and it appears to have worked
> around the issue for me.
> 
> Now, in dmesg, I get:
> 
> system 00:01: ioport range 0x290-0x29f has been reserved
> (...)
> system 00:01: ioport range 0x290-0x294 could not be reserved
> 
> In /proc/ioports I see:
> 
> 0290-029f : pnp 00:01
>   0290-0297 : it87
>     0290-0297 : it87
Unfortunately this can't solve all such issues.

Adam & Bjorn,
Could we just reserve IO ports >= 0x1000 in pnp system driver? The
purpose of the driver is to avoid resource conflict with PCI device, and
PCI device can't user io port < 0x1000.

Thanks,
Shaohua

