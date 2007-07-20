Return-Path: <linux-kernel-owner+w=401wt.eu-S933314AbXGTSJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbXGTSJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761531AbXGTSJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:09:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:27010 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760464AbXGTSJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:09:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,563,1175497200"; 
   d="scan'208";a="252876358"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Date: Fri, 20 Jul 2007 11:09:03 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC32903445CD4@orsmsx414.amr.corp.intel.com>
In-Reply-To: <adair8fc6o1.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
thread-index: AcfK9Yvy+9XZTNCAStGnCbGNAjNqvgAAzsEg
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Roland Dreier" <rdreier@cisco.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>, <jeff@garzik.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>
X-OriginalArrivalTime: 20 Jul 2007 18:09:03.0757 (UTC) FILETIME=[0E380BD0:01C7CAF9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Roland Dreier [mailto:rdreier@cisco.com] 
> Sent: Friday, July 20, 2007 10:43 AM
> To: Nelson, Shannon
> Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org; 
> davem@davemloft.net; jeff@garzik.org; Williams, Dan J; Leech, 
> Christopher; Waskiewicz Jr, Peter P
> Subject: Re: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
> 
> are there any devices that support MSI but not MSI-X?  If 
> not, is there any point in having code to support both?
> 
>  - R.
> 

Both igb (recently posted) and ixgbe (also recently posted) support both
MSI and MSI-X.  Right now when we try to request MSI-X vectors, if we
fail to acquire what we've asked for, we fall back to MSI support.  If
MSI fails to initialize, we fall back to legacy interrupts.  So it needs
to be there in case MSI-X allocation fails for the NIC driver.

Thanks,
-PJ Waskiewicz
