Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYKMRVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYKMRVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYKMRVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:21:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbYKMRVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:21:04 -0500
Date: Thu, 13 Nov 2008 12:21:00 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function
 return tracer lockless
In-Reply-To: <20081113171220.GX3810@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0811131219250.23751@gandalf.stny.rr.com>
References: <491B4F0A.3080901@gmail.com> <87od0jd6ds.fsf@basil.nowhere.org> <c62985530811130901t7ddf84beof39a964582fb94a0@mail.gmail.com> <20081113171220.GX3810@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Nov 2008, Andi Kleen wrote:

> > > local register i
> > > i = index;
> > > write to index'ed array using i
> > >                            <--------- interrupt here would overwrite data
> > > ...
> > > index = i + 1;
> > 
> > 
> > Yes in the common case that would be a danger. But here, if an
> > interrupt is raised, it will increment
> > the counter and then decrement it at return time without dropping the
> > cpu. So after the interrupt, the
> > value will remain the same...
> 
> The buffer contents will not be necessarily
> the same. See the scenario above. The interrupt would use the 
> same i as the current function and would overwrite the
> partially written entry.


So the answer to this is:

  i = index++;
  barrier();
  write to index i (not index);

-- Steve


