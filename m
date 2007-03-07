Return-Path: <linux-kernel-owner+w=401wt.eu-S932488AbXCGKMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbXCGKMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932883AbXCGKMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:12:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:34741 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488AbXCGKMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:12:39 -0500
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes
	nonlinear)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070306225101.f393632c.akpm@linux-foundation.org>
References: <20070221023656.6306.246.sendpatchset@linux.site>
	 <20070221023735.6306.83373.sendpatchset@linux.site>
	 <20070306225101.f393632c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 11:05:48 +0100
Message-Id: <1173261949.9349.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > NOPAGE_REFAULT is removed. This should be implemented with ->fault, and
> > no users have hit mainline yet.
> 
> Did benh agree with that?

I won't use NOPAGE_REFAULT, I use NOPFN_REFAULT and that has hit
mainline. I will switch to ->fault when I have time to adapt the code,
in the meantime, NOPFN_REFAULT should stay.

Note that one thing we really want with the new ->fault (though I
haven't looked at the patches lately to see if it's available) is to be
able to differenciate faults coming from userspace from faults coming
from the kernel. The major difference is that the former can be
re-executed to handle signals, the later can't. Thus waiting in the
fault handler can be made interruptible in the former case, not in the
later case.

Ben.


