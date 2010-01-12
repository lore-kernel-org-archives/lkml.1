Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302Ab0ALFqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0ALFqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 00:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347Ab0ALFqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 00:46:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:21902 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab0ALFqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 00:46:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,260,1262592000"; 
   d="scan'208";a="483247761"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, "x86@kernel.org" <x86@kernel.org>
Date: Tue, 12 Jan 2010 13:45:02 +0800
Subject: RE: [PATCH - resend] Memory-Hotplug: Fix the bug on interface
 /dev/mem for 64-bit kernel(v1)
Thread-Topic: [PATCH - resend] Memory-Hotplug: Fix the bug on interface
 /dev/mem for 64-bit kernel(v1)
Thread-Index: AcqTHulQyTos22TpRyKo8bAH25GLDQAKj9Fw
Message-ID: <DA586906BA1FFC4384FCFD6429ECE860316C0011@shzsmsx502.ccr.corp.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com>
	<20100108124851.GB6153@localhost>
	<DA586906BA1FFC4384FCFD6429ECE86031560FC1@shzsmsx502.ccr.corp.intel.com>
	<20100111124303.GA21408@localhost>
 <20100112093031.0fc6877f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100112093031.0fc6877f.kamezawa.hiroyu@jp.fujitsu.com>
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


Hmmm....could you rewrite /dev/mem to use kernel/resource.c other than
modifing e820 maps. ?
Two reasons.
  - e820map is considerted to be stable, read-only after boot.
  - We don't need to add more x86 special codes.
[Zheng, Shaohui] Kame, when I write this patch, I also feel confused whether update e820map. Because of the dependency in function page_is_ram, so we still update it in my patch.
I see that Fengguang already draft patches to change function page_is_ram, the new page_is_ram function use kernel/resource.c instead. That is great that we can still keep a stable e820map. I will resend the patch which update variable high_memory, max_low_pfn and max_pfn only.


Thanks,
-Kame

