Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0CEJjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:39:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0CEJjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:39:35 -0500
Subject: Re: [PATCH 2/2] perf: Walk through the relevant events only
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1267772426-5944-2-git-send-regression-fweisbec@gmail.com>
References: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com>
	 <1267772426-5944-2-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 10:39:29 +0100
Message-ID: <1267781969.16716.55.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 08:00 +0100, Frederic Weisbecker wrote:
> Each time a trace event triggers, we walk through the entire
> list of events from the active contexts to find the perf events
> that match the current one.
> 
> This is wasteful. To solve this, we maintain a per cpu list of
> the active perf events for each running trace events and we
> directly commit to these.

Right, so this seems a little trace specific. I once thought about using
a hash table to do this for all software events. It also keeps it all
nicely inside perf_event.[ch].



