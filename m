Return-Path: <linux-kernel-owner+w=401wt.eu-S1763973AbXGTVyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763973AbXGTVyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbXGTVyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:54:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:29261 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbXGTVyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:54:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,564,1175497200"; 
   d="scan'208";a="108350735"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Date: Fri, 20 Jul 2007 14:54:29 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02B81B3A@orsmsx418.amr.corp.intel.com>
In-Reply-To: <1a297b360707201449q73637216w81859b01ab3e5b7e@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Thread-Index: AcfLF82I3QimgFMdSRO2SZSfFpogEwAAFlAw
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Manu Abraham" <abraham.manu@gmail.com>,
       "Roland Dreier" <rdreier@cisco.com>
Cc: "Leech, Christopher" <christopher.leech@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>, <jeff@garzik.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
X-OriginalArrivalTime: 20 Jul 2007 21:54:29.0897 (UTC) FILETIME=[8C6D3790:01C7CB18]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manu Abraham [mailto:abraham.manu@gmail.com] 
>Sorry for being not clear. What i was asking is thus:
>
>A device that has legacy interrupts and MSI-X. I was thinking that if
>MSI-X failed one should fall back to MSI mode (single message), that's
>what i was assuming.
>
>In such a case, i do enable MSI-X mode on the device, when the request
>for 2 ^ n  number of messages (where messages can be a max of 32), If
>the request fails one falls into a single message mode, ie MSI ?
>
>
>> What device do you have in mind?
>
>
>The device that i have in mind is a SAA7160.

Notice our code looks at the return from pci_enable_msix() - it will
give you a hint whether MSI-X is not supported (returns < 0) or you
simply asked for too many (returns > 0).  If the former, then fallback
to legacy; if the latter, try MSI-X with only one interrupt, which
essentially emulates MSI mode.

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
