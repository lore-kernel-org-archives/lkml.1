Return-Path: <linux-kernel-owner+w=401wt.eu-S933796AbYAaS2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796AbYAaS2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763053AbYAaS1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:27:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:44663 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757102AbYAaS1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:27:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,286,1199692800"; 
   d="scan'208";a="294691043"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: e1000 full-duplex TCP performance well below wire speed
Date: Thu, 31 Jan 2008 10:26:16 -0800
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F52044F9076@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080131064533.ef0ae932.billfink@mindspring.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: e1000 full-duplex TCP performance well below wire speed
Thread-Index: Achj/yDHff8hlzEFR1WyIrrytqA+dAAMO3qw
References: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu><20080130.055333.192844925.davem@davemloft.net><Pine.LNX.4.63.0801300758020.11487@trinity.phys.uwm.edu><20080130082136.1017631d@deepthought><Pine.LNX.4.63.0801301610240.19938@trinity.phys.uwm.edu><649aecc70801301617m6331bcb8i8ce60366e182c739@mail.gmail.com> <20080131064533.ef0ae932.billfink@mindspring.com>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Bill Fink" <billfink@mindspring.com>, "SANGTAE HA" <sangtae.ha@gmail.com>
Cc: "Bruce Allen" <ballen@gravity.phys.uwm.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
X-OriginalArrivalTime: 31 Jan 2008 18:26:17.0474 (UTC) FILETIME=[C4E9FE20:01C86436]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Fink wrote:
> a 2.6.15.4 kernel.  The GigE NICs are Intel PRO/1000
> 82546EB_QUAD_COPPER, 
> on a 64-bit/133-MHz PCI-X bus, using version 6.1.16-k2 of the e1000
> driver, and running with 9000-byte jumbo frames.  The TCP congestion
> control is BIC.

Bill, FYI, there was a known issue with e1000 (fixed in 7.0.38-k2) and
socket charge due to truesize that kept one end or the other from
opening its window.  The result is not so great performance, and you
must upgrade the driver at both ends to fix it.

it was fixed in commit
9e2feace1acd38d7a3b1275f7f9f8a397d09040e

That commit itself needed a couple of follow on bug fixes, but the point
is that you could download 7.3.20 from sourceforge (which would compile
on your kernel) and compare the performance with it if you were
interested in a further experiment.

Jesse
