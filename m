Return-Path: <linux-kernel-owner+w=401wt.eu-S1758513AbZGHDOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513AbZGHDOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 23:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbZGHDNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 23:13:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57426 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506AbZGHDNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 23:13:54 -0400
Message-ID: <4A540EEC.7070609@redhat.com>
Date: Tue, 07 Jul 2009 23:13:48 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add block IO documentation to tracepoint docbook
References: <4A4BBECD.8000908@redhat.com> <20090702100155.GA28662@infradead.org>
In-Reply-To: <20090702100155.GA28662@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Jul 01, 2009 at 03:53:49PM -0400, William Cohen wrote:
>> +/**
>> + * block_rq_abort - Abort Block Operation Request
>> + * @q: queue containing the block operation request
>> + * @rq: block IO operation request
>> + *
>> + * Called immediately after pending block IO operation request @rq in
>> + * queue @q is aborted. The fields in the operation request @rq
>> + * can be examined to determine which device and sectors the pending
>> + * operation would access.
>> + */
>>  TRACE_EVENT(block_rq_abort,
> 
> Um, what's the point?  These are not function, but rather trace points.
> The paramters don't actually get exported in the trace files, but the
> printk ring buffer format and the format string do.  So please document
> the formats, and if possible make sure this documentation actually
> appears in debugfs in the trace subdirectory so people get it very easily.
> 


There is already documentation for the irq tracepoints (irq_handler_entry,
irq_handler_exit, softirq_entry, and softirq_exit) in
include/trace/events/irq.h. This was added around the end of April 2009. Threads
discussing those patches:

http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02647.html
http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02650.html
http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02648.html
http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02651.html

In those previous threads there was no discussion about documenting the printk
ring buffer. The comments in include/linux/tracepoint.h states that functions
with those parameters are generated for the tracespoints. ftrace appears to be
built on top of that mechanism.

It would be nice to have something that describes the format of ftrace output
available in debugfs.  However, there are other things that use the tracepoints
in addition to ftrace and the tracepoint comments are trying to describe what
exactly those events cause those tracepoints to occur. traces/log are useful,
but there are cases where people might prefer not to post-process a large log
file to debug a problem.

-Will
