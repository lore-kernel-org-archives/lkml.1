Return-Path: <linux-kernel-owner+w=401wt.eu-S938060AbXG0Wc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938060AbXG0Wc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764914AbXG0WcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:32:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:17726 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764375AbXG0WcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:32:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,192,1183359600"; 
   d="scan'208";a="273675753"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] ia64: fix a few section mismatch warnings
Date: Fri, 27 Jul 2007 15:32:13 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0209BADF@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070727074413.GA11424@uranus.ravnborg.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ia64: fix a few section mismatch warnings
Thread-Index: AcfQIcGdHHqq/sYTQeSdOyJ1DoDklgAe9Bpg
From: "Luck, Tony" <tony.luck@intel.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 27 Jul 2007 22:32:14.0175 (UTC) FILETIME=[FAEEDEF0:01C7D09D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-		mca_data = alloc_bootmem(sizeof(struct ia64_mca_cpu)
-					 * NR_CPUS + KERNEL_STACK_SIZE);
+		mca_data = mca_bootmem(NR_CPUS + KERNEL_STACK_SIZE);

Oops.  You moved the multiply by sizeof(struct ia64_mca_cpu) up into
the mca_bootmem() function to make it very specific to this use. But
mutiply has higher precedence than addition.

-Tony
