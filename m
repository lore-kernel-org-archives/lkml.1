Return-Path: <linux-kernel-owner+w=401wt.eu-S1762496AbXGRGdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762496AbXGRGdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXGRGda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:33:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52395 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbXGRGd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:33:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Resend][PATCH 1/9] ACPI: Implement the set_target() callback from pm_ops
Date: Wed, 18 Jul 2007 08:41:10 +0200
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Len Brown <len.brown@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Paul Mackerras <paulus@samba.org>, Russell King <rmk@arm.linux.org.uk>
References: <200707172236.28895.rjw@sisk.pl> <200707172240.08494.rjw@sisk.pl> <20070717170201.c301cd06.akpm@linux-foundation.org>
In-Reply-To: <20070717170201.c301cd06.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707180841.11481.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 18 July 2007 02:02, Andrew Morton wrote:
> On Tue, 17 Jul 2007 22:40:06 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > In the future some drivers may need to use ACPI to determine the low power
> > states in which to place their devices, but to provide the drivers with this
> > information the ACPI core needs to know what sleep state the system is going to
> > enter.  Namely, the device's state should not be too high power for given system
> > sleep state and, if the device is supposed to be able to wake up the system, its
> > state should not be too low power for the wake up to be possible).  For this
> > purpose, the ACPI core needs to implement the set_target() method in 'struct
> > pm_ops' and store the target system sleep state passed by the PM core in a
> > variable.
> > 
> 
> Len, I can add this to the to-send-to-Len queue, but it would be more
> convenient at this end if you were to ack it and I'll send it in. 
> Preferences?
> 
> 
> > 
> > Index: linux-2.6.22-git5/drivers/acpi/sleep/main.c
> > ===================================================================
> > --- linux-2.6.22-git5.orig/drivers/acpi/sleep/main.c
> > +++ linux-2.6.22-git5/drivers/acpi/sleep/main.c
> > @@ -34,34 +34,54 @@ static u32 acpi_suspend_states[] = {
> >  
> >  static int init_8259A_after_S1;
> >  
> > +extern int acpi_sleep_prepare(u32 acpi_state);
> > +extern void acpi_power_off(void);
> 
> weep.  Please don't do this.

Well, in fact I didn't add those.  They were just moved from below the comment
before acpi_pm_prepare().  Seems logical to me ...

> checkpatch will detect this error.

Well, I'd call it a false positive. :-)
