Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbZKWJyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbZKWJyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZKWJyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:54:16 -0500
Received: from www.tglx.de ([62.245.132.106]:43333 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbZKWJyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:54:15 -0500
Date: Mon, 23 Nov 2009 10:51:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jakub Jelinek <jakub@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <20091123091602.GB22813@hs20-bc2-1.build.redhat.com>
Message-ID: <alpine.LFD.2.00.0911231047400.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain> <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain> <1258653562.22249.682.camel@gandalf.stny.rr.com>
 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com> <4B058CCD.8050605@redhat.com> <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain> <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain> <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>
 <alpine.LFD.2.00.0911191958470.24119@localhost.localdomain> <20091123091602.GB22813@hs20-bc2-1.build.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Jakub Jelinek wrote:

> On Thu, Nov 19, 2009 at 08:01:57PM +0100, Thomas Gleixner wrote:
> > Just compiled with -mincoming-stack-boundary=4 and the problem goes
> > away as gcc now thinks that the incoming stack is already 16 byte
> > aligned. But that might break code which actually uses SSE
> 
> Please don't do this, lying to the compiler is just going to result in
> wrong-code sooner or later, with the above switch gcc will assume the
> incoming stack is 16-byte aligned (which is not true in the ix86 kernel)
> and could very well e.g. optimize away code that looks at
> alignment of stack variables etc.

Right. I gave up the idea pretty fast. But in the current situation we
are forced to lie to the compiler in some way. Forcing -mtune=generic
when the function graph tracer is enabled seems to be a halfways sane
work around.

Thanks,

	tglx
