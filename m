Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbXEEQBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbXEEQBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXEEQBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:01:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60648 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933156AbXEEQB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:01:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
Date: Sat, 5 May 2007 12:16:38 +0200
User-Agent: KMail/1.9.5
Cc: Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
References: <200705041132.32227.rjw@sisk.pl> <20070504233135.4671cd98.akpm@linux-foundation.org>
In-Reply-To: <20070504233135.4671cd98.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705051216.39780.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 May 2007 08:31, Andrew Morton wrote:
> On Fri, 4 May 2007 11:32:31 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Separate the hibernation (aka suspend to disk code) from the other suspend code.
> > In particular:
> >  * Remove the definitions related to hibernation from include/linux/pm.h
> >  * Introduce struct hibernation_ops and a new hibernate() function to hibernate
> >    the system, defined in include/linux/suspend.h
> >  * Separate suspend code in kernel/power/main.c from hibernation-related code
> >    in kernel/power/disk.c and kernel/power/user.c (with the help of
> >    hibernation_ops)
> >  * Switch ACPI (the only user of pm_ops.pm_disk_mode) to hibernation_ops
> 
> This causes the long-suffering Vaio to fail to power off during suspend
> to disk.  It says "Please power me down manually".

Hmm, looks like a failure of acpi_hibernation_enter().  Can you please put a
printk() in there, after local_irq_restore()?

> <debugs a bit>
> 
> machine_ops.halt(); points at native_machine_halt(), which is a no-op.
> 
> However `halt -p' still works OK.  How come it is not similarly affected?

'halt -p' probably uses acpi_power_off() (which calls
acpi_enter_sleep_state(ACPI_STATE_S5))
