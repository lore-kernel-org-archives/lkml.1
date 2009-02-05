Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbZBEArw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbZBEArw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZBEArn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:47:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48985 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbZBEArm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:47:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 7/7] PCI PM: Let the core be more careful with respect to drivers using new framework
Date: Thu, 5 Feb 2009 01:47:01 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902040154.36018.rjw@sisk.pl> <200902040209.08633.rjw@sisk.pl> <1233713153.16867.143.camel@pasglop>
In-Reply-To: <1233713153.16867.143.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050147.02632.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Benjamin Herrenschmidt wrote:
> 
> > For non-bridge devices without drivers the PCI PM core will disable
> > them and save their state on suspend.  During resume, it will put
> > them into D0, if necessary, restore their state (early) and reenable
> > them.
> 
> This is "without drivers" only or does it include devices that have a
> driver and no PM ops ?

It includes devices with drivers and without PM ops (either "legacy" or "new"),
the idea being that in the simplest cases the driver should not be required to
implement PM ops and the device should be handled nevertheless.

> In the later case, the worry is that the driver will potentially still
> take shared interrupts after you have disabled the device. I know the
> normal disable path only disables bus mastering, which is a GOOD
> thing :-) but the pcibios hook might do more here ...

I don't know about ppc, but on x86 the pcibios hook is only supposed to
disable the device's interrupt link.

> I would recommend only doing that disabling in the "noirq" phase of
> suspend to avoid problems here. Do you see any reason that wouldn't
> work ?

Potentially, calling into the AML interpreter.

When we implement the changes discussed in the "PCI PM: Restore standard
config registers of all devices early" thread, that part will end up in
suspend_noirq.

Thanks,
Rafael
