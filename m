Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbZGHQfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbZGHQfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZGHQfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:35:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:48233 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbZGHQfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:35:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,369,1243839600"; 
   d="scan'208";a="531146327"
Subject: Re: [PATCH] cpufreq: ondemand: Introduces stepped frequency
	increase
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
In-Reply-To: <20090708161052.GA20951@srcf.ucam.org>
References: <200907081556.34682.czoccolo@gmail.com>
	 <20090708161052.GA20951@srcf.ucam.org>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 09:33:14 -0700
Message-Id: <1247070794.11545.123.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 09:10 -0700, Matthew Garrett wrote:
> On Wed, Jul 08, 2009 at 03:56:33PM +0200, Corrado Zoccolo wrote:
> > The patch introduces a new sysfs tunable cpufreq/ondemand/freq_step,
> > as found in conservative governor, to chose the frequency increase step,
> > expressed as percentage (default = 100 is previous behaviour).
> > 
> > This allows fine tuning powersaving on mobile CPUs, since smaller steps will allow to:
> > * absorb punctual load spikes
> > * stabilize at the needed frequency, without passing for more power consuming states, and
> 
> Is this a measured powersaving? The ondemand model is based on the 
> assumption that the idle state is disproportionately lower in power than 
> any running state, and therefore it's more sensible to run flat out for 
> short periods of time than run at half speed for longer. Is this 
> inherently flawed, or is it an artifact of differences in your processor 
> design?
> 

As Matthew mentioned, ondemand governor wants to run at highest speed
and get to idle sooner. Another aspect of ondemand governor is to have
very low response time for freq increase on sudden increase in load.
With freq_step, it may take long time before we can respond to sudden
increase of load from idle to full busy.

Even though you have default step as 100, as soon as we have this
variable, there will be users/distros setting it in a wrong way.

So, it will be interesting to see any data you have with and without
this change.

Alternatives to explore would be:
- Can we identify some characteristics of this system and turn this on
automatically instead of user tunable.
- Long standing goal of combining conservative and ondemand with a
mode_switch at the driver load, instead of run time tunables.

Thanks,
Venki 

