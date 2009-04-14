Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZDNV7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZDNV7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZDNV7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:59:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47152 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZDNV7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:59:04 -0400
Date: Tue, 14 Apr 2009 17:59:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Theodore Tso <tytso@mit.edu>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
In-Reply-To: <alpine.DEB.2.00.0904141716300.31421@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0904141758260.31421@gandalf.stny.rr.com>
References: <20090414172337.280621613@goodmis.org> <20090414210445.GM955@mit.edu> <alpine.DEB.2.00.0904141716300.31421@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Apr 2009, Steven Rostedt wrote:
> 
> Yes, at the bottom of your header file, before including define_trace.h, 
> you can simply add:
> 
> #undef TRACE_INCLUDE_PATH
> #define TRACE_INCLUDE_PATH ../../fs/ext4
> 
> #include <trace/define_trace.h>
> 
> the TRACE_INCLUDE_PATH is a reference from where trace/define_trace.h is 
> located. It may even be cleaner to do:
> 
> 
> #undef TRACE_INCLUDE_PATH
> #define TRACE_INCLUDE_PATH EXT4_PATH
> 
> and in the Makefile have:
> 
> CFLAGS_ext4_jbd2.o := -DEXT4_PATH=$(PWD)
> 
> That's something like what I did for my external module test.

Note, you only need to add the CFLAGS for the object that performs the:

#define CREATE_TRACE_POINTS

-- Steve

