Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbYAaA7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbYAaA7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYAaA7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:59:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:32380 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYAaA67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:58:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,281,1199692800"; 
   d="scan'208";a="332500669"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Date: Wed, 30 Jan 2008 16:57:37 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC78C219@orsmsx424.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Thread-Index: AchjgwwT+Vd3uaCjRc2frc6p5ctgqAAAQNgAAAfWeGA=
References: <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <47A0CD4B.5040706@sgi.com> <1FE6DD409037234FAB833C420AA843EC757F12@orsmsx424.amr.corp.intel.com> <20080130194616.GA19426@elte.hu> <1FE6DD409037234FAB833C420AA843EC757F7C@orsmsx424.amr.corp.intel.com> <20080130200221.GA28073@elte.hu> <1FE6DD409037234FAB833C420AA843EC757FC2@orsmsx424.amr.corp.intel.com> <20080130205915.GA4562@elte.hu> 
From: "Luck, Tony" <tony.luck@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Mike Travis" <travis@sgi.com>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       <linux-ia64@vger.kernel.org>, <sparclinux@vger.kernel.org>
X-OriginalArrivalTime: 31 Jan 2008 00:57:38.0145 (UTC) FILETIME=[46124D10:01C863A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll start digging on why this doesn't boot ... but you might as well
> send the fixes so far upstream to Linus so that the SMP fix is available

Well a pure 2.6.24 version compiled with CONFIG_SMP=n booted just fine, so
the breakage is recent ... and more than likely related to this change.

I've only had a casual dig at the failing case ... kernel dies in memset()
as called from kmem_cache_alloc() with the address being written as
0x4000000000117b48 (which is off in the virtual address space range used
by users ... not a kernel address).

I'll dig some more tomorrow.

-Tony
