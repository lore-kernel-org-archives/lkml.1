Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbXC3Utj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbXC3Utj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 16:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbXC3Utj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 16:49:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:28104 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbXC3Uti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 16:49:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,355,1170662400"; 
   d="scan'208"; a="219454027:sNHT3692774547"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
Date: Fri, 30 Mar 2007 13:49:20 -0700
Message-ID: <08FE5CC30C9A3F41BF819A502CF7BF6E0100376E@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <m14po2iilg.fsf@ebiederm.dsl.xmission.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
Thread-Index: AcdzCbIkURbW1/1DTrqcXuhgahJn6AAAYKfA
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, "Greg KH" <gregkh@suse.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <linux-kernel@vger.kernel.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
X-OriginalArrivalTime: 30 Mar 2007 20:49:21.0373 (UTC) FILETIME=[E47FC8D0:01C7730C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:

>The bug report would be phrased as someone seeing "No irq for vector"
>on x86_64.  Unless they are a skilled developer they are unlikely to
>trace it down to not flushing posted writes to a MSI bar during irq
>migration.  It part it is a subtle hardware/software race.
>
>I have seen some unresolved bug reports described this way on machines
>that have MSI-X capable hardware.  The are against fedora core and I
>can't haven't been able to get the reporters to try 2.6.21-rcX and
>the other irq back ports don't work so well.
>
>I currently count 7 drivers in 2.6.21 that are susceptible to the race
>this bug closes.
>
>This version of the patch seems to meet all of the criteria for being
>obviously correct, and all it does is insert a stupid readl.  Not
>very dangerous.
>
>This fix removes a race between hardware and software that you likely
>need to migrate MSI-X irqs a lot to trigger.  Which can be the kind of
>thing that bytes you after you have a month of uptime.  This is a very
>nasty condition to track down from bug reports.  I'd rather not have a
>known culprit out there.

Agreed, this is a subtle bug, and was a real hairball to track down.
Even so, I'm surprised that nobody else has dug into this, since it
should affect anybody running MSI-X.  I originally thought I was seeing
a hardware bug, which is why I dug more deeply into the issue.

If Eric is seeing bug reports related to "no vector for IRQ" in the
wild, then I have to change my stance and agree that this should be
pushed to -stable.  Every one of those messages indicates that we
hit the race condition.

-Mitch
