Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbYFSQcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbYFSQcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 12:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760162AbYFSQcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 12:32:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbYFSQcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 12:32:00 -0400
Date: Thu, 19 Jun 2008 09:30:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, benh@kernel.crashing.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
 abstraction
In-Reply-To: <20080619115832.GM15228@elte.hu>
Message-ID: <alpine.LFD.1.10.0806190928100.2907@woody.linux-foundation.org>
References: <b020e42384197b824320.1213615800@localhost> <1213831403.8011.24.camel@pasglop> <4859A149.9090004@goop.org> <4859A528.1010107@goop.org> <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org> <4859AA47.2020903@goop.org>
 <alpine.LFD.1.10.0806181743390.2907@woody.linux-foundation.org> <alpine.LFD.1.10.0806182050470.2907@woody.linux-foundation.org> <20080619115832.GM15228@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jun 2008, Ingo Molnar wrote:
> 
> Below is the commit, it needed a small amount of massaging to apply the 
> void * -> unsigned long * change in the x86/bitops topic.

Well, that's your bug right there.

The macros very much depended on the pointers being "void *", due to the 
pointer arithmetic (which is a gcc extension that we use extensively - 
"void *" arithmetic works as if it was a byte pointer).

When you changed "addr" to "volatile unsigned long *", now the arithmetic 
ended up multiplying the offset by the size of "long" before adding it.

That said, the _original_ patch wasn't tested either, but quite frankly, 
looking over the patch one more time, I can't really see how it could 
break.

		Linus
