Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXJaQ0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXJaQ0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbXJaQ0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:26:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:13883 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756959AbXJaQ0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:26:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,352,1188802800"; 
   d="scan'208";a="364362285"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [patch] __do_IRQ does not check IRQ_DISABLED when IRQ_PER_CPU is set
Date: Wed, 31 Oct 2007 09:20:27 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A02D2142E@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20071030162657.GA21728@sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] __do_IRQ does not check IRQ_DISABLED when IRQ_PER_CPU is set
Thread-Index: AcgbFfMEX8GjXO/vS5Ov93CfzLfGvgAw7BTA
References: <20071030162657.GA21728@sgi.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Russ Anderson" <rja@sgi.com>, "LKML" <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 31 Oct 2007 16:20:28.0327 (UTC) FILETIME=[F3449370:01C81BD9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> One user encountering this behavior is the CPE handler (in 
> arch/ia64/kernel/mca.c).  When the CPE handler encounters too many
> CPEs (such as a solid single bit error), it sets up a polling timer
> and disables the CPE interrupt (to avoid excessive overhead logging
> the stream of single bit errors).  disable_irq_nosync() is called
> which sets IRQ_DISABLED.  The IRQ_PER_CPU flag was previously set
> (in ia64_mca_late_init()).  The net result is the CPE handler gets
> called even though it is marked disabled.

Presumably we are in this situation because there are still some
pending CPE interrupts on some cpus when we disable CPE?  Or is
there a more serious problem that we aren't manage to disable CPE
on all cpus properly?

-Tony
