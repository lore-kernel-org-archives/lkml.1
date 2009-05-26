Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZEZSzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZEZSzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbZEZSza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:55:30 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:33071 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbZEZSza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iqcwpiw6tePIAjqY0WQM28kwMsx0r+T8S4Ha2Omo1WeitmTegPxDHJoeLx6rpb6UAE
         9K8L4WrnbqTUUM+THvIsaOvqmAVLvUmHYtEDECUcB9YWy++XcDocvep8xn3WMDvNk1Sg
         hEhJaDIY2GDUnSPvQFoLagpNGc2rpbjhX/q4w=
Date: Tue, 26 May 2009 20:55:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL v2][PATCH 0/10] tracing/core: various fixes
Message-ID: <20090526185524.GB5969@nowhere>
References: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 04:04:45AM +0200, Frederic Weisbecker wrote:
> Hi Ingo, Steven,
> 
> I've gathered various tracing fixes that were posted recently.


I based this topic against tracing/core whereas the latest
tracing changes were on tracing/ftrace.

But tracing/ftrace contains the v1 of:

ftrace: Add task_comm support for trace_event
ftrace: clean up of using ftrace_event_enable_disable()

And my pull request contains the v3 of this pair, fixing
some build issue.

As you suggested, I've cherry picked the missing patches
from tracing/ftrace to my tracing/core based tree.
This new pull request then adds 5 Steven's patches that
were on tracing/ftrace.
I'm not posting them because they have been submitted
in LKML already.

Thanks.

The following changes since commit 5537937696c55530447c20aa27daccb8d0d29b33:
  Ming Lei (1):
        ftrace: fix check for return value of register_module_notifier in event_trace_init

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core-2

Lai Jiangshan (1):
      tracing: add trace_event_read_lock()

Li Zefan (1):
      tracing/events: change the type of __str_loc_item to unsigned short

Pekka Enberg (1):
      kmemtrace: fix kernel parameter documentation

Steven Rostedt (5):
      tracing: add __print_flags for events
      tracing: add previous task state info to sched switch event
      tracing: add flag output for kmem events
      tracing: add __print_symbolic to trace events
      tracing: convert irq events to use __print_symbolic

Zhaolei (2):
      ftrace: Add task_comm support for trace_event
      ftrace: clean up of using ftrace_event_enable_disable()

 Documentation/kernel-parameters.txt |   10 ----
 include/linux/ftrace_event.h        |   16 ++++++-
 include/trace/events/irq.h          |   23 +++++++--
 include/trace/events/kmem.h         |   53 ++++++++++++++++++---
 include/trace/events/sched.h        |    9 +++-
 include/trace/ftrace.h              |   24 +++++++++-
 kernel/trace/Kconfig                |    9 +++-
 kernel/trace/trace.c                |    8 +++
 kernel/trace/trace_events.c         |   42 ++++++----------
 kernel/trace/trace_output.c         |   89 ++++++++++++++++++++++++++++++++---
 kernel/trace/trace_output.h         |    2 +
 11 files changed, 223 insertions(+), 62 deletions(-)

