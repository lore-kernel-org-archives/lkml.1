Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbXLMVHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbXLMVHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764505AbXLMVH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:07:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:23654 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763196AbXLMVH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:07:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="241470556"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] ia64: Avoid unnecessary TLB flushes when allocating memory
Date: Thu, 13 Dec 2007 13:07:24 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC1A3F5B@orsmsx424.amr.corp.intel.com>
In-Reply-To: <7575980D7C4188408E8BDB171DA164B73A875A92A6@G3W1111.americas.hpqcorp.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ia64: Avoid unnecessary TLB flushes when allocating memory
Thread-Index: Acg9mUUMdTafVzrMTvSV0jj3/Kue7QAMQ8LQ
References: <7575980D7C4188408E8BDB171DA164B73A875A92A6@G3W1111.americas.hpqcorp.net>
From: "Luck, Tony" <tony.luck@intel.com>
To: "de Dinechin, Christophe (Integrity VM)" 
	<christophe.de-dinechin@hp.com>,
       <linux-ia64@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, "Picco, Robert W." <robert.picco@hp.com>
X-OriginalArrivalTime: 13 Dec 2007 21:07:25.0468 (UTC) FILETIME=[293F0DC0:01C83DCC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Test case: Run 'find /usr -type f | xargs cat > /dev/null'
> in the background to fill the buffer cache, then run
> something that uses memory, e.g. 'gmake -j50 install'.
> Instrumentation showed that the number of global TLB
> purges went from a few millions down to about 170 over
> a 12 hours run of the above.

What was your system configuration for this test.  I'm running
on a 4 socket Montecito (with HT enabled, so 16 logical cpus)
with 4G of memory.  In the first hour of my test I've only
seen 125 calls where the old code would have called flush_tlb_all().
The new code managed to avoid all of these ... so it is batting
100%. This is out of just over a million calls to
ia64_global_tlb_purge().

So clearly I'm not manage to stress the system as heavily
as you did.

-Tony
