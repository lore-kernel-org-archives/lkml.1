Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbZBDCHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbZBDCHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZBDCHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:07:08 -0500
Received: from gate.crashing.org ([63.228.1.57]:52248 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbZBDCHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:07:07 -0500
Subject: Re: [PATCH 7/7] PCI PM: Let the core be more careful with respect
 to drivers using new framework
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
In-Reply-To: <200902040209.08633.rjw@sisk.pl>
References: <200902040154.36018.rjw@sisk.pl>
	 <200902040209.08633.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 13:05:53 +1100
Message-Id: <1233713153.16867.143.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> For non-bridge devices without drivers the PCI PM core will disable
> them and save their state on suspend.  During resume, it will put
> them into D0, if necessary, restore their state (early) and reenable
> them.

This is "without drivers" only or does it include devices that have a
driver and no PM ops ?

In the later case, the worry is that the driver will potentially still
take shared interrupts after you have disabled the device. I know the
normal disable path only disables bus mastering, which is a GOOD
thing :-) but the pcibios hook might do more here ...

I would recommend only doing that disabling in the "noirq" phase of
suspend to avoid problems here. Do you see any reason that wouldn't
work ?

Cheers,
Ben.


