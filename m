Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbYFXL6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbYFXL6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYFXL6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:58:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbYFXL6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:58:08 -0400
To: "Takashi Nishiie" <t-nishiie@np.css.fujitsu.com>
Cc: "'Masami Hiramatsu'" <mhiramat@redhat.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Mathieu Desnoyers'" <mathieu.desnoyers@polymtl.ca>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC] Tracepoint proposal
References: <485BE2C6.1080901@redhat.com> <20080620174529.GB10943@Krystal>
	<1213992446.3223.195.camel@lappy.programming.kicks-ass.net>
	<20080622171135.GA19432@Krystal>
	<20080622175928.GA5022@martell.zuzino.mipt.ru>
	<20080622182705.GA23301@Krystal>
	<20080624002010.GA4777@martell.zuzino.mipt.ru>
	<486071AF.3080709@redhat.com>
	<007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 24 Jun 2008 07:55:25 -0400
In-Reply-To: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> (Takashi Nishiie's message of "Tue, 24 Jun 2008 16:15:35 +0900")
Message-ID: <y0mtzfjavyq.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Takashi Nishiie" <t-nishiie@np.css.fujitsu.com> writes:

> [...]
> Each kernel sub-system seems to have its own way of dealing with 
> debugging statements. Some of these methods include 'dprintk', 
> 'pr_debug', 'dev_debug', 'DEBUGP'. I think that these functions are
> the tracepoints that has been availably mounted without setting up 
> the tool set of the outside. I think whether mounting that unites 
> these functions can be done if kernel marker and tracepoint are used.

There are efforts underway to collect these various debug methods into
a single run-time-dynamic stream, which may even turn out to connect
to markers.

> By the way, isn't there problem on security?  What kprobe, jprobe,
> and kernel marker, etc. offer looks like what the framework of Linux
> Security Module had offered before.  Gotten kprobe, jprobe, and
> kernel marker, etc. should not be exported to the userland for
> security because it becomes the hotbed of rootkits.

These are all kernel-side facilities with no direct connection to
user-land.

> Users such as kprobe, jprobe, and kernel marker should not be
> Loadable Kernel Module. [...]

That would defeat their usefulness.  Remember, kernel modules run with
no hardware-level restrictions at all, so if an adversary managed to
load up some kernel malware module, the game is over, whether or not
they use kprobes.

- FChE
