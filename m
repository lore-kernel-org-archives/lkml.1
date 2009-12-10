Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZLJO33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZLJO33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZLJO3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:29:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56887 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZLJO3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:29:24 -0500
X-Authority-Analysis: v=1.0 c=1 a=0ZecOPpkQPkA:10 a=7U3hwN5JcxgA:10 a=JTd3DF8aov7cxUZRw-kA:9 a=D4fu689iNQqVF2VQMjbgBYVn3gAA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091210120332.GA5042@nowhere>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>
	 <20091210120332.GA5042@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 09:29:27 -0500
Message-ID: <1260455367.2146.143.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 13:03 +0100, Frederic Weisbecker wrote:

> This makes me feel I'm going to try converting the function graph tracer
> into an event during the next cycle. It does not mean I could make it
> usable as a perf event right away in the same shot that said, as you can
> guess this is not a trivial plug. The current perf fast path is not yet
> adapted for that.

I curious how you plan on doing this. The current event system shows one
event per trace point. A straight forward approach would make every
entry and exit of a function a trace point and that would lead to a very
large kernel to handle that.

Perhaps we could abstract out all entries and exits. We need to be able
to link to a single point (entry or exit) not all.  This also has the
added issue of using the ftrace infrastructure of nop the mcount call.
We also need a way to enable a set of functions.

We may be able to abstract this out, but I'm hesitant on making this the
only interface.

-- Steve


