Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbXDIVwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbXDIVwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbXDIVwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:52:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:38117 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbXDIVwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:52:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="210612368:sNHT20020077"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] NET: Multiqueue network device support implementation.
Date: Mon, 9 Apr 2007 14:52:12 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC329029E400C@orsmsx414.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.61.0704092332030.22295@yvahk01.tjqt.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] NET: Multiqueue network device support implementation.
Thread-Index: Acd677icaORPpQoDT6e0CpY2yt8gXQAAUk+A
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <jgarzik@pobox.com>,
       "cramerj" <cramerj@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>
X-OriginalArrivalTime: 09 Apr 2007 21:52:12.0990 (UTC) FILETIME=[54B05DE0:01C77AF1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> 
> On Apr 9 2007 14:28, Peter P Waskiewicz Jr wrote:
> >@@ -3345,6 +3358,7 @@ void free_netdev(struct net_device *dev)  {  
> >#ifdef CONFIG_SYSFS
> > 	/*  Compatibility with error handling in drivers */
> >+	kfree((char *)dev->egress_subqueue);
> > 	if (dev->reg_state == NETREG_UNINITIALIZED) {
> > 		kfree((char *)dev - dev->padded);
> > 		return;
> >@@ -3356,6 +3370,7 @@ void free_netdev(struct net_device *dev)
> > 	/* will free via device release */
> > 	put_device(&dev->dev);
> > #else
> >+	kfree((char *)dev->egress_subqueue);
> > 	kfree((char *)dev - dev->padded);
> > #endif
> > }
> 
> Ahem. Explain that cast.

Jan,
	This can be removed if needed; however, I'm just copying what
the other kfree()'s are doing in this function.  Any instance of a
typecast that I introduced in these patches are just following what
others have done in that section of the code.  So the cast is just for
consistency in this particular area.  If you'd like me to remove it, I
can do that.

Thanks,

-PJ Waskiewicz
