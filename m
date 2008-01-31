Return-Path: <linux-kernel-owner+w=401wt.eu-S934475AbYAaSfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475AbYAaSfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933731AbYAaSeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:34:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:21422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670AbYAaSes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:34:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,286,1199692800"; 
   d="scan'208";a="511259263"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Date: Thu, 31 Jan 2008 10:34:23 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC78C75A@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080131090642.GA5688@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Thread-Index: Achj6MJxBSJCZx/gQf+KkNIfkM+UVgATq2qQ
References: <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <47A0CD4B.5040706@sgi.com> <1FE6DD409037234FAB833C420AA843EC757F12@orsmsx424.amr.corp.intel.com> <20080130194616.GA19426@elte.hu> <1FE6DD409037234FAB833C420AA843EC757F7C@orsmsx424.amr.corp.intel.com> <20080130200221.GA28073@elte.hu> <1FE6DD409037234FAB833C420AA843EC757FC2@orsmsx424.amr.corp.intel.com> <20080130205915.GA4562@elte.hu> <1FE6DD409037234FAB833C420AA843EC78C219@orsmsx424.amr.corp.intel.com> <20080131090642.GA5688@elte.hu>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Mike Travis" <travis@sgi.com>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       <linux-ia64@vger.kernel.org>, <sparclinux@vger.kernel.org>
X-OriginalArrivalTime: 31 Jan 2008 18:34:24.0484 (UTC) FILETIME=[E731D240:01C86437]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, as far as i could check, on ia64 UP the .percpu section link 
> difference was the only ia64 difference i could find out of those 
> changes. Could you try to copy a 2.6.24 include/asm-generic/percpu.h, 
> include/asm-ia64.h and include/linux/percpu.h into your current tree, 
> and see whether that boots? If yes, then it's the percpu changes. The 
> patch below does this ontop of very latest -git - and it builds fine 
> with your UP config with a crosscompiler.

Applied that patch and UP kernel built ok, and then crashed in the
same place with the memset() to a user-looking address from kmem_cache_alloc()

So the percpu changes are innocent ... something else since 2.6.24 is
to blame.  Only 5749 commits :-)  I'll start bisecting.

-Tony
