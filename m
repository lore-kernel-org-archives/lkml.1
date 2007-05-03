Return-Path: <linux-kernel-owner+w=401wt.eu-S1767415AbXECPhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767415AbXECPhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766496AbXECPhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:37:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:32635 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S376141AbXECPhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:37:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,486,1170662400"; 
   d="scan'208";a="83243841"
Message-ID: <463A0199.4080204@intel.com>
Date: Thu, 03 May 2007 08:36:57 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Michel Lespinasse <walken@zoy.org>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Jeb Cramer <cramerj@intel.com>, John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>
Subject: Re: e1000 issue on DQ965GF board (was 24 lost ticks with 2.6.20.10
 kernel)
References: <20070501130715.GB29131@zoy.org> <46375E04.5030506@redhat.com> <20070501214912.GA4048@zoy.org> <4637BA70.8000108@intel.com> <20070502084146.GA6089@zoy.org> <4638D51C.7010603@intel.com> <20070503062701.GA22255@zoy.org>
In-Reply-To: <20070503062701.GA22255@zoy.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 May 2007 15:36:59.0135 (UTC) FILETIME=[E34CB8F0:01C78D98]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Bruce to the Cc, reply below]

Michel Lespinasse wrote:
> On Wed, May 02, 2007 at 11:14:52AM -0700, Kok, Auke wrote:
>> I just checked and the fix I was referring to earlier didn't make it into 
>> 2.6.21-final. You can get 2.6.21-git1 from kernel.org which has the fix. See
>>
>> http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.21-git1.log
> 
> Good. So I tried that patch (well, actually only the change visible at
> http://lkml.org/lkml/2007/3/6/268). I patched it into a 2.6.20.11 kernel,
> using the same config file as previously. The good news is that this fixes
> my issue: there are no lost ticks anymore, and the link does negotiate a
> gigabit connection. This is a great improvement for me :)
> 
> I still seem to hit an issue if using the ethtool command, though.
> when using 'ethtool -s eth0 autoneg on', the link comes up at gigabit speed,
> but a couple seconds later is comes down again, and then up at 100 megabits:
> 
> e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex
> e1000: eth0: e1000_watchdog: NIC Link is Down
> e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex
> e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
> 
> The same thing happens if I use ifdown eth0; ifup eth0 too. Once again,
> I only observe this on my DQ965GF motherboard, the DG965RY board is fine
> (stays at gigabit speed when I issue these commands).
> 
> Is this something you could easily reproduce at Intel or would you want me
> to look into that issue on my system ?

I think we have confirmed this issue and I'll work with Bruce on seeing where 
the fix went. I might give you another patch to try.

Auke
