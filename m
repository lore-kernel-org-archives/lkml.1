Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743Ab0AVEwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab0AVEwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633Ab0AVEwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:52:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0AVEwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:52:49 -0500
X-Authority-Analysis: v=1.0 c=1 a=6AAhZGXoe_sA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=8XtF-aBpUg5W8ulMzP8A:9 a=-vpHyHQ_YFpYmlBPbfoA:7 a=xTKq9JNZAfH2sdX08QxBcnQB9NQA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled
 checks in tracing hot path
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20100122040959.GA11827@Krystal>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
	 <1264122982-1553-4-git-send-regression-fweisbec@gmail.com>
	 <1264125917.31321.312.camel@gandalf.stny.rr.com>
	 <20100122022858.GA2604@Krystal>
	 <1264129978.31321.333.camel@gandalf.stny.rr.com>
	 <20100122040959.GA11827@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 21 Jan 2010 23:52:46 -0500
Message-ID: <1264135966.31321.375.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 23:09 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > Hmm, interesting. Maybe something like that might work. But what if
> > CONFIG_PREEMPT is enabled but CONFIG_FREEZER is not?
> 
> Then you may want to make the function tracer depend on CONFIG_FREEZER,
> but maybe Masami has other ideas ?

egad no! This is just to help add guarantees to those that use the
function tracer that when the tracing is disabled, it is guaranteed that
no more tracing will be called by the function tracer. Currently,
nothing relies on this. But we may add cases that might need this.

In fact, only those that need this requirement would need to do this
trick. Anyway, we could make those depend on CONFIG_FREEZER, but that
just seems to be a strange dependency.

-- Steve


