Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZGMQ7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZGMQ7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbZGMQ7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:59:07 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:64338 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZGMQ7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:59:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEALMEW0qrR7O6/2dsb2JhbAC4WYgjjmQFhAk
X-IronPort-AV: E=Sophos;i="4.42,391,1243814400"; 
   d="scan'208";a="176454785"
From: Roland Dreier <rdreier@cisco.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com>
	<200907111821.47769.rusty@rustcorp.com.au>
	<20090711084958.69ff9196@infradead.org>
	<200907121410.39874.rusty@rustcorp.com.au>
	<87skh29ru2.fsf@basil.nowhere.org>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 13 Jul 2009 09:59:04 -0700
In-Reply-To: <87skh29ru2.fsf@basil.nowhere.org> (Andi Kleen's message of "Sun,
	12 Jul 2009 11:24:37 +0200")
Message-ID: <adaskh0v7s7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jul 2009 16:59:04.0545 (UTC) FILETIME=[3A5E2510:01CA03DB]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > (I like the idea of trying kmalloc and falling back, simply because it reduces 
 > > TLB pressure,
 > 
 > I implemented this for 32bit in 2.4, but I always had second thoughts
 > if that was really reducing TLB pressure.

Certainly for non-x86 it can be very worthwhile.  A long time ago I
worked on an embedded product that used PowerPC 440, which has only 64
(software-loaded) TLB entries.  On PPC 440, Linux has a pinned TLB entry
for the kernel mapping, and modifying how the module loader allocated
space to load modules into that mapping vs. one that had dynamic TLB
entries was worth a factor of 2 in performance -- ie the TLB miss
handling for .text was literally taking half the CPU time of the module
code!

 - R.
