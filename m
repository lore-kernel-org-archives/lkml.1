Return-Path: <linux-kernel-owner+w=401wt.eu-S1030267AbXAaQo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030267AbXAaQo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030268AbXAaQo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:44:27 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:29326 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030267AbXAaQo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:44:26 -0500
Subject: Re: [PATCH 14/23] clocksource: increase initcall priority
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070131115055.GD1847@elte.hu>
References: <20070131033710.420168478@mvista.com>
	 <20070131033807.427331295@mvista.com>  <20070131115055.GD1847@elte.hu>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 08:42:55 -0800
Message-Id: <1170261775.9781.100.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 12:50 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > -module_init(init_acpi_pm_clocksource);
> > +/*
> > + * This clocksource is removed from the clocksource_initcall
> > + * macro since it's mandatory for it to be in fs_initcall as the
> > + * highest initcall level, or else it doesn't work properly with
> > + * it's PCI fix ups.
> > + */
> > +fs_initcall(init_acpi_pm_clocksource);
> 
> ugh - this bit looks quite interesting.
> 
> what's the purpose of this patch? Switching to high-res timers should be 
> done late in the bootup - in case there's a problem it's more 
> debuggable, etc.

The timekeeping code, and hrt/dynamic tick both wait till after boot up
to switch to high res mode ..

The specific code block you commented on above was added cause acpi_pm
has special pci fixups that don't function properly earlier in boot up.
So it can't be arbitrarily raised to order in the initcall sequence ..

Daniel


