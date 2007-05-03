Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbXECP4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbXECP4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbXECP4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:56:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:55867 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbXECP4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:56:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,486,1170662400"; 
   d="scan'208";a="83252871"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: e1000 issue on DQ965GF board (was 24 lost ticks with 2.6.20.10 kernel)
Date: Thu, 3 May 2007 08:56:02 -0700
Message-ID: <BD524EA7912ED5469DFD0BAEF6BC752F01D46D71@orsmsx411.amr.corp.intel.com>
In-Reply-To: <463A0199.4080204@intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: e1000 issue on DQ965GF board (was 24 lost ticks with 2.6.20.10 kernel)
Thread-Index: AceNmORmsQrN4EZiQXCU/1hBBXwQQgAAJiGw
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Michel Lespinasse" <walken@zoy.org>
Cc: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Chuck Ebbert" <cebbert@redhat.com>, <linux-kernel@vger.kernel.org>,
       "Dave Jones" <davej@redhat.com>, "cramerj" <cramerj@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
X-OriginalArrivalTime: 03 May 2007 15:56:03.0997 (UTC) FILETIME=[8DB0CCD0:01C78D9B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, this was discovered through code inspection last week and I've
already made a fix (as I mentioned to Auke off-thread).  It should be
submitted upstream shortly.

-----Original Message-----
From: Kok, Auke [mailto:auke-jan.h.kok@intel.com] 
Sent: Thursday, May 03, 2007 8:37 AM
To: Michel Lespinasse
Cc: Kok, Auke-jan H; Chuck Ebbert; linux-kernel@vger.kernel.org; Dave
Jones; cramerj; Ronciak, John; Brandeburg, Jesse; Kirsher, Jeffrey T;
Allan, Bruce W
Subject: Re: e1000 issue on DQ965GF board (was 24 lost ticks with
2.6.20.10 kernel)

[Adding Bruce to the Cc, reply below]

Michel Lespinasse wrote:
> On Wed, May 02, 2007 at 11:14:52AM -0700, Kok, Auke wrote:
>> I just checked and the fix I was referring to earlier didn't make it
into 
>> 2.6.21-final. You can get 2.6.21-git1 from kernel.org which has the
fix. See
>>
>>
http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.21-git1.
log
> 
> Good. So I tried that patch (well, actually only the change visible at
> http://lkml.org/lkml/2007/3/6/268). I patched it into a 2.6.20.11
kernel,
> using the same config file as previously. The good news is that this
fixes
> my issue: there are no lost ticks anymore, and the link does negotiate
a
> gigabit connection. This is a great improvement for me :)
> 
> I still seem to hit an issue if using the ethtool command, though.
> when using 'ethtool -s eth0 autoneg on', the link comes up at gigabit
speed,
> but a couple seconds later is comes down again, and then up at 100
megabits:
> 
> e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex
> e1000: eth0: e1000_watchdog: NIC Link is Down
> e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex
> e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
> 
> The same thing happens if I use ifdown eth0; ifup eth0 too. Once
again,
> I only observe this on my DQ965GF motherboard, the DG965RY board is
fine
> (stays at gigabit speed when I issue these commands).
> 
> Is this something you could easily reproduce at Intel or would you
want me
> to look into that issue on my system ?

I think we have confirmed this issue and I'll work with Bruce on seeing
where 
the fix went. I might give you another patch to try.

Auke
