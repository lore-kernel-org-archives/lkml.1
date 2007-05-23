Return-Path: <linux-kernel-owner+w=401wt.eu-S1758315AbXEWS1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbXEWS1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbXEWS1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:27:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:53561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbXEWS1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:27:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,570,1170662400"; 
   d="scan'208";a="246517595"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Date: Wed, 23 May 2007 11:26:53 -0700
Message-ID: <79E93560F4A5FD42BB769DAAF8BEF62A01AA8C77@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070523104946.f279241c.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Thread-Index: AcedYsn36XFq/U8/RzWdd8giGOkWvQAARGIg
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <clameter@sgi.com>,
       <kiran@scalex86.org>, <rmk@arm.linux.org.uk>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 May 2007 18:26:54.0881 (UTC) FILETIME=[F0B31910:01C79D67]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> elements are cacheline aligned. And as such, this differentiates the
local
> only data and remotely accessed data cleanly.

>OK, but could we please have a concise description of the impact
>of these changes on kernel memory footprint?  Increase or decrease?
>And by approximately how much?

Depending on how linker places percpu data, the patches could
increase or decrease percpu section size. Data from 2.6.21-rc7-mm2:

On x86 SMP, the section size is increased from 0x7768 to 0x790c.
1.3% increase.

On X86-64 SMP, the size is decreased from 0x72d0 to 0x6540.
11.8% decrease.

On X86-64 VSMP, the size is increased from 0x72d0 to 0x8340.
14.3% increase.

On IA64 SMP, the size is decreased from 0x8370 to 0x7fc0.
2.8% decrease.
