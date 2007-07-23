Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbXGWQWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbXGWQWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761414AbXGWQWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:22:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:15680 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759402AbXGWQWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:22:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,571,1175497200"; 
   d="scan'208";a="253646255"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Section mismatch warnings for early memory allocations
Date: Mon, 23 Jul 2007 09:22:14 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01FEBFA2@scsmsx411.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Section mismatch warnings for early memory allocations
Thread-Index: AcfNRaD3IjNw84zHTl2y6pnixRnGsw==
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: "Sam Ravnborg" <sam@ravnborg.org>
X-OriginalArrivalTime: 23 Jul 2007 16:22:15.0308 (UTC) FILETIME=[A1B994C0:01C7CD45]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Checking for section mismatches across all of vmlinux is kicking
out a bunch of new warnings.  Many of them real, but I have a
few from routines like this:

foo(...)
{
	static int first_time = 1;

	if (first_time) {
		all_i_need = alloc_bootmem(NR_CPUS * xxx);
		first_time = 0;
	}
	... use smp_processor_id() to use pre-allocated memory ...
}


Now this is safe, since the first call to foo is made when alloc_bootmem
is still available.  But it kicks out a "Section mismatch" warning since
a non __init routine (foo) is calling an __init one.

Any suggestions on how to tell modpost that this is safe?

-Tony
