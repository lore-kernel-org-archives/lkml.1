Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbYDNPuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbYDNPuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbYDNPuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:50:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65230 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbYDNPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:50:08 -0400
Date: Mon, 14 Apr 2008 11:49:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] mmiotrace: add user documentation
In-Reply-To: <20080413224859.4e3f5ddb@daedalus.pq.iki.fi>
Message-ID: <Pine.LNX.4.58.0804141144500.9886@gandalf.stny.rr.com>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi>
 <20080413224859.4e3f5ddb@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Apr 2008, Pekka Paalanen wrote:
> +
> +Usage
> +-----
> +
> +Make sure debugfs is mounted to /debug. If not, (requires root privileges)
> +$ mount -t debugfs debugfs /debug
> +
> +Check that the driver you are about to trace is not loaded.
> +
> +Activate mmiotrace (requires root privileges):
> +$ echo mmiotrace > /debug/tracing/current_tracer
> +
> +Start storing the trace:
> +$ cat /debug/tracing/trace_pipe > mydump.txt &
> +The 'cat' process should stay running (sleeping) in the background.
> +
> +Load the driver you want to trace and use it. Mmiotrace will only catch MMIO
> +accesses to areas that are ioremapped while mmiotrace is active.
> +
> +[Unimplemented feature:]
> +During tracing you can place comments (markers) into the trace by
> +$ echo "X is up" > /debug/tracing/marker

I can implement a marker feature (logdev does this). I'll see if I can get
something working this week.

> +This makes it easier to see which part of the (huge) trace corresponds to
> +which action. It is recommended to place descriptive markers about what you
> +do.
> +
> +Shut down mmiotrace (requires root privileges):
> +$ echo none > /debug/tracing/current_tracer

I need to still add a "save" of all previous tracing events. This is not
a trivial feature. It will require a little cleverness to make the new
trace doesn't start until all waiters have woken up and retrieved their
data. I'll see if I can get this implemented with some kind of completion.


> +The 'cat' process exits. If it does not, kill it by 'fg' and pressing ctrl+c.
> +
> +[This feature is not implemented yet!]
> +Check your kernel log. If there are messages about mmiotrace losing events,

This is something of higher priority to implement. I'll work on that
first.

> +this is due to buffer overrun, and the trace is incomplete. You should enlarge
> +the buffers and try again. [How?]

I pretty much have the infrastructure in place to implement this. Now it's
just time to do it ;-)

Thanks,

-- Steve

> +
> +If you are doing a trace for a driver project, e.g. Nouveau, you should also
> +do the following before sending your results:
> +$ lspci -vvv > lspci.txt
> +$ dmesg > dmesg.txt
> +$ tar zcf pciid-nick-mmiotrace.tar.gz mydump.txt lspci.txt dmesg.txt
> +and then send the .tar.gz file. The trace compresses considerably. Replace
> +"pciid" and "nick" with the PCI ID or model name of your piece of hardware
> +under investigation and your nick name.
> +
> +
