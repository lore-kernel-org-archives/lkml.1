Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbXFXPE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbXFXPE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 11:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbXFXPEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 11:04:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:52659 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbXFXPET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 11:04:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,456,1175497200"; 
   d="scan'208";a="242663470"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] driver core: multithreaded probing - more parallelismcontrol
Date: Sun, 24 Jun 2007 23:04:13 +0800
Message-ID: <9D7649D18729DE4BB2BD7B494F7FEDC2180928@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <20070624070601.GB24941@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] driver core: multithreaded probing - more parallelismcontrol
Thread-Index: Ace2O2ORtuUFmGD+TvujGa1KUYY8JAAMr1og
From: "Huang, Ying" <ying.huang@intel.com>
To: "Greg KH" <greg@kroah.com>
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Adrian Bunk" <bunk@stusta.de>, <david@lang.hm>,
       "David Miller" <davem@davemloft.net>,
       "bunk@stusta.de; Duncan Sands" <duncan.sands@math.u-psud.fr>,
       "Phillip Susi" <psusi@cfl.rr.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 24 Jun 2007 15:04:14.0394 (UTC) FILETIME=[EDB409A0:01C7B670]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Greg KH [mailto:greg@kroah.com]
>I'm still not convinced that we need to add this kind of complexity to
>the driver core, instead of just letting the individual driver
>subsystems do this, if they want to do it.

It may appear not necessary that providing more multithreaded device
probing in the driver core, but it seems more necessary that providing
more parallel control in the driver core to make some device probing
more single-threaded.

There does exist multithreaded device probing in current driver core
implementation, supposing two devices are hot-plugged at the same time.
But, many device drivers are written without this taken into account. I
think it may be better to make default device probing process more
single-threaded in the driver core. The single-thread workqueue or some
customized version of workqueue like that implemented by my patch can be
used for this. The parallel control mechanism can be used to implement
multithreaded device probing in needed subsystems too.

Best Regards,
Huang, Ying
