Return-Path: <linux-kernel-owner+w=401wt.eu-S936948AbXGTWI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936948AbXGTWI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760420AbXGTWIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:08:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:31942 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759269AbXGTWIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:08:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,564,1175497200"; 
   d="scan'208";a="270891895"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: build fix for x86_64...
Date: Fri, 20 Jul 2007 15:08:09 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01FA4C43@scsmsx411.amr.corp.intel.com>
In-Reply-To: <46A10D12.5000903@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: build fix for x86_64...
Thread-Index: AcfLFV674fHxbh7jTrGQ55OhkSCoBQAA4pSw
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <ak@suse.de>
Cc: "Andreas Schwab" <schwab@suse.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Arthur Jones" <arthur.jones@qlogic.com>,
       "Vasily Tarasov" <vtaras@openvz.org>, <linux-kernel@vger.kernel.org>,
       "Jan Kara" <jack@ucw.cz>, <linux-arch@vger.kernel.org>
X-OriginalArrivalTime: 20 Jul 2007 22:08:10.0419 (UTC) FILETIME=[757EF030:01C7CB1A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment our problem is that there is some code that has
been added to handle the compatability problem caused by u64
objects having different alignment when running on 32-bit and
64-bit systems.  This only affects ia64 and x86-64 because all
the other 32/64 bit capable systems wisely avoided this issue
by making 64-bit objects *always* 8-byte aligned.

It is possible that in the future more such issues will arise
(either because we find some more existing interfaces that
have this problem, or because new interfaces are introduced
that also have this problem).  Such new code will also require
some compatability functions.  These functions will also only
be needed on ia64 and x86-64, and even on these systems the
code will only be needed if CONFIG_COMPAT=y

So I'm failing to see what's wrong with putting such compatabilty
code inside a

#if defined(CONFIG_COMPAT_FOR_U64_ALIGNMENT)
...
#endif

to prevent it wasting object code space in kernels that don't
need it.

-Tony
