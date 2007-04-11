Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbXDKPk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbXDKPk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbXDKPk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:40:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:7175 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbXDKPk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:40:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,395,1170662400"; 
   d="scan'208"; a="228476625:sNHT83087186"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] NET: [UPDATED] Multiqueue network device support implementation.
Date: Wed, 11 Apr 2007 08:40:25 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC32902A1A3BC@orsmsx414.amr.corp.intel.com>
In-Reply-To: <461C766E.5030107@trash.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] NET: [UPDATED] Multiqueue network device support implementation.
Thread-Index: Acd7/QO8WI1GsqbwQiiAFFewFnkYnQAUosYw
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Patrick McHardy" <kaber@trash.net>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <jgarzik@pobox.com>,
       "cramerj" <cramerj@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>
X-OriginalArrivalTime: 11 Apr 2007 15:40:25.0927 (UTC) FILETIME=[B9782D70:01C77C4F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>+			skb->queue_mapping =
> >>>+				 
> q->prio2band[q->band2queue[band&TC_PRIO_MAX]];
> >>
> >>
> >>Does this needs to be cleared at some point again? TC actions might 
> >>redirect or mirror packets to other (multiqueue) devices.
> > 
> > 
> > If an skb is redirected to another device, the skb should 
> be filtered 
> > through that device's qdisc, yes?
> 
> 
> Yes, but the device might not have a queue or use something 
> different than prio, so the value would stay the same. I 
> think you need to clear it before enqueueing a packet or 
> alternatively when redirecting in the mirred action.
> 

I see what you're saying now - I'll set the queue_mapping to zero before
the enqueue occurs.  Thanks for the feedback.

-PJ Waskiewicz
