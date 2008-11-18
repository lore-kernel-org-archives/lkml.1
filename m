Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYKRPfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYKRPfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYKRPfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:35:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:55883 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751668AbYKRPfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:35:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,625,1220252400"; 
   d="scan'208";a="361547962"
From: "Luck, Tony" <tony.luck@intel.com>
To: John Keller <jpk@sgi.com>, Bernhard Walle <bwalle@suse.de>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 18 Nov 2008 07:35:15 -0800
Subject: RE: [PATCH] ia64: SN specific version of dma_get_required_mask()
Thread-Topic: [PATCH] ia64: SN specific version of dma_get_required_mask()
Thread-Index: AclJhz3mfhqW0t1hR5S8NvpIdhemOQACyGIA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35C454266@orsmsx505.amr.corp.intel.com>
References: <20081117173930.35342b31@hale.suse.de> from "Bernhard Walle" at
 Nov 17, 2008 05:39:30 PM
 <200811181408.mAIE8BHH057134@fcbayern.americas.sgi.com>
In-Reply-To: <200811181408.mAIE8BHH057134@fcbayern.americas.sgi.com>
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

> This patch addresses a problem on SN Altix systems with < 4GB, where
> device drivers using the dma_get_required_mask() API would be told
> to use 32 bit DMA, when 64 bit is more efficient.

Even if someone did configure an Altix with < 4GB (which seems a very
unlikely occurance) all of that 4G would be located above 4GB (lowest
physical address on Altix is something like 384 TB, isn't it?)

Did we really make some dma mask decisions based on the amount
of memory rather than its location?  If we do, then perhaps we
should fix this in a generic place, not in sn2 specific code.

-Tony
