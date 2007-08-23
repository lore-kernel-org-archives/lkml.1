Return-Path: <linux-kernel-owner+w=401wt.eu-S1765289AbXHWUl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765289AbXHWUl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759388AbXHWUlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:41:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:19358 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864AbXHWUlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:41:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,301,1183359600"; 
   d="scan'208";a="267204353"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: "double" hpet clocksource && hard freeze [bisected]
Date: Thu, 23 Aug 2007 13:41:11 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com>
In-reply-to: <20070823222115.122a37ca@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: "double" hpet clocksource && hard freeze [bisected]
Thread-Index: Acflw02FNzn6TdAhSq+X/PpK1KVzoAAAcYqg
References: <20070823222115.122a37ca@localhost>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Paolo Ornati" <ornati@fastwebnet.it>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Bob Picco" <bob.picco@hp.com>, <johnstul@us.ibm.com>
X-OriginalArrivalTime: 23 Aug 2007 20:41:12.0544 (UTC) FILETIME=[F171E600:01C7E5C5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a double "hpet" entry in "available_clocksource":
>	$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>	tsc hpet hpet acpi_pm jiffies

Oops.  If seems that both drivers/char/hpet.c and arch/x86_64/kernel/hpet.c
both register a clocksource named "hpet".  Probably a result of bringing
back to life a long lost patch, and having someone else (John Stultz, according
to git blame) make a similar change to a different file in the intervening
time.

Presumably the thing to do would be merge the x86_64 specific version
into the drivers/char/hpet.c version?

-Tony
