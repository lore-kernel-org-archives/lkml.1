Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0BHXAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 18:00:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:14948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab0BHXAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 18:00:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,432,1262592000"; 
   d="scan'208";a="538943743"
Subject: Re: PROBLEM: iwlagn kernel 2.6.32.3 ooops
From: reinette chatre <reinette.chatre@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "lkml@Think-Future.de" <lkml@Think-Future.de>,
       Linux Kernel-Liste <linux-kernel@vger.kernel.org>,
       "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100208143118.e8e5a1ee.akpm@linux-foundation.org>
References: <20100206170348.GB9411@localhost>
	 <20100208143118.e8e5a1ee.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 15:00:39 -0800
Message-ID: <1265670039.2551.1828.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2010-02-08 at 14:31 -0800, Andrew Morton wrote:
> On Sat, 6 Feb 2010 18:03:50 +0100
> lkml@Think-Future.de wrote:
> > 
> > 
> > [250420.677157] ip: page allocation failure. order:3, mode:0x8020
> 
> This one isn't an "oops" - it's a warning that a memory allocation
> attempt failed.  Which is hardly surprising: an order-3 GFP_ATOMIC
> allocation is highly unreliable and the driver just shouldn't be
> attempting it.

This is the familiar http://bugzilla.kernel.org/show_bug.cgi?id=14141
which is not specific to iwlwifi.

Even so, from 2.6.33 iwlwifi will be doing paged RX which reduces the
amount of atomic memory needed. 

> > [252109.496953] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> > [252109.496961] iwlagn: Copyright(c) 2003-2009 Intel Corporation
> > [252109.497071] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> > [252109.497094] iwlagn 0000:03:00.0: setting latency timer to 64
> > [252109.497156] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
> > [252109.547060] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
> > [252109.547202] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
> > [252109.548104] phy14: Selected rate control algorithm 'iwl-agn-rs'
> > [252109.921801] udev: renamed network interface wlan0 to eth1
> > [252110.693015] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-4965-2.ucode
> > [252110.810198] iwlagn 0000:03:00.0: loaded firmware version 228.61.2.24
> > [252110.989598] ------------[ cut here ]------------
> > [252110.989620] WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1151 iwl_tx_cmd_complete+0x2ed/0x330 [iwlcore]()
> 
> This one is a warning, not an oops.  It could be a consequence of the
> memory allocation failure.

Based on the preceding messages the driver was reloaded at this point so
the previous memory allocations should have no effect.

>   If so, the code should be changed to
> prevent this warning from coming out.  Because a GFP_ATOMIC memory
> allocation failure is common, and expected (especially when it's
> order-3!).  The driver should handle it without blurting big warnings.

The warning is not related to the memory allocation failure. This is a
different problem. While I dig a bit into the trace, could you please
share the steps to reproduce? Could you please activate some debugging
to see what else is going on at the time? 

Please compile driver with CONFIG_IWLWIFI_DEBUG and load module with
"modprobe iwlagn debug=0x1043fff"

Thank you

Reinette


