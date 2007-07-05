Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbXGENkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbXGENkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbXGENjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:39:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53572 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332AbXGENjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:39:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 15:47:14 +0200
User-Agent: KMail/1.9.5
Cc: Paul Mackerras <paulus@samba.org>, mjg59@srcf.ucam.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>
References: <E1I63Nv-0006Z9-00@dorka.pomaz.szeredi.hu> <200707051451.38497.rjw@sisk.pl> <1183639825.3818.38.camel@johannes.berg>
In-Reply-To: <1183639825.3818.38.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051547.15239.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 14:50, Johannes Berg wrote:
> On Thu, 2007-07-05 at 14:51 +0200, Rafael J. Wysocki wrote:
> 
> > > > Remember what I wrote a few minutes ago about khubd and ksuspend_usbd
> > > > wanting to resume devices during a system suspend transition?  This is
> > > > exactly what happens when those threads aren't frozen.
> > > 
> > > So, I wonder why I don't see that error on my powerbook?
> > 
> > Because you have only one CPU running while your suspend code is being
> > executed?
> 
> If that's really all the problem then what's wrong with just unplugging
> the other CPUs earlier? Sure, that makes suspend no longer perfectly
> transparent since userspace might notice the CPUs being unplugged, but
> it has to cope with that anyway since a user can do it manually...

This is a bit complicated, but I'll try to explain.

We used to disable the nonboot CPUs before suspending devices and enable
them after resuming devices, but that turned out to lead to resume problems on
some ACPI systems.  Namely, it turned out that this code ordering was not in
line with the ACPI spec that assumed specific ordering of events during a
suspend.  For this reason, we changed the code ordering and now it is more or
less in agreement with ACPI (for the first time, AFAICS).  I don't think that
anyone would like to revert that change right now.

Moreover, in the meantime we learned that the CPU hotplug code that we use
for disabling the nonboot CPUs, is generally problematic on x86 and only works
for us because we have the majority of interrupt sources disabled when it's
invoked.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
