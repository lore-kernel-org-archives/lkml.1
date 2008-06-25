Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYFYB04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYFYB04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 21:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYFYB0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 21:26:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:1119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbYFYB0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 21:26:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,699,1204531200"; 
   d="scan'208";a="581625965"
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
From: Zhao Yakui <yakui.zhao@intel.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
In-Reply-To: <19f34abd0806240452w2561040uc2b1b1d35562db71@mail.gmail.com>
References: <20080620135639.GA5073@damson.getinternet.no>
	 <alpine.LFD.1.10.0806201458500.3027@localhost.localdomain>
	 <19f34abd0806201340t502ce471n578dd2498a5f1992@mail.gmail.com>
	 <19f34abd0806201427h740ca3e7gc2f01c7e34616fd4@mail.gmail.com>
	 <19f34abd0806210119o64a1c9ban78710651a01530cf@mail.gmail.com>
	 <20080624114139.GC21890@elte.hu>
	 <19f34abd0806240452w2561040uc2b1b1d35562db71@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 09:37:37 +0800
Message-Id: <1214357857.9800.20.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 13:52 +0200, Vegard Nossum wrote:
> On 6/24/08, Ingo Molnar <mingo@elte.hu> wrote:
> > i havent seen the warning reappear with your fix after thousands of
> > bootups - so i guess we can consider it fixed.
> >
> > Len, please consider the patch below. (it's in tip/out-of-tree)
> 
> No, please don't :-)
> 
> It fixes your particular case (the acpi_rtc_init() hunk of the patch),
> but the acpi_walk_namespace() part should be changed to a WARN(). But
> that is likely to cause a lot of "spurious" reports, so the other acpi
> drivers should be fixed as well.
In fact this issue is related with the following factors:
   a. when acpi is disabled, OS won't initialize the ACPI mutex, which
is accessed by many ACPI interface functions. For example:
acpi_walk_namespace, acpi_install_fixed_event_handler.
   b. When acpi is disabled, some drivers will call the ACPI interface
functions. For example: The acpi_walk_namespace is called in
dock_init/bay_init. The acpi_install_fixed_event_handler is called in
the acpi_rtc_init.
   
  
   Although the following warning message is harmless, it is still
confusing.
   > [    3.980213] ACPI Exception (utmutex-0263): AE_BAD_PARAMETER,
Thread F7C50000 could not acquire Mutex [3] [20080321]

   Maybe it is reasonable that the flag of acpi_disabled should be used
in the drivers using ACPI interface functions. Of course it will be safe
to use the flag of acpi_disabled in the function of acpi_walk_namespace.

Thanks.
   Yakui.
> I was waiting for Len to reply, but maybe I can submit the proper fix too.
> 
> 
> Vegard
> 

