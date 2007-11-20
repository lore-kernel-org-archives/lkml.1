Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbXKTUEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbXKTUEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbXKTUEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:04:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:11827 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498AbXKTUEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:04:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,443,1188802800"; 
   d="scan'208";a="276481187"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: IA64 Linux 2.6.24-rc3-git1 build error
Date: Tue, 20 Nov 2007 12:04:42 -0800
Message-ID: <617E1C2C70743745A92448908E030B2A02FF1255@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20071120194028.GA7750@Krystal>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: IA64 Linux 2.6.24-rc3-git1 build error
Thread-Index: AcgrrToFMSKnYdXjSySkj2Yq/wEG+gAAntMw
References: <20071120194028.GA7750@Krystal>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Nov 2007 20:04:43.0318 (UTC) FILETIME=[97544560:01C82BB0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> unknown-linux-gnu/bin/ld: section .data.patch [a000000000000500 -> a000000000000507] overlaps section .dynamic [a0000000000003c8 -> a000000000000507]

Andrew Morton saw a similar thing and proposed

-	. = GATE_ADDR + 0x500;
+	. = GATE_ADDR + 0x600;

in gate.lds.S ... which does appear to work around the problem.

Peter Chubb dug into this a lot deeper and found the problem
only occurs with certain cross compilation environments.  See
his thoughts here:

http://marc.info/?l=linux-ia64&m=119552763704798&w=2

Your config built just fine for me using a native 3.4.6 version
of gcc.

-Tony
