Return-Path: <linux-kernel-owner+w=401wt.eu-S1761895AbZBEBTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761895AbZBEBTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760537AbZBEBTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:19:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:48958 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759599AbZBEBTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:19:16 -0500
Subject: Re: [PATCH 7/7] PCI PM: Let the core be more careful with respect
 to drivers using new framework
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
In-Reply-To: <200902050147.02632.rjw@sisk.pl>
References: <200902040154.36018.rjw@sisk.pl>
	 <200902040209.08633.rjw@sisk.pl> <1233713153.16867.143.camel@pasglop>
	 <200902050147.02632.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 12:18:03 +1100
Message-Id: <1233796683.4612.37.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I don't know about ppc, but on x86 the pcibios hook is only supposed to
> disable the device's interrupt link.

Right now on ppc, I may disable the clocks too, but then:

 - As soon as you have implemented the new scheme, I'll replace all that
with using the same hooks as ACPI so that won't be an issue anymore

 - Today, it's probably a non issue too because none of the devices for
which I have that sort of manual clock control also shares interrupts.

> Potentially, calling into the AML interpreter.

Right, but we are fixing that anyway with the noirq phase being AML safe
by no ? :-)
 
> When we implement the changes discussed in the "PCI PM: Restore standard
> config registers of all devices early" thread, that part will end up in
> suspend_noirq.

Yup.

Cheers,
Ben.

