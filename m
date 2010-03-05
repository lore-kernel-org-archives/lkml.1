Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab0CESfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:35:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48770 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0CESfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:35:04 -0500
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=wbFuiDpX1lbOay219K8A:9 a=Q2HmYToS6K0pE3BfHYAcg7y7s7wA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100305171614.GC5244@nowhere>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <20100305171614.GC5244@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 05 Mar 2010 13:35:00 -0500
Message-ID: <1267814100.10871.1780.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 18:16 +0100, Frederic Weisbecker wrote:

> It's true it has a high overhead, but not to the point of
> making the whole system unusable. We are supposed to be even
> far from that. I'm currently able to turn on the function graph
> tracer and use firefox without problems. It's just a bit slower
> but it's far from a visible starvation.
> 
> And Li seems to see the same thing.
> For now I can not test, but I will try this week-end.

Americo said he's seen the issue as far back as 2.6.32. So perhaps some
CPUs take a bigger hit from the function graph tracer than others. I
have several different boxes that I can try. I've seen noticeable slow
downs but never something that cripples the box.

The only time that I've seen it cripple the box is when LOCKDEP_DEBUG
was set (which according to Americo's config it was not). But that's
because LOCKDEP_DEBUG updates a global variable every time interrupts
are enabled or disabled. This caused a huge cache line bouncing with the
function graph tracer since it caused this variable to be updated 4
times for every function call!

-- Steve



