Return-Path: <linux-kernel-owner+w=401wt.eu-S1762032AbZLKBRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbZLKBRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbZLKBRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:17:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51073 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757350AbZLKBRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:17:45 -0500
Message-ID: <4B219D9D.70102@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 09:17:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] tracing: add print_fmt field
References: <4B1F4EA1.4080400@cn.fujitsu.com> <1260491104.2146.314.camel@gandalf.stny.rr.com>
In-Reply-To: <1260491104.2146.314.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-12-09 at 15:15 +0800, Lai Jiangshan wrote:
>> Add print_fmt field and the initialization codes.
>> It will be used for replacing ->show_format().
> 
> This change log is very lacking. I don't even know what this patch is
> doing. I'm guessing other patches will depend on it. But this patch
> alone should have a change log that describes the goal that will happen
> to give it rational.
> 
> If I'm bisecting the kernel and I come across this change, I want the
> change log to explain why this change exists, and not have to spend time
> searching the logs for other patches that may depend on this one.
> 
> 

For a format file

# cat events/irq/irq_handler_entry/format
name: irq_handler_entry
ID: 97
format:

A) ======> name, ID, and a string "format:"

        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;
        field:int common_lock_depth;    offset:8;       size:4; signed:1;

        field:int irq;  offset:12;      size:4; signed:1;
        field:__data_loc char[] name;   offset:16;      size:4; signed:1;

B) ========> fields.

print fmt: "irq=%d name=%s", REC->irq, __get_str(name)

C) ========> string "print fmt: " and the print format after it.

How my patches work:
For B)
Ensure all fields are add into struct ftrace_event_call->fields. (patch#4)
Ensure all fields are correct. (patch#5)

For C)
add a print_fmt field (this patch)
init print_fmt carefully (this patch and patch#7 patch#8)

So when we generate format file:
print name
print ID
print string "format:"
use struct ftrace_event_call->fields to print fields
use struct ftrace_event_call->print_fmt to print "print fmt: XXXXXXXXXXX"

Thanks
-- Lai
