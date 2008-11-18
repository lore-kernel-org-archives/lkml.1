Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYKRQnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYKRQnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYKRQno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:43:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44536 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbYKRQnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:43:43 -0500
Date: Tue, 18 Nov 2008 11:43:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
 field
In-Reply-To: <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811181141560.15003@gandalf.stny.rr.com>
References: <4920D571.4050007@gmail.com> <20081117084923.GD28786@elte.hu>  <4921BA25.3090704@gmail.com> <20081118084755.GK17838@elte.hu>  <alpine.DEB.1.10.0811180922370.15003@gandalf.stny.rr.com>  <20081118145154.GC30358@elte.hu> 
 <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com>  <20081118151326.GH30358@elte.hu>  <alpine.DEB.1.10.0811181020350.15003@gandalf.stny.rr.com>  <20081118155045.GJ30358@elte.hu> <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Nov 2008, Fr?d?ric Weisbecker wrote:
> >>
> >> Yeah, it was just a recommendation, and perhaps not a good one ;-)
> >>
> >> Frederic, it is better if you move the array from the thread info to
> >> the task struct. It will take up more memory but it is a hell of a
> >> lot safer. The pro here definitely outways the con.
> >
> > if the memory footprint starts mattering we could turn this into a
> > single pointer to an array - and add/remove these arrays (from all
> > tasks currently running) as the tracer is turned on/off.
> >
> >        Ingo
> >
> 
> Ok. So what do you suggest once? Do I begin to move the array from
> thread info to struct task but by keeping the static
> array or should I directly use a dynamic allocation and add/remove dynamically?

I would recommend using a static array in task struct (say 200?) and keep 
the max recorded for later output. This way we can find a better size.

As for the dynamic use of different arrays. Put that towards the end. We 
want to get this working solid first before adding more variables to the 
equation.

-- Steve

