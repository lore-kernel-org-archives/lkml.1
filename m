Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbXGYXs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbXGYXs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbXGYXsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:48:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:52766 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbXGYXsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,581,1175497200"; 
   d="scan'208";a="109998249"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm] dma: INTEL_IOATDMA build fix
Date: Wed, 25 Jul 2007 16:48:45 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02BEC331@orsmsx418.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0707260336280.3877@cselinux1.cse.iitk.ac.in>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm] dma: INTEL_IOATDMA build fix
Thread-Index: AcfPCENM/HgyLOybQWe2mrJiadUrXQADHi7g
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Satyam Sharma" <ssatyam@cse.iitk.ac.in>, <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Jul 2007 23:48:46.0441 (UTC) FILETIME=[574F8D90:01C7CF16]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma [mailto:ssatyam@cse.iitk.ac.in] 
>
>Make CONFIG_INTEL_IOATDMA select CONFIG_DCA because it uses code
>exported from said dependency:
>
># CONFIG_DCA is not set
>CONFIG_INTEL_IOATDMA=m
>
>ERROR: "alloc_dca_provider" [drivers/dma/ioatdma.ko] undefined!
>ERROR: "register_dca_provider" [drivers/dma/ioatdma.ko] undefined!
>ERROR: "unregister_dca_provider" [drivers/dma/ioatdma.ko] undefined!
>ERROR: "free_dca_provider" [drivers/dma/ioatdma.ko] undefined!
>make[1]: *** [__modpost] Error 1
>
>"select" seems ok because CONFIG_DCA looks library-like and 
>doesn't itself
>depend upon anything else.
>
>Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

Well, ioatdma should be smarter and not try to use ioat_dca.c if there
is no CONFIG_DCA.  However, until that happens, this is fine.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
