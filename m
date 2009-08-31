Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbZHaIfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbZHaIfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZHaIfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:35:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:61963 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZHaIfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:35:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,304,1249282800"; 
   d="scan'208";a="444157115"
Subject: Re: [PATCH 4/6] thermal: add sanity check for the passive attribute
From: Zhang Rui <rui.zhang@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200908261848.29897.elendil@planet.nl>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl>
	 <1251303445-25317-5-git-send-email-elendil@planet.nl>
	 <20090826162342.GA15868@srcf.ucam.org>
	 <200908261848.29897.elendil@planet.nl>
Content-Type: text/plain; charset=utf-8
Date: Mon, 31 Aug 2009 16:33:50 +0800
Message-Id: <1251707630.3483.181.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 00:48 +0800, Frans Pop wrote:
> On Wednesday 26 August 2009, Matthew Garrett wrote:
> > On Wed, Aug 26, 2009 at 06:17:23PM +0200, Frans Pop wrote:
> > > Values below 40000 milli-celsius (limit is somewhat arbitrary)
> > > don't make sense and can cause the system to go into a thermal
> > > heart attack: the actual temperature will always be lower and
> > > thus the system will be throttled down to its lowest setting.
> >
> > Not keen on this - it's a pretty arbitrary cutoff, and there are some
> > cases where someone might want this value. Policy belongs in userspace,
> > and all that.
> 
> What cases do you see? Testing? Or systems that might have to operate at 
> such a low temperature? I deliberately chose a value that's at a level 
> that's easy to reach.
> 
> I agree it is arbitrary, but it will prevent major confusion when someone 
> like me echo's 95 directly in sysfs.

this is a problem.
how about something like:
#define THERMAL_PASSIVE_WARNING_LEVEL 0x40000

if (state < THERMAL_PASSIVE_WARNING_LEVEL)
   printk(KERN_WARNING PREFIX "Passive trip point too low, this may"
          "slow down your laptop because processors are throttled "
          "whenever the temperature is higher than %dC\n", state/1000);

thanks,
rui

> Would 1000 (1 °C) perhaps be more acceptable as a limit? I doubt there are 
> valid use-cases for below 0 temps :-)

