Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbYKGWzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbYKGWzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYKGWzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:55:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:40636 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYKGWzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:55:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,566,1220252400"; 
   d="scan'208";a="401294850"
From: "Duyck, Alexander H" <alexander.h.duyck@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 7 Nov 2008 14:54:55 -0800
Subject: RE: [E1000-devel] [PATCH] igb: Reinitialize tx/rx ring count on
 resume
Thread-Topic: [E1000-devel] [PATCH] igb: Reinitialize tx/rx ring count on
 resume
Thread-Index: AclBDlAtgiTKRVIvRJyuNtM5RNSDIQAHS0iQ
Message-ID: <80769D7B14936844A23C0C43D9FBCF0F23825DD9@orsmsx501.amr.corp.intel.com>
References: <20081107192056.13464.7315.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081107192056.13464.7315.stgit@elm3a70.beaverton.ibm.com>
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

Darrick J. Wong wrote:
> When suspending the device, adapter->[tr]x_ring structures are freed.
> Upon resume, these two pointers are reallocated but
> adapter->[tr]x_ring->count is not set to any value.  This causes
> igb_setup_tx_resources to fail on zero-sized buffers and thus the NIC
> doesn't come back up. 

This patch is a good start, but it ends up resetting the ring sizes on a suspend/resume which we really shouldn't be doing.  I will see about pushing a patch with the ring sizes moved up into the adapter struct.  This should help to resolve the issue and maintain the ring count through suspend/resume.

Thanks,

Alex