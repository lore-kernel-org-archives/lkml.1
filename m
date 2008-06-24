Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbYFXDxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbYFXDxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYFXDxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:53:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:26457 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbYFXDxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:53:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,693,1204531200"; 
   d="scan'208";a="581244706"
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <200806240537.08888.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <200806232103.31283.Michal.Kudla@gmail.com>
	 <1214275275.14590.194.camel@debian.sh.intel.com>
	 <200806240537.08888.Michal.Kudla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Organization: Intel Corp.
Date: Tue, 24 Jun 2008 11:51:53 +0800
Message-Id: <1214279513.14590.198.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 05:37 +0200, Michał Kudła wrote:
> laptok ~ # cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill
> \:rfkill1/state
> 0
> laptok ~ # echo "1"> /sys/bus/pci/drivers/iwl4965/0000\:04
> \:00.0/rfkill\:rfkill1/state
> laptok ~ # iwconfig wlan0 txpower on
> laptok ~ # /etc/init.d/net.wlan0 restart
>  * Service net.wlan0 starting
>  Failed to configure wireless for wlan0
> [ !! ] * ERROR:  net.wlan0 failed to start

Looks like the wireless config scripts in your distro did something
(probably txpower off) to disable the SW radio. Can you try the
following commands after wlan0 restart?

$ cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill\:rfkill1/state
$ echo 1 > /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill
\:rfkill1/state
$ ifconfig wlan0 up

Thanks,
-yi

