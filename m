Return-Path: <linux-kernel-owner+w=401wt.eu-S1758405AbZEVTYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbZEVTYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbZEVTYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:24:36 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:45562 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400AbZEVTYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:24:36 -0400
X-IronPort-AV: E=Sophos;i="4.41,234,1241395200"; 
   d="scan'208";a="309337954"
From: Roland Dreier <rdreier@cisco.com>
To: "Michael S. Zick" <mszick@morethan.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221350.50027.mszick@morethan.org>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 22 May 2009 12:24:36 -0700
In-Reply-To: <200905221350.50027.mszick@morethan.org> (Michael S. Zick's
	message of "Fri, 22 May 2009 13:50:47 -0500")
Message-ID: <adak5499c0b.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 May 2009 19:24:37.0350 (UTC) FILETIME=[F20B7060:01C9DB12]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Unless you have interrupts enabled, then you have two contexts.
 > Only xchg is "naturally" atomic.

Isn't the lock prefix about consistency between multiple processors?
The x86 architecture always handles interrupts on instruction
boundaries.  I'm guessing you're worried about definitions like

static inline void atomic_inc(atomic_t *v)
{
	asm volatile(LOCK_PREFIX "incl %0"
		     : "+m" (v->counter));
}

which compiles to just "incl" (with no lock prefix) on uniprocessor
kernels; but the IA-32 architecture guarantees that the incl instruction
cannot be interrupted between reading the old value and writing the new
value.

 - R.
