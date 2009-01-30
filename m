Return-Path: <linux-kernel-owner+w=401wt.eu-S1759704AbZA3B0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbZA3B0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZA3B0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:26:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:38312 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZA3B0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:26:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,347,1231142400"; 
   d="scan'208";a="105248094"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Oleg Orel'" <oorel@vmware.com>, "Raj, Ashok" <ashok.raj@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       "'avi@qumranet.com'" <avi@qumranet.com>,
       "'yaniv@qumranet.com'" <yaniv@qumranet.com>,
       "'Bhavesh Davda'" <bhavesh@vmware.com>,
       "'Mallik Mahalingam'" <mallik@vmware.com>,
       "'Jagannath Krishnan'" <krishnan@vmware.com>,
       "'Adar Dembo'" <adar@vmware.com>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Thu, 29 Jan 2009 17:25:56 -0800
Subject: RE: Intel IOMMU on Dell Latitude E6400, Lenovo X200 & Dell
 Precision T5400
Thread-Topic: Intel IOMMU on Dell Latitude E6400, Lenovo X200 & Dell
 Precision T5400
Thread-Index: AcmCXSgsZiQmA6iDShi0pf11c3VFfwAGjszg
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8927A8E8E@orsmsx505.amr.corp.intel.com>
References: <49822738.5060103@vmware.com>
In-Reply-To: <49822738.5060103@vmware.com>
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



>We had reported more details @
>https://bugzilla.redhat.com/show_bug.cgi?id=479996 and
>http://bugzilla.kernel.org/show_bug.cgi?id=11821

Look into http://bugzilla.kernel.org/show_bug.cgi?id=11821
and find that:

wlan0: Failed to config new SSID to the low-level driver
BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
IP: [<ffffffff8037cf1f>] pci_find_upstream_pcie_bridge+0x1f/0xa0
...
[<ffffffff80386808>] get_domain_for_dev+0x58/0x620
 [<ffffffff8029574d>] ? __alloc_pages_internal+0xed/0x4f0
 [<ffffffff803870f8>] get_valid_domain_for_dev+0x18/0x150
 [<ffffffff803875e7>] intel_map_single+0x47/0x160
 [<ffffffff802b8726>] ? alloc_pages_current+0x76/0xf0
 [<ffffffff8038777f>] intel_alloc_coherent+0x7f/0xb0
...

Wireless LAN could cause the NULL pointer access in get_domain_for_dev() which is IOMMU function.

As an experiment, could you disable wireless lan on your machine and try to boot IOMMU kernel?

Thanks.

-Fenghua
