Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbZCWOcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbZCWOcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbZCWOch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:32:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534AbZCWOcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:32:36 -0400
Date: Mon, 23 Mar 2009 15:32:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       =?utf-8?B?RnLpppjpp7tpYw==?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: ftrace not working?
Message-ID: <20090323143226.GA18439@elte.hu>
References: <20090323083533.GE18837@elte.hu> <200903231408.35405.knikanth@suse.de> <20090323200057.9027.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323200057.9027.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Monday 23 March 2009 14:05:33 Ingo Molnar wrote:
> > > one thing to note:
> > > | CPU0: Intel QEMU Virtual CPU version 0.9.1 stepping 03
> > > | Testing tracer nop: PASSED
> > >
> > > so it's a Qemu session, right?
> > >
> > 
> > Yes. qemu-kvm.
> 
> Ah, sorry. I don't know qemu and kvm at all ;)

In terms of tracing it should just look like some weird old CPU with 
few capabilities and long delays. Nothing in ftrace depends on CPU 
capabilities (that wasnt present in pentia) so this is weird. 
Perhaps some timestamping problem? Virtual machines tend to have 
trouble with the TSC. Or code patching problems? But that does not 
explain the lack of explicit scheduler events.

Or perhaps the fact that qemu sessions tend to boot with barely any 
RAM. Maybe the ringbuffer size is very low?

	Ingo
