Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZIKPL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZIKPL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZIKPLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:11:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55303 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbZIKPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:11:55 -0400
Subject: Re: [PATCH 3/3] tracing: add latency format to function_graph
 tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, edwintorok@gmail.com
In-Reply-To: <20090911145521.GA6119@nowhere>
References: <20090911135452.866274568@goodmis.org>
	 <20090911135626.824079836@goodmis.org>  <20090911145521.GA6119@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 11:11:56 -0400
Message-Id: <1252681916.18996.697.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 16:55 +0200, Frederic Weisbecker wrote:

> Oh, BTW, what would you think about addding the current->lock_depth
> in the latency format? That may help debug the bkl...

Hmm, that would require adding another field for all traces. I don't
want to increase the size of an entry unneeded. BTW, this is for all
entries (even events).

Ug! I just noticed that tgid was added to struct trace_entry, with the
only user as the user stack entry. This should be in the user stack
field not something that goes into every event!

I guess I need to fix that too.

Well, maybe replacing tgid with lock_depth may not be a bad idea after
all.

-- Steve


