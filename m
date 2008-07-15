Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYGOXyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYGOXyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYGOXyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:54:05 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:19319 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYGOXyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:54:03 -0400
Date: Tue, 15 Jul 2008 17:54:01 -0600
From: Alex Chiang <achiang@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 00/14] Introduce cpu_enabled_map and friends
Message-ID: <20080715235401.GG10919@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	linux-ia64@vger.kernel.org
References: <20080715023344.2528.1836.stgit@blender.achiang> <57C9024A16AD2D4C97DC78E552063EA306594DA5@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA306594DA5@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't include linux-ia64 originally. Sorry about that.

Here is the 00/14 cover email describing the patch series:

	http://lkml.org/lkml/2008/7/14/468

Here is the 12/14 ia64 specific bit:

	http://lkml.org/lkml/2008/7/14/478

Here is the 14/14 patch that Tony is referring to:

	http://lkml.org/lkml/2008/7/14/482

* Luck, Tony <tony.luck@intel.com>:
> > Patch 14 is the money patch. It demonstrates why we might
> > want to go through all these gyrations. Now that ia64 presents
> > *all* physically present CPUs in sysfs, even if they have been
> > disabled by firmware, we give userspace a way to poke at those
> > CPUs.
> 
> There's only the one bit for "disabled by firmware" ... no extra
> space for any extra information.  How would userspace know that
> it was safe to poke at a disabled cpu?  Perhaps firmware disabled
> it for some very good reason, and poking at it could cause system
> instability.

My thought here was that it would be a vendor-specific thing. In
patch 14/14 I created:

	/sys/devices/system/cpu/cpuN/deconfigure

(although /sys/device/system/cpu/cpuN/enabled would probably be
better)

I set up 'deconfigure' to have different implementations based on
a DMI, so it is very much an opt-in (especially since it's a
Kconfig option).

It would be the responsibility of the vendor to provide something
safe to poke at. In the sample implementation I gave, nothing
happens to the system until the *next* reboot, so it shouldn't
cause the current boot any distress.

A different implementation of deconfigure/enabled could return
an error to userspace if an operation was unsafe.

/ac

