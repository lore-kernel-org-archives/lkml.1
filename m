Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbZJWNMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbZJWNMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 09:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZJWNMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 09:12:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZJWNMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 09:12:06 -0400
Subject: Re: [RFC] tracefs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20091023053237.GA24359@elte.hu>
References: <20091023004937.GA24035@kroah.com>
	 <20091023053237.GA24359@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 23 Oct 2009 09:12:08 -0400
Message-Id: <1256303528.20866.822.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 07:32 +0200, Ingo Molnar wrote:

> _No way_ do we want to tie down the pretty-printing ftrace details as an 
> ABI. We promised that when ftrace went upstream and all the details are 
> way too messy to be exposed in an ABI alike matter (and yes, consider 
> this a NAK Steve ;-).

Note, I wasn't talking about tie down the pretty-print formats. But we
need to have a standard way to change them.

For example:

[root@mxf ~]# cat /debug/tracing/events/power/power_start/format 
name: power_start
ID: 258
format:
	field:unsigned short common_type;	offset:0;	size:2;
	field:unsigned char common_flags;	offset:2;	size:1;
	field:unsigned char common_preempt_count;	offset:3;	size:1;
	field:int common_pid;	offset:4;	size:4;
	field:int common_lock_depth;	offset:8;	size:4;

	field:u64 type;	offset:16;	size:8;
	field:u64 state;	offset:24;	size:8;

print fmt: "type=%lu state=%lu", (unsigned long)REC->type, (unsigned long)REC->state


Now we are going to add a "signed" field to each line. Fine, but we need
a spec of some sort to say how that will happen. Or what can be expected
to not change. We can say the type (field in this case) will always be
the first item, and that the type will stay on a single line. If the
parser does not know how to handle one of the items (offset, size, etc)
it can simply ignore it. When it hits the "\n", it is done with that
type.

We need to document this, so tools will not break when we update this
format.

-- Steve


