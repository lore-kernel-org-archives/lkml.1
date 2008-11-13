Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYKMRc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYKMRc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYKMRc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:32:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45716 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbYKMRcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:32:24 -0500
Date: Thu, 13 Nov 2008 12:32:23 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function
 return tracer lockless
In-Reply-To: <20081113173451.GY3810@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0811131230470.23751@gandalf.stny.rr.com>
References: <491B4F0A.3080901@gmail.com> <87od0jd6ds.fsf@basil.nowhere.org> <c62985530811130901t7ddf84beof39a964582fb94a0@mail.gmail.com> <20081113171220.GX3810@one.firstfloor.org> <alpine.DEB.1.10.0811131219250.23751@gandalf.stny.rr.com>
 <20081113173451.GY3810@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Nov 2008, Andi Kleen wrote:

> > So the answer to this is:
> > 
> >   i = index++;
> >   barrier();
> >   write to index i (not index);
> 
> That was my first thought when I wrote the original email,
> but the disadvantage is that barrier() is a big hammer
> that flushes everything and can make the code much worse.
> That is why I suggested local_add_return() instead.

barrier() is a compiler barrier, does nothing with the caches, and is 
quite cheap. We only need a compiler barrier because we are only 
protecting ourselves from things that happen on the current CPU. No other 
devices or other CPUs are involved.

-- Steve

