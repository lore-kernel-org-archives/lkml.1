Return-Path: <linux-kernel-owner+w=401wt.eu-S1750793AbZH1AjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750793AbZH1AjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 20:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbZH1AjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 20:39:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZH1AjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 20:39:08 -0400
Message-ID: <4A972720.7080602@redhat.com>
Date: Thu, 27 Aug 2009 17:38:56 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <srostedt@redhat.com>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] tracing: Fix double CPP substitution in TRACE_EVENT_FN
References: <tip-97419875865859fd2403e66266c02ce028e2f5ab@git.kernel.org> <1251413406-6704-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1251413406-6704-1-git-send-email-fweisbec@gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2009 03:50 PM, Frederic Weisbecker wrote:
> TRACE_EVENT_FN relays on TRACE_EVENT by reprocessing its parameters
> into the ftrace events CPP macro. This leads to a double substitution
> in some cases.
> 
> For example, a bad consequence is a format always prefixed by
> "%s, %s\n" for every TRACE_EVENT_FN based events.
> 
> Eg:
> 	cat /debug/tracing/events/syscalls/sys_enter/format
> 	[...]
> 	print fmt: "%s, %s\n", "\"NR %ld (%lx, %lx, %lx, %lx, %lx, %lx)\"",\
> 	"REC->id, REC->args[0], REC->args[1], REC->args[2], REC->args[3],\
> 	REC->args[4], REC->args[5]"
> 
> This creates a failure in post-processing tools such as perf trace or
> trace-cmd.

Fun - I didn't think about TP_printk and friends doing anything beside
passing their contents along.

> 
> Then drop this double substitution and replace it by a new __cpparg()
> macro that relays CPP arguments containing commas.

Looks good to me.

> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Josh Stone <jistone@redhat.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Steven Rostedt <srostedt@redhat.com>
> Cc: Jason Baron <jbaron@redhat.com>

Reviewed-by: Josh Stone <jistone@redhat.com>
