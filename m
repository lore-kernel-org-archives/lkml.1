Return-Path: <linux-kernel-owner+w=401wt.eu-S933803AbYBNWZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbYBNWZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbYBNWZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:25:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:50877 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270AbYBNWZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:25:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,355,1199692800"; 
   d="scan'208";a="518828096"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Date: Thu, 14 Feb 2008 14:23:59 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC97C8B0@orsmsx424.amr.corp.intel.com>
In-Reply-To: <ada7ih7qjoq.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Thread-Index: AchvVhUDrx6aFLjqQyyNAykgu2HocAAAZu9w
References: <20080213125725.GC6344@elte.hu><20080213.050340.64342037.davem@davemloft.net><12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com><20080213.170452.68851396.davem@davemloft.net><12c511ca0802131933g6aaaec9cidbfbfcac6f394c63@mail.gmail.com><adaprv0rygh.fsf@cisco.com><12c511ca0802141327j6e31e8c2tee1d679053b604fc@mail.gmail.com> <ada7ih7qjoq.fsf@cisco.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Roland Dreier" <rdreier@cisco.com>
Cc: "David Miller" <davem@davemloft.net>, <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Feb 2008 22:24:15.0912 (UTC) FILETIME=[554F3A80:01C86F58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess sched_init() is too early... it does seem really strange to
> me, but I just double checked with Ingo's patch and it does indeed
> hang.  The slow way to make progress is just to go through
> start_kernel() line-by-line and enable cpu_clock() at each stage, and
> see where it stops hanging.  I'll give that a shot as a background
> process (my ia64 box takes quite a while to boot, so each test takes a
> long time but requires very little of my attention).

We *ought* to be safe after cpu_init() ... which is called from setup_arch(),
which is several calls before sched_init().

Thanks for looking at this though ... my ability to test just went
away for a while ... some lab re-organization means all my systems
just got powered off and removed from their rack so the rack can be
moved to a new location.

-Tony
