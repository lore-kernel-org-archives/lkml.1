Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYFPBwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYFPBwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 21:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYFPBvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 21:51:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:1134 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYFPBvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 21:51:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,649,1204531200"; 
   d="scan'208";a="341490925"
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <200806131937.03680.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <20080606034738.9835782d.akpm@linux-foundation.org>
	 <1213151464.7814.630.camel@debian.sh.intel.com>
	 <200806131937.03680.Michal.Kudla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Organization: Intel Corp.
Date: Mon, 16 Jun 2008 09:51:28 +0800
Message-Id: <1213581088.7814.882.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-13 at 19:37 +0200, Michał Kudła wrote:
> dmesg-2.6.26-rc5_2008-06-13.txt

>From this log:

iwl4965: U iwl4965_radio_kill_sw Manual SW RF KILL set to: RADIO OFF
iwl4965: I iwl4965_rx_card_state_notif Card state received: HW:On
SW:Kill
iwl4965: U iwl4965_mac_config leave - radio disabled
iwl4965: Error sending REPLY_TX_PWR_TABLE_CMD: enqueue_hcmd failed: -5
iwl4965: U iwl4965_bg_rf_kill Can not turn radio back on - disabled by
SW switch
iwl4965: Error sending REPLY_WEPKEY: enqueue_hcmd failed: -5

Your radio is disabled by the software rf_kill switch. Please do a

$ echo 0 > /sys/bus/pci/drivers/iwl4965/<dev id>/rfkill\:rfkill0/state

I wonder if you (or some application) did something like a `iwconfig
wlan0 txpower off` so that the radio is disabled. Maybe you can try
`iwconfig wlan0 txpower on`?

Thanks,
-yi

