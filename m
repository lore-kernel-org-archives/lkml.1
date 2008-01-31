Return-Path: <linux-kernel-owner+w=401wt.eu-S934862AbYAaX3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934862AbYAaX3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934154AbYAaX27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:28:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:24265 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934400AbYAaX25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:28:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,287,1199692800"; 
   d="scan'208";a="294761153"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Date: Thu, 31 Jan 2008 15:28:13 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC78CC73@orsmsx424.amr.corp.intel.com>
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC78C75A@orsmsx424.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Thread-Index: Achj6MJxBSJCZx/gQf+KkNIfkM+UVgATq2qQAAoYgTA=
References: <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <47A0CD4B.5040706@sgi.com> <1FE6DD409037234FAB833C420AA843EC757F12@orsmsx424.amr.corp.intel.com> <20080130194616.GA19426@elte.hu> <1FE6DD409037234FAB833C420AA843EC757F7C@orsmsx424.amr.corp.intel.com> <20080130200221.GA28073@elte.hu> <1FE6DD409037234FAB833C420AA843EC757FC2@orsmsx424.amr.corp.intel.com> <20080130205915.GA4562@elte.hu> <1FE6DD409037234FAB833C420AA843EC78C219@orsmsx424.amr.corp.intel.com> <20080131090642.GA5688@elte.hu> <1FE6DD409037234FAB833C420AA843EC78C75A@orsmsx424.amr.corp.intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Mike Travis" <travis@sgi.com>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       <linux-ia64@vger.kernel.org>, <sparclinux@vger.kernel.org>
X-OriginalArrivalTime: 31 Jan 2008 23:28:14.0302 (UTC) FILETIME=[F3628FE0:01C86460]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the percpu changes are innocent ... something else since 2.6.24 is
> to blame.  Only 5749 commits :-)  I'll start bisecting.

12 bisections later ... nothing!  I think I got lost in the
maze.  Bisection #5 had a crash, but it looked to be a very
differnt crash (and looked to happen later than the bug I was
hunting).  So I marked that as "good" on the theory that it
looked like this bug wasn't in the kernel. Same thing happened
at bisection #9.  But I ended up with:

commit bfada697bd534d2c16fd07fbef3a4924c4d4e014
Author: Pavel Emelyanov <xemul@openvz.org>
Date:   Sun Dec 2 00:57:08 2007 +1100

    [IPV4]: Use ctl paths to register devinet sysctls


Which just looks too improbable to be the cause of the UP
crash.  Git won't revert it out from top of tree automatically
so I can't easily test whether some weird magic means that
this is the buggy commit.

Perhaps the issue is another offset of object X in kernel w.r.t.
object Y ... and so the good/bad choices in the bisection are
actually pretty random depending on how much code is stuffed
between X & Y at each bisection point.

-Tony
