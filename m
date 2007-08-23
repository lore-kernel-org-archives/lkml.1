Return-Path: <linux-kernel-owner+w=401wt.eu-S1763585AbXHWVGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763585AbXHWVGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbXHWVGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:06:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52398 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbXHWVGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:06:03 -0400
Subject: RE: "double" hpet clocksource && hard freeze [bisected]
From: john stultz <johnstul@us.ibm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Picco <bob.picco@hp.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com>
References: <20070823222115.122a37ca@localhost>
	 <617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 14:05:35 -0700
Message-Id: <1187903135.6024.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 13:41 -0700, Luck, Tony wrote:
> > I have a double "hpet" entry in "available_clocksource":
> >	$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> >	tsc hpet hpet acpi_pm jiffies
> 
> Oops.  If seems that both drivers/char/hpet.c and arch/x86_64/kernel/hpet.c
> both register a clocksource named "hpet".  Probably a result of bringing
> back to life a long lost patch, and having someone else (John Stultz, according
> to git blame) make a similar change to a different file in the intervening
> time.
> 
> Presumably the thing to do would be merge the x86_64 specific version
> into the drivers/char/hpet.c version?

Ugh. Yea. i386 has an hpet clocksource as well. We should kill the
duplication, but at the moment I'm not comfortable that the
driver/char/hpet.c is ok to be used for i386/x86_64 (Bob: Do you know
why the shift value is only 10?).


I'm a little surprised by this, as the clocksource code use to prevent
duplicate named clocksources from being registered, so I'm not sure how
that check got dropped.  Also I'm not quite sure I see where the hard
freeze is coming from.

My initial reaction would be to either ifdef ia64 implementation in
drivers/char/hpet.c or move the code under the ia64 arch dir until it is
really usable by all arches.

Bob, your thoughts?

