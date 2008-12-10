Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYLJRSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYLJRSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYLJRS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:18:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:18024 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbYLJRS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:18:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,748,1220252400"; 
   d="scan'208";a="413244427"
Subject: Re: iwlagn interrupt problem
From: reinette chatre <reinette.chatre@intel.com>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <c072ca310812100710o58c38a27rba16ad2318a1cb95@mail.gmail.com>
References: <c072ca310812100638k6c15473brb89632a9c175a028@mail.gmail.com>
	 <c072ca310812100710o58c38a27rba16ad2318a1cb95@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 09:19:08 -0800
Message-Id: <1228929548.18730.21.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 07:10 -0800, Alexander E. Patrakov wrote:
> [linux-wireless: sorry for the duplicate, I didn't use the correct
> address for LKML, as this is my first LKML post from work]
> 
> Hello. My kernel is 2.6.27.6, and at work, I sit in a place with
> unreliable wireless connection. The problematic piece of dmesg looks
> like this:
> 
> [17454.155855] wlan0: deauthenticated
> [17456.509322] iwlagn 0000:0c:00.0: PCI INT A disabled
> [17456.557701] iwlagn 0000:0c:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [17456.557814] iwlagn 0000:0c:00.0: restoring config space at offset
> 0x1 (was 0x100102, writing 0x100106)
> [17456.756926] Registered led device: iwl-phy0:radio
> [17456.756976] Registered led device: iwl-phy0:assoc
> [17456.757028] Registered led device: iwl-phy0:RX
> [17456.757065] Registered led device: iwl-phy0:TX
> [17456.766141] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [17460.329937] wlan0: authenticate with AP 00:19:5b:ba:53:b7
> [17460.335391] wlan0: authenticated
> [17460.335401] wlan0: associate with AP 00:19:5b:ba:53:b7
> [17460.532088] wlan0: associate with AP 00:19:5b:ba:53:b7
> [17460.534523] wlan0: RX AssocResp from 00:19:5b:ba:53:b7 (capab=0x431
> status=0 aid=2)
> [17460.534533] wlan0: associated
> [17460.541523] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [17471.476059] wlan0: no IPv6 routers present
> [17821.193753] wlan0: deauthenticated
> [17823.550303] iwlagn 0000:0c:00.0: PCI INT A disabled
> [17823.612978] iwlagn 0000:0c:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [17823.613110] iwlagn 0000:0c:00.0: restoring config space at offset
> 0x1 (was 0x100102, writing 0x100106)
> [17823.812945] Registered led device: iwl-phy0:radio
> [17823.812995] Registered led device: iwl-phy0:assoc
> [17823.813048] Registered led device: iwl-phy0:RX
> [17823.813085] Registered led device: iwl-phy0:TX
> [17823.823450] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [17827.380770] wlan0: authenticate with AP 00:19:5b:ba:53:b7
> [17827.382603] wlan0: authenticated
> [17827.382613] wlan0: associate with AP 00:19:5b:ba:53:b7
> [17827.581037] wlan0: associate with AP 00:19:5b:ba:53:b7
> [17827.583418] wlan0: RX AssocResp from 00:19:5b:ba:53:b7 (capab=0x431
> status=0 aid=2)
> [17827.583429] wlan0: associated
> [17827.591080] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [17838.392089] wlan0: no IPv6 routers present
> 
> Prevois kernels panicked in this place, see description and photo at
> http://patrakov.blogspot.com/2008/09/kernel-panic.html
> 
> The messages about "PCI INT A" are still a problem, because at this
> time, the audio loops and the mouse is unresponsive (i.e., the system
> locks up for a brief period of time, but eventually recovers). Here is
> /proc/interrupts:

The messages you refer to are printed because a user space app
(wpa_supplicant or network manager) brings the wireless interface down
and up. Interrupts are disabled when interface is brought down and
reenabled when interface is brought up.

The unresponsiveness is due to a bug that was fixed recently. The
patches have been merged into wireless-testing repo and will be included
in 2.6.29. If you want to try 
the individual patches, please try:
http://marc.info/?l=linux-wireless&m=122824886623698&w=2
http://marc.info/?l=linux-wireless&m=122849275528102&w=2


Reinette

