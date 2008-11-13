Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYKMTK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYKMTK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYKMTKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:10:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57036 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYKMTKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:10:11 -0500
Date: Thu, 13 Nov 2008 20:19:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function return tracer lockless
Message-ID: <20081113191931.GB3810@one.firstfloor.org>
References: <87od0jd6ds.fsf@basil.nowhere.org> <c62985530811130901t7ddf84beof39a964582fb94a0@mail.gmail.com> <20081113171220.GX3810@one.firstfloor.org> <alpine.DEB.1.10.0811131219250.23751@gandalf.stny.rr.com> <20081113173451.GY3810@one.firstfloor.org> <alpine.DEB.1.10.0811131230470.23751@gandalf.stny.rr.com> <20081113182937.GZ3810@one.firstfloor.org> <alpine.DEB.1.10.0811131330350.23751@gandalf.stny.rr.com> <20081113185515.GA3810@one.firstfloor.org> <alpine.DEB.1.10.0811131349090.31899@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811131349090.31899@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> barrier:
> 	__asm__ __volatile__("": : :"memory")
> 
> local_add_return:
> 	asm volatile(_ASM_XADD "%0, %1;"
> 		     : "+r" (i), "+m" (l->a.counter)
> 		     : : "memory");
> 
> 
> Your argument was that barrier clobbers memory, but it looks like the 
> local_add_return does the same.

That's a fair point. I'm not sure why the local_add_* has a memory
barrier at all, imho it shouldn't need it. I bet it's just
a hold over from the atomic code this was based one.

> I don't see any major gain in switching to local_add_return.

That's true with the current implementation. It would
be a good idea to consider dropping that explicit 
barrier though, then it would be likely a slight win.

-Andi

-- 
ak@linux.intel.com
