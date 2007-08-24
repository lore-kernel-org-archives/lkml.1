Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbXHXQEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbXHXQEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbXHXQEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:04:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:60423 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbXHXQEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:04:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,305,1183359600"; 
   d="scan'208";a="267593069"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: "double" hpet clocksource && hard freeze [bisected]
Date: Fri, 24 Aug 2007 09:04:22 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A023EB8C4@scsmsx411.amr.corp.intel.com>
In-reply-to: <20070824152745.56214a24@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: "double" hpet clocksource && hard freeze [bisected]
Thread-Index: AcfmUpXPjsjONoNaR3GzTLZ/6bELRwAFK71w
References: <20070823222115.122a37ca@localhost><617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com><1187903135.6024.18.camel@localhost.localdomain><1187905306.6024.24.camel@localhost.localdomain><20070824124631.GF10594@localhost> <20070824152745.56214a24@localhost>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Paolo Ornati" <ornati@fastwebnet.it>, "Bob Picco" <bob.picco@hp.com>
Cc: "john stultz" <johnstul@us.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Bob Picco" <bob.picco@hp.com>
X-OriginalArrivalTime: 24 Aug 2007 16:04:23.0209 (UTC) FILETIME=[6FEC4190:01C7E668]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Prevent duplicate names being registered with clocksource. This also
> > eliminates the duplication of hpet clock registration when the arch
> > uses the hpet timer and the hpet driver does too. The patch was
> > compile and link tested.
>
> This one works too.

It is good to avoid registering two clocksources with the same name, but
the fix might be a bit more fragile than the eariler one that temporarily
marked the drivers/char/hpet.c one as CONFIG_IA64 only.  Given that the
hang went away when you applied the earlier patch, I conclude that the
drivers/char/hpet.c code is the one that got selected when you had two
"hpet" entries ... and that there is something wrong with that code that
doesn't work right on x86_64.  The fix to prevent registering a duplicate
name is presumably working for you simply because arch/x86_64/kernel/hpet.c
happens to get there first with its "hpet", so the drivers/char/hpet.c one
is dropped.  If something changed that reversed the order of these registrations,
then you'd get the "hpet" clocksource that results in a hang.

-Tony
