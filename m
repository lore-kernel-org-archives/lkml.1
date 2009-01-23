Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbZAWOGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbZAWOGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 09:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZAWOGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 09:06:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35643 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbZAWOGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 09:06:39 -0500
Date: Fri, 23 Jan 2009 12:06:17 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-btrace@vger.kernel.org
Subject: [PATCH tip][0/2] ftrace interface for blktrace
Message-ID: <20090123140617.GB21737@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

	Here is a third version, that also implements blk_add_trace_msg,
using ftrace_vprintk.

	As soon as the TRACE_ITER_CONTEXT_INFO option is implemented
I'll provide the struct trace_event->bin() callback to synthesize the
old blktrace record format so that we can test the output of trace_pipe
with blkparse -i -.

	Please let me know if this is acceptable for inclusion on
linux-tip.

Best Regards,

- Arnaldo

 block/blktrace.c       |  651 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/partitions/check.c  |    7 
 include/linux/ftrace.h |    8 
 kernel/trace/trace.c   |    9 
 kernel/trace/trace.h   |    1 
 5 files changed, 671 insertions(+), 5 deletions(-)
