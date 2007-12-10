Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXLJECZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXLJECZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 23:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXLJECR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 23:02:17 -0500
Received: from tomts31.bellnexxia.net ([209.226.175.105]:51835 "EHLO
	tomts31-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbXLJECQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 23:02:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAAdJXEdFn+Sr/2dsb2JhbAClEg
Date: Sun, 9 Dec 2007 23:02:11 -0500
From: Mike Houston <mikeserv@bmts.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Adrian Bunk <bunk@stusta.de>, Elvis Pranskevichus <el@prans.net>,
       Jean Delvare <khali@linux-fr.org>, Mike Houston <mikeserv@bmts.com>,
       mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Adam Belay <ambx1@neo.rr.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Message-Id: <20071209230211.1c2077cf.mikeserv@bmts.com>
In-Reply-To: <1197253887.27516.2.camel@sli10-desk.sh.intel.com>
References: <20071204215154.7f26285e.mikeserv@bmts.com>
	<20071209000554.GF20441@stusta.de>
	<20071208212234.e00b74cd.mikeserv@bmts.com>
	<20071209105028.06ed52a6@hyperion.delvare>
	<E1J1TRp-0000ZF-6J@asgard.prans.org>
	<20071209220430.GK20441@stusta.de>
	<1197253887.27516.2.camel@sli10-desk.sh.intel.com>
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2007 10:31:27 +0800
Shaohua Li <shaohua.li@intel.com> wrote:
> This should exist in previous kernel (before we remove acpi
> motherboard driver) too. Basically it's a broken BIOS. Could below
> patch work around it?
> 
> Thanks,
> Shaohua
> 
> Index: linux/drivers/pnp/system.c
> ===================================================================
> --- linux.orig/drivers/pnp/system.c	2007-12-10
> 10:17:46.000000000 +0800 +++ linux/drivers/pnp/system.c

Thanks Shaohua, I tested this as well and it appears to have worked
around the issue for me.

Now, in dmesg, I get:

system 00:01: ioport range 0x290-0x29f has been reserved
(...)
system 00:01: ioport range 0x290-0x294 could not be reserved

In /proc/ioports I see:

0290-029f : pnp 00:01
  0290-0297 : it87
    0290-0297 : it87

The it87 sensor now works without disabling acpipnp

Mike Houston
