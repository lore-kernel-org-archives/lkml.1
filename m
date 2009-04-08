Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbZDHKrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbZDHKrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764139AbZDHKqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:46:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:36436 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764128AbZDHKqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:46:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,344,1235980800"; 
   d="scan'208";a="129216104"
From: "Han, Weidong" <weidong.han@intel.com>
To: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 8 Apr 2009 18:44:23 +0800
Subject: [PATCH 0/2] early enable intr-remap and fix intr-remap resume
Thread-Topic: [PATCH 0/2] early enable intr-remap and fix intr-remap resume
Thread-Index: Acm4NvrwsAr8sF10TmWq7zTbMq8Paw==
Message-ID: <715D42877B251141A38726ABF5CABF2C01A2F7CAF7@pdsmsx503.ccr.corp.intel.com>
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

Interrupt remapping is decoupled from x2apic. Enables interrupt remapping early before io-apic and x2apic setup to avoid compatibility interrupts, because it's late to eanble interrupt remapping in init_dmars where io-apic interrupts are set and in compatibility mode.

In lapic_resume, it shouldn't check x2apic before resume interrupt remapping. Otherwise, interrupt remapping won't be resumed when x2apic is not enabled.

The patchset can be applied on the tip linux.

Regards,
Weidong