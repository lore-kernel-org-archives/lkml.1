Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZBDBvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZBDBvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZBDBvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:51:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:23868 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZBDBvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:51:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,375,1231142400"; 
   d="scan'208";a="106799615"
Subject: Re: [linux-pm] Acer 6592 TM, suspend to ram and resume freeze
From: ZhangRui <rui.zhang@intel.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
In-Reply-To: <873aevl0l8.fsf@free.fr>
References: <873aevl0l8.fsf@free.fr>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 09:52:27 +0800
Message-Id: <1233712347.6643.7.camel@rzhang-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 04:36 +0800, Robert Jarzmik wrote:
> First of all, sorry for the duplicate on linux-pm, but as Pavel suggested, this
> topic gains wider audience as acpi and pm are involved.
> 
> I have an issue with my laptop with suspend to ram.
> My laptop is an Acer Travelmate 6592g :
> 
> > [rj@velvet wireshark-1.0.5 (master)]$ sudo s2ram -i
> > This machine can be identified by:
> >     sys_vendor   = "Acer"
> >     sys_product  = "TravelMate 6592"
> >     sys_version  = "PSMBOU-1234567"
> >     bios_version = "V1.53   "
> 
> The kernel running is the last I have : 2.6.29-rc1, but the problem is the same
> whatever the kernel version I take (between 2.6.16 and 2.6.29-rc1).
> 
> The issue is that even if the laptop enters suspend correctly, it hangs on
> comming out of it. After some research, I cornered down the module which changes
> the behaviour : acpi_cpufreq.ko.
> 
> When I forbid the laptop to load this module, the suspend to ram works like a
> charm, in "init" single mode or multi-user mode. When I load the module, the
> resume always hangs (fan goes high speed like crazy, no LCD back, hard drive led
> stays on, caps_lock key not responsive, ...)
what if you build in the ACPI processor driver (CONFIG_ACPI_PROCESSOR=y)
and boot with "processor.max_cstate=1"?

> 
> Now, I notice that loading acpi-cpufreq triggers the following message :
> > log: Jan 19 18:23:42 velvet kernel: ACPI: EC: non-query interrupt received, switching to interrupt mode
> 
I don't think these two are related. can you please make a double check?

thanks,
rui

