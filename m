Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYJGUdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYJGUdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYJGUdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:33:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYJGUdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:33:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Top kernel oopses/warnings for the week of October 7th, 2008
Date: Tue, 7 Oct 2008 22:37:28 +0200
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, tglx@tglx.de,
       "Theodore Ts'o" <tytso@mit.edu>, linux-ide@vger.kernel.org
References: <48EBBE15.9030905@linux.intel.com> <200810072213.16103.rjw@sisk.pl> <20081007201617.GA20655@elte.hu>
In-Reply-To: <20081007201617.GA20655@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810072237.34572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 7 of October 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > Rank 9: device_pm_add (warning)
> > > 	Reported 81 times (323 total reports)
> > > 	Drivers with suspect suspend/resume logic; a patch is queued for 2.6.28 to identify
> > > 	which drivers are involved.
> > > 	This warning was last seen in version 2.6.27-rc4, and first seen in 2.6.26-rc5.
> > > 	More info: http://www.kerneloops.org/searchweek.php?search=device_pm_add
> > 
> > This should have been fixed by:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f5a6d958b5d0a10e7e7a9dee1862fb31d08c6d26
> 
> hm, that is:
> 
> | From f5a6d958b5d0a10e7e7a9dee1862fb31d08c6d26 Mon Sep 17 00:00:00 2001
> | From: Rafael J. Wysocki <rjw@sisk.pl>
> | Date: Sat, 9 Aug 2008 01:05:13 +0200
> | Subject: [PATCH] PM: Remove WARN_ON from device_pm_add
> |
> | PM: Remove WARN_ON from device_pm_add
> |
> | Fix message in device_pm_add() saying that the device will not be
> | added to dpm_list, although in fact the device is going to be added
> | to the list regardless of the ordering violation.
> |
> | Remove the WARN_ON(true) triggered in that situation, because it is
> | hit by USB very often and spams the users' logs.
> |
> | This patch fixes bug #11263
> 
> +               if (dev->parent->power.status >= DPM_SUSPENDING)
> +                       dev_warn(dev, "parent %s should not be sleeping\n",
>                                 dev->parent->bus_id);
> -                       WARN_ON(true);
> -               }
> 
> 
> i.e. no bug was fixed in reality - we still emit a kernel log entry, but 
> the WARN_ON() was removed, so that it does not fall under the scope of 
> kerneloops.org, right?

Sort of.  In fact, the WARN_ON() was added prematurely and caused lots of
unnecessary reports to be generated.

Thanks,
Rafael
