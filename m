Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYKQD50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYKQD50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 22:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbYKQD5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 22:57:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:35313 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbYKQD5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 22:57:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,616,1220252400"; 
   d="scan'208";a="77182515"
Subject: Re: 2.6.28-rc4: iwlagn / 5100 state
From: Zhu Yi <yi.zhu@intel.com>
To: Nico -telmich- Schottelius 
	<nico-linux-iwlwifi5100@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081114150508.GC4877@denkbrett.schottelius.org>
References: <20081114150508.GC4877@denkbrett.schottelius.org>
Content-Type: text/plain
Organization: Intel Corp.
Date: Mon, 17 Nov 2008 11:58:19 +0800
Message-Id: <1226894299.2548.19.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 23:05 +0800, Nico -telmich- Schottelius wrote:
>    - loading the firmware "freezes" the system for a few seconds
>    - setting the link up of wlan0 "freezes" the system for a few
> seconds

We use a wait_event_interruptible_timeout in mac80211 start callback to
make sure firmware is loading OK before 'ifconfig wlan0 up' returns.
This prevents the EREADY error some wireless configuration commands
immediately followed by link up (usually in some scripts). The timeout
is 4 seconds, but usually firmware responses in less than 500ms. Did you
see the "freeze" in a failure case?

>    - connecting to 802.11b/g works (802.11a is untested)
>    - roaming does *NOT* work -> just looses the AP, does not connect
>      to other AP with same essid

This needs to be addressed in user level (i.e. NM).

>    - connecting to a ap sometimes does not work, though essid is set
>       -> sometimes it helps to specify "ap <addr>"

This is not required with recent mac80211.

>       -> sometimes setting down and up the link helps
>       -> with earlier kernels one sometimes needed to rmmod and insmod
>          the module again, so there is some progress :-)

These are unexpected behaviours. Please report bugs to
http://bughost.org.

Thanks,
-yi

