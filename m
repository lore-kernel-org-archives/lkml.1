Return-Path: <linux-kernel-owner+w=401wt.eu-S1030293AbXDJBk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293AbXDJBk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 21:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030295AbXDJBk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 21:40:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:16898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030283AbXDJBkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 21:40:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="71043236:sNHT19923786"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] NET: [UPDATED] Multiqueue network device support implementation.
Date: Mon, 9 Apr 2007 18:40:21 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC329029E42C6@orsmsx414.amr.corp.intel.com>
In-Reply-To: <461ADA18.8010206@trash.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] NET: [UPDATED] Multiqueue network device support implementation.
Thread-Index: Acd7Byv0uBBdXA7/TECBEfFCJzr6hwACZrpQ
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Patrick McHardy" <kaber@trash.net>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <jgarzik@pobox.com>,
       "cramerj" <cramerj@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>
X-OriginalArrivalTime: 10 Apr 2007 01:40:22.0412 (UTC) FILETIME=[343864C0:01C77B11]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This indeed looks a lot better than the first patch. I'm too 
> tired to fully review this now, but could you please post the 
> corresponding e1000 patch? From a quick look I'm guessing 
> that this patch changes the behaviour of the prio qdisc from 
> strict priority to whatever scheduling mechanism e1000 uses 
> for its queues when the multiqueue config option is enabled, 
> which might surprise people.
> 

Thanks Pat for the initial feedback.  I can post a set of patches to
e1000 using the new API; I'll try to get them out asap (need to apply to
this kernel tree).  However, the PRIO qdisc still uses the priority in
the bands for dequeueing priority, and will feed the queues on the NIC.
The e1000, and any other multiqueue NIC, will schedule Tx based on how
the PRIO qdisc feeds the queues.  So the only priority here is the
dequeuing priority from the kernel.  The e1000 will use the new API for
starting/stopping the individual queues based on the descriptors
available, much like it does today for the global queue.

-PJ Waskiewicz
