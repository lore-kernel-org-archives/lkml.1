Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZFCXWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZFCXWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZFCXW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:22:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:57332 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbZFCXWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:22:25 -0400
Subject: Re: [Bug #13306] hibernate slow on _second_ run
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jan Scholz <scholz@fias.uni-frankfurt.de>
In-Reply-To: <200906040100.35254.rjw@sisk.pl>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	 <200906032210.54854.rjw@sisk.pl> <1244067926.27194.35.camel@pasglop>
	 <200906040100.35254.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 09:19:57 +1000
Message-Id: <1244071197.27194.39.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 01:00 +0200, Rafael J. Wysocki wrote:
> 
> > I'll try to tackle the trackpad problem.
> 
> Perhaps the VIA-PMU interrupt shouldn't be disabled in
> suspend_device_irqs()?

Possibly, but then we did use to have all interrupts disabled
at some stage before going to suspend_late anyway no ? So it shouldn't
make a big difference.

The VIA interrupt must not be HW masked in the PIC on some machines
because it's the wakeup source, so we may have to force re-enable it
since it can be lazy-disabled, but those aren't the machines with the
trackpad problem so I think I'll need to have a closer look at what's
going on and get my head around it.

Haven't had a chance yet, hopefully today or tomorrow.

Ben.


