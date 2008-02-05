Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbYBETIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbYBETIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758476AbYBETIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:08:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:32803 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYBETH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:07:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,308,1199692800"; 
   d="scan'208";a="335363610"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Date: Tue, 5 Feb 2008 11:05:03 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC8130DD@orsmsx424.amr.corp.intel.com>
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC78C75A@orsmsx424.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Thread-Index: Achj6MJxBSJCZx/gQf+KkNIfkM+UVgATq2qQAPx+iIA=
References: <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <47A0CD4B.5040706@sgi.com> <1FE6DD409037234FAB833C420AA843EC757F12@orsmsx424.amr.corp.intel.com> <20080130194616.GA19426@elte.hu> <1FE6DD409037234FAB833C420AA843EC757F7C@orsmsx424.amr.corp.intel.com> <20080130200221.GA28073@elte.hu> <1FE6DD409037234FAB833C420AA843EC757FC2@orsmsx424.amr.corp.intel.com> <20080130205915.GA4562@elte.hu> <1FE6DD409037234FAB833C420AA843EC78C219@orsmsx424.amr.corp.intel.com> <20080131090642.GA5688@elte.hu> <1FE6DD409037234FAB833C420AA843EC78C75A@orsmsx424.amr.corp.intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Mike Travis" <travis@sgi.com>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       <linux-ia64@vger.kernel.org>, <sparclinux@vger.kernel.org>
X-OriginalArrivalTime: 05 Feb 2008 19:05:28.0793 (UTC) FILETIME=[12798C90:01C8682A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Applied that patch and UP kernel built ok, and then crashed in the
> same place with the memset() to a user-looking address from kmem_cache_alloc()
>
> So the percpu changes are innocent ... something else since 2.6.24 is
> to blame.  Only 5749 commits :-)  I'll start bisecting.

The bisection narrowed in on an innocent patch in ipv4 space.  Meanwhile
the rush of patches continues.  When I retested yesterday when Linus
HEAD was 8af03e782... the CONFIG_SMP=n kernel worked perfectly.  So
maybe it was fixed?  Or maybe the bug depends on the relative
location of various bits of code/data and as the kernel grows and
shrinks with incoming changes the problem comes and goes :-(

-Tony
