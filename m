Return-Path: <linux-kernel-owner+w=401wt.eu-S941934AbXHJUxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941934AbXHJUxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760305AbXHJUxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:53:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:20123 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759952AbXHJUxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:53:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,246,1183359600"; 
   d="scan'208";a="277264508"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] flush icache before set_pte() on ia64 take9 [2/2] flush icache at set_pte
Date: Fri, 10 Aug 2007 13:53:03 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0224C71C@scsmsx411.amr.corp.intel.com>
In-Reply-To: <ed5aea430708101146w3c08b499g99317930c7ecbd79@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] flush icache before set_pte() on ia64 take9 [2/2] flush icache at set_pte
Thread-Index: Acfbfsllqv2d43bFRu2DnhJ4GqI9/gAEHQFQ
References: <20070809135311.0676a947.kamezawa.hiroyu@jp.fujitsu.com> <20070809135721.08841cd7.kamezawa.hiroyu@jp.fujitsu.com> <617E1C2C70743745A92448908E030B2A0224C511@scsmsx411.amr.corp.intel.com> <ed5aea430708101146w3c08b499g99317930c7ecbd79@mail.gmail.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "David Mosberger-Tang" <dmosberger@gmail.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       <linux-ia64@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>, <Zoltan.Menyhart@bull.net>,
       <nickpiggin@yahoo.com.au>
X-OriginalArrivalTime: 10 Aug 2007 20:53:04.0528 (UTC) FILETIME=[72734900:01C7DB90]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What about code-size?

   text    data     bss     dec     hex filename
9499911  911620 1313065 11724596         b2e734 vmlinux-before

   text    data     bss     dec     hex filename
9504047  911620 1313065 11728732         b2f75c vmlinux-after

So about 4K extra.  In the kernel I built (tiger_defconfig) there
are 27 call-sites for __ia64_sync_icache_dcache ... so that amounts
to about 150 bytes each ... or close to 10 bundles.

> Also, is it OK to call a function from all places where a set_pte() is
> being done?  I'd hope so, but it's a really low-level operation...

These are all from normal-looking C code ... so RSE must be valid.
What other weird things might be be doing that would make it a
problem for the new code to make a function call?

-Tony
