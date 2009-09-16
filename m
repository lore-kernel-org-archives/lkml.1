Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZIPWNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZIPWNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZIPWNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:13:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:15524 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbZIPWNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:13:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,400,1249282800"; 
   d="scan'208";a="551236758"
Subject: Re: WARNING: at net/mac80211/scan.c:267
 ieee80211_scan_completed+0x299/0x2b0 	[mac80211]()
From: reinette chatre <reinette.chatre@intel.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <8db1092f0909161259i5e007282i42f426bc2d0fc0c4@mail.gmail.com>
References: <8db1092f0909160236i5d2b1f31k3ec289fbd9ac0bfa@mail.gmail.com>
	 <1253122055.26521.431.camel@rc-desk>
	 <8db1092f0909161036t5bae781eqa6f0a0df308ec4cd@mail.gmail.com>
	 <1253124149.26521.438.camel@rc-desk>
	 <8db1092f0909161259i5e007282i42f426bc2d0fc0c4@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 15:13:06 -0700
Message-Id: <1253139186.26521.449.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Wed, 2009-09-16 at 12:59 -0700, Maciej Rutecki wrote:

> Script (wifi_wpa.sh):
> #!/bin/sh
> INTERFACE=wlan0
> WPA_FILE=/etc/wpa_supplicant/wpa_supplicant.conf
> DRIVER=wext
> ifconfig eth0 down
> ifconfig $INTERFACE up
> sleep 3
> killall wpa_supplicant &> /dev/null
> wpa_supplicant -c $WPA_FILE -D $DRIVER -i $INTERFACE -B
> dhclient $INTERFACE

I think there is a potential race here. You start wpa_supplicant in
background and then immediately request an IP. It is not guaranteed at
this point that you are associated.

Could you perform the last three steps of your script manually?

Reinette


