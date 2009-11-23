Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbZKWJSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbZKWJSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZKWJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:18:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbZKWJSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:18:06 -0500
Date: Mon, 23 Nov 2009 04:16:02 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
Message-ID: <20091123091602.GB22813@hs20-bc2-1.build.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain> <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain> <1258653562.22249.682.camel@gandalf.stny.rr.com> <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com> <4B058CCD.8050605@redhat.com> <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain> <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain> <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain> <alpine.LFD.2.00.0911191958470.24119@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911191958470.24119@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 08:01:57PM +0100, Thomas Gleixner wrote:
> Just compiled with -mincoming-stack-boundary=4 and the problem goes
> away as gcc now thinks that the incoming stack is already 16 byte
> aligned. But that might break code which actually uses SSE

Please don't do this, lying to the compiler is just going to result in
wrong-code sooner or later, with the above switch gcc will assume the
incoming stack is 16-byte aligned (which is not true in the ix86 kernel)
and could very well e.g. optimize away code that looks at
alignment of stack variables etc.

	Jakub
