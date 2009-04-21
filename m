Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbZDUXdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbZDUXdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 19:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbZDUXdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 19:33:00 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37677 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbZDUXc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 19:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Mpqlqp8fInqa3iCpWVxb840TifVpBShsJ++FxzHXTKAHNMOt8r1s6Cxz8QPSODXoJA
         qCET0QVllMekIRM5B37t8cylBsOrpJ9uR9DNZ9VaB/I4DTdtJAIGtnQoSjuwfTMLVGHg
         7Am5HlXhNmLOZvihtNgk1PbfEHy0KvclCllS0=
Date: Wed, 22 Apr 2009 01:32:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH][GIT-PULL] tracing/events: protect __get_str()
Message-ID: <20090421233253.GB6744@nowhere>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <1240117295-6873-2-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0904211749580.10097@gandalf.stny.rr.com> <alpine.DEB.2.00.0904211759540.10097@gandalf.stny.rr.com> <20090421221241.GA6744@nowhere> <alpine.DEB.2.00.0904211820410.9714@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904211820410.9714@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 06:21:54PM -0400, Steven Rostedt wrote:
> It would probably be better to just make the fix now. Just put the fix in 
> a separate branch to avoid race conditions (if Ingo already did a pull ;-)
> 
> -- Steve


Ok, so this new pull request includes the patches in the previous
request + your Reviewed/Acked-by + the fix on __get_str() which
I pasted below. It's also a rebase against latest tip/tracing/core.

Thanks.

The following changes since commit 3554228d4289098a8fe5cfd87512ec32a19bbe5a:
  Steven Rostedt (1):
        ring-buffer: only warn on wrap if buffer is bigger than two pages

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core-v2

Frederic Weisbecker (3):
      tracing/events: provide string with undefined size support
      tracing/lock: provide lock_acquired event support for dynamic size string
      tracing/events: protect __get_str()

 include/trace/events/lockdep.h |    6 +-
 include/trace/ftrace.h         |   88 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 88 insertions(+), 6 deletions(-)
---
>From 94be8f865ac6887e79cd38302d707f5536e377fe Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 22 Apr 2009 00:41:09 +0200
Subject: [PATCH] tracing/events: protect __get_str()

The __get_str() macro is used in a code part then its content should be
protected with parenthesis.

[ Impact: protect macro content ]

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 353b7db..019cc5d 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -123,7 +123,7 @@
 #define TP_printk(fmt, args...) fmt "\n", args
 
 #undef __get_str
-#define __get_str(field)	(char *)__entry + __entry->__str_loc_##field
+#define __get_str(field)	((char *)__entry + __entry->__str_loc_##field)
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-- 
1.6.2.3


