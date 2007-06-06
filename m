Return-Path: <linux-kernel-owner+w=401wt.eu-S934458AbXFFB4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458AbXFFB4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934418AbXFFB4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:56:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:39475 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934411AbXFFB4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,387,1175497200"; 
   d="scan'208";a="93875892"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [RFC] Extend Linux to support proportional-share scheduling
Date: Tue, 5 Jun 2007 18:56:17 -0700
Message-ID: <5FD5754DDBA0B1499B5A0B4BB54194850130685D@fmsmsx411.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC] Extend Linux to support proportional-share scheduling
Thread-Index: Acen3d7OmzpetATOQ6qqLLbaGyuqCw==
From: "Li, Tong N" <tong.n.li@intel.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Con Kolivas" <kernel@kolivas.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Bill Huey \(hui\)" <billh@gnuppy.monkey.org>, <vatsa@in.ibm.com>,
       <balbir@in.ibm.com>, "Nick Piggin" <npiggin@suse.de>,
       "Bill Davidsen" <davidsen@tmr.com>,
       "John Kingman" <kingman@storagegear.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>, "Willy Tarreau" <w@1wt.eu>,
       <seuler.shi@gmail.com>
X-OriginalArrivalTime: 06 Jun 2007 01:56:18.0343 (UTC) FILETIME=[DF8BA370:01C7A7DD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've ported my code to mainline 2.6.21.3. You can get it at
http://www.cs.duke.edu/~tongli/linux/. As I said before, the intent of
the patch is not to compete with CFS and SD because the design relies on
the underlying scheduler for interactive performance. The goal here is
to present a complementary design that can ensure stronger MP fairness,
which I think is lacking in the existing proposals. Here's a brief
overview of the design (I call it Trio for the lack of a better name).
Any comments or suggestions will be highly appreciated.

Trio extends the existing Linux scheduler with support for
proportional-share scheduling. It uses a scheduling algorithm, called
Distributed Weighted Round-Robin (DWRR), which retains the existing
scheduler design as much as possible, and extends it to achieve
proportional fairness with O(1) time complexity and a constant error
bound, compared to the ideal fair scheduling algorithm. The goal of Trio
is not to improve interactive performance; rather, it relies on the
existing scheduler for interactivity and extends it to support MP
proportional fairness.

Trio has two unique features: (1) it enables users to control shares of
CPU time for any thread or group of threads (e.g., a process, an
application, etc.), and (2) it enables fair sharing of CPU time across
multiple CPUs. For example, with ten tasks running on eight CPUs, Trio
allows each task to take an equal fraction of the total CPU time,
whereas no existing scheduler achieves such fairness. These features
enable Trio to complement the mainline scheduler and other proposals
such as CFS and SD to enable greater user flexibility and stronger
fairness.

  tong
