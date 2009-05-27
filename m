Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbZE0XZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbZE0XZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZE0XZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:25:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:44860 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZE0XZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:25:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,261,1241420400"; 
   d="scan'208";a="519431513"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
CC: "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "'mingo@elte.hu'" <mingo@elte.hu>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>
Date: Wed, 27 May 2009 16:25:52 -0700
Subject: RE: [PATCH] Time out for possible dead loops during queued
 invalidation wait
Thread-Topic: [PATCH] Time out for possible dead loops during queued
 invalidation wait
Thread-Index: AcnfHVZYJP52T0+QSQOVnUWH879SgQAAVOog
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8AF933281@orsmsx505.amr.corp.intel.com>
References: <20090327212241.234500000@intel.com>
	<20090327212321.070229000@intel.com>
	<20090416001957.GA1527@linux-os.sc.intel.com>
	<1240135508.3589.75.camel@macbook.infradead.org>
	<A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
	<20090520174259.GA10646@linux-os.sc.intel.com>
	<20090526225146.2faeeb05.akpm@linux-foundation.org>
	<A6AD88C3F2289247BE726C37303E1EB8AF9331CE@orsmsx505.amr.corp.intel.com>
 <20090527154816.23541b2a.akpm@linux-foundation.org>
In-Reply-To: <20090527154816.23541b2a.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Which error code is better? Is EAGAIN ok?
>
>That depends on driver details - probably EIO would be suitable, dunno.
>
>But all the callers of qi_submit_sync() seem to just drop the error
>code on the floor:
>
>	/* should never fail */
>	qi_submit_sync(&desc, iommu);
>
>and may well cause a kernel crash as a result.

Should the code go to kernel panic after timeout in qi_submit_sync() loops? When timeout (10 seconds) in the loops, something in hardware could be wrong.

Thanks.

-Fenghua
