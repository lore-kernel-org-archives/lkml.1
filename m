Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZHaKad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZHaKad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZHaKac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:30:32 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:60056 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbZHaKab convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:30:31 -0400
From: Frans Pop <elendil@planet.nl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 4/6] thermal: add sanity check for the passive attribute
Date: Mon, 31 Aug 2009 12:30:30 +0200
User-Agent: KMail/1.9.9
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl> <200908261848.29897.elendil@planet.nl> <1251707630.3483.181.camel@rzhang-dt>
In-Reply-To: <1251707630.3483.181.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908311230.32021.elendil@planet.nl>
X-OriginalArrivalTime: 31 Aug 2009 10:30:32.0534 (UTC) FILETIME=[11914F60:01CA2A26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 August 2009, Zhang Rui wrote:
> On Thu, 2009-08-27 at 00:48 +0800, Frans Pop wrote:
> > On Wednesday 26 August 2009, Matthew Garrett wrote:
> > > On Wed, Aug 26, 2009 at 06:17:23PM +0200, Frans Pop wrote:
> > > > Values below 40000 milli-celsius (limit is somewhat arbitrary)
> > > > don't make sense and can cause the system to go into a thermal
> > > > heart attack: the actual temperature will always be lower and
> > > > thus the system will be throttled down to its lowest setting.
> > >
> > > Not keen on this - it's a pretty arbitrary cutoff, and there are
> > > some cases where someone might want this value. Policy belongs in
> > > userspace, and all that.
> >
> > What cases do you see? Testing? Or systems that might have to operate
> > at such a low temperature? I deliberately chose a value that's at a
> > level that's easy to reach.
> >
> > I agree it is arbitrary, but it will prevent major confusion when
> > someone like me echo's 95 directly in sysfs.
>
> this is a problem.
> how about something like:
> #define THERMAL_PASSIVE_WARNING_LEVEL 0x40000

Hmmm. 40000 hexadecimal? That seems a bit high ;-)

> if (state < THERMAL_PASSIVE_WARNING_LEVEL)
>    printk(KERN_WARNING PREFIX "Passive trip point too low, this may"
>           "slow down your laptop because processors are throttled "
>           "whenever the temperature is higher than %dC\n", state/1000);

Disadvantage is that users are unlikely to actually see that message at 
the time they set the value, especially if they're working in some xterm. 
They'd have to check dmesg or log files. It also increases the .text size 
of the module for an option that very few people are likely to use.

> > Would 1000 (1 °C) perhaps be more acceptable as a limit? I doubt
> > there are valid use-cases for below 0 temps :-)

I'd prefer this option. Do you see any downside to this?

Cheers,
FJP
