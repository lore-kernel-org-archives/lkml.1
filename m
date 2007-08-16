Return-Path: <linux-kernel-owner+w=401wt.eu-S932635AbXHPVha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbXHPVha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXHPVhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:37:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:40428 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbXHPVhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:37:19 -0400
In-Reply-To: <46C2325C.8040900@redhat.com>
References: <46C03885.7000109@redhat.com> <20070813110415.GA24018@shell.boston.redhat.com> <Pine.LNX.4.64.0708141544001.401@schroedinger.engr.sgi.com> <46C2325C.8040900@redhat.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <7913acdd6449613c49b86bc99da0d254@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>,
       Chris Friesen <cfriesen@nortel.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/23] document preferred use of volatile with atomic_t
Date: Thu, 16 Aug 2007 23:36:49 +0200
To: Chris Snook <csnook@redhat.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But barriers force a flush of *everything* in scope,

Nonsense, whatever "flush" is supposed to mean here.

> If you really, *really* distrust the compiler that much, you shouldn't 
> be using barrier, since that uses volatile under the hood too.  You 
> should just go ahead and implement the atomic operations in assembler, 
> like Segher Boessenkool did for powerpc in response to my previous 
> patchset.

Puh-lease.  I DO NOT DISTRUST THE COMPILER, I just don't assume
it will do whatever I would like it to do without telling it.
It's a machine you know, and it is very well documented.

(And most barriers don't (need to) use volatile).

Implementing the atomic ops in asm loses exactly *no* semantics,
and it doesn't add restrictions either; it does allow you however
to access an atomic_t with normal loads/stores independently, if
you so choose.  The only valid issue brought up so far is Russell
King's comment that GCC cannot schedule the machine instructions
in and around an asm() perfectly, it doesn't look inside the asm()
after all; but the situation isn't quite as sever as he suggests
(GCC _does_ know you are performing loads/stores, etc.); more about
that later, when I've finished researching the current state of
that stuff.


Segher

