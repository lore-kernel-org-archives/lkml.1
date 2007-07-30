Return-Path: <linux-kernel-owner+w=401wt.eu-S967882AbXG3SmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967882AbXG3SmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965966AbXG3Slt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:41:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:14844 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966155AbXG3Sls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:41:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,199,1183359600"; 
   d="scan'208";a="256539933"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] ia64: fix a few section mismatch warnings
Date: Mon, 30 Jul 2007 11:41:45 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0209C43A@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070728061551.GA21626@uranus.ravnborg.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ia64: fix a few section mismatch warnings
Thread-Index: AcfQ3pPDHQshsEC1QDqpg4N29xThcQB+PAJA
From: "Luck, Tony" <tony.luck@intel.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 30 Jul 2007 18:41:46.0460 (UTC) FILETIME=[483641C0:01C7D2D9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Oops.  You moved the multiply by sizeof(struct ia64_mca_cpu) up into
> > the mca_bootmem() function to make it very specific to this use. But
> > mutiply has higher precedence than addition.
>
> Oh crap - good catch.
> Shall I resubmit a corrected patch?

Are there any other ways that we might tag the callsite to let
modpost know that this instance is safe?  Adding a call to a wrapper
function in __init_refok space feels kludgy, and whatever comments
you stick on that function, it is sitting there waiting for someone
who shouldn't to make a call.

If not ... then just make the mca_bootmem() function take
no args.  It can calculate the amount of memory, it can do
the next bit too and return a result KERNEL_STACK_SIZE aligned
too.

-Tony
