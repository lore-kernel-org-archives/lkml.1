Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbXKZX0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbXKZX0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbXKZX0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:26:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:30554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbXKZX0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:26:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,216,1194249600"; 
   d="scan'208";a="216087594"
Message-ID: <474B5610.4030800@intel.com>
Date: Mon, 26 Nov 2007 15:26:08 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: Auke Kok <auke-jan.h.kok@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: e1000 driver problems
References: <20061017205316.25914.qmail@web83109.mail.mud.yahoo.com> <45354850.6050900@intel.com> <20071120143803.GA5638@ics.muni.cz>
In-Reply-To: <20071120143803.GA5638@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2007 23:26:31.0737 (UTC) FILETIME=[C6FCE290:01C83083]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Hello,
> 
> I have laptop thinkpad T61 with 82566MM Gigabit Network Connection (rev 03)
> (8086:1049). I have kernel 2.6.24-rc3. E1000E driver does not work (the card
> is not detected although it is PCI-E), with E1000 driver, it works mostly OK
> unless I force speed to 100Mbits. (ethtool -s eth0 autoneg off speed 100)

this device (the ich8 onboard NIC) will not be supported in e1000e until 2.6.25.

> I got message about device hang:
> Nov 20 10:57:24 anubis kernel: [  212.307502] e1000: eth0: e1000_watchdog:
> 10/100 speed: disabling TSO
> Nov 20 11:03:02 anubis kernel: [  242.811474]   Tx Queue             <0>
> Nov 20 11:03:02 anubis kernel: [  242.811476]   TDH                  <80>
> Nov 20 11:03:02 anubis kernel: [  242.811478]   TDT                  <81>
> Nov 20 11:03:02 anubis kernel: [  242.811480]   next_to_use          <81>
> Nov 20 11:03:02 anubis kernel: [  242.811482]   next_to_clean        <80>
> Nov 20 11:03:02 anubis kernel: [  242.811484] buffer_info[next_to_clean]
> Nov 20 11:03:02 anubis kernel: [  242.811486]   time_stamp <100079cdf>
> Nov 20 11:03:02 anubis kernel: [  242.811488]   next_to_watch        <80>
> Nov 20 11:03:02 anubis kernel: [  242.811489]   jiffies <100079e68>
> Nov 20 11:03:02 anubis kernel: [  242.811491]   next_to_watch.status <0>
> Nov 20 11:03:04 anubis kernel: [  243.000047]   Tx Queue             <0>
> Nov 20 11:03:04 anubis kernel: [  243.000049]   TDH                  <80>
> Nov 20 11:03:04 anubis kernel: [  243.000051]   TDT                  <81>
> Nov 20 11:03:04 anubis kernel: [  243.000053]   next_to_use          <81>
> and so on.
> 
> Is it known problem?

there have been indeed know reports of these "fake" hangs. basically the counter
logic for these newer devices reports hangs too quickly for 10/100 speeds while
they actually are not occurring (the line is just very busy).

The fix for this has been to grant more time for the hardware to recover from this
busy state. I'll make sure to check if the upstream drivers are OK in this regard.

you can try our out-of-tree e1000 driver (7.6.x or newer) which should work OK for
you with respect to this problem. Please give that a try.

Cheers,

Auke
