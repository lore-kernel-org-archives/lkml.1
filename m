Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404Ab0ANRtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab0ANRtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 12:49:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757253Ab0ANRtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 12:49:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353Ab0ANRtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 12:49:04 -0500
Date: Thu, 14 Jan 2010 15:48:23 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: a.p.zijlstra@chello.nl, eranian@google.com, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, mingo@elte.hu,
       paulus@samba.org
Subject: Re: perf: don't use obsolete getpagesize
Message-ID: <20100114174823.GA2600@ghostprotocols.net>
References: <201001141743.o0EHhKUV023427@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201001141743.o0EHhKUV023427@hs20-bc2-1.build.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 14, 2010 at 12:43:20PM -0500, Ulrich Drepper escreveu:
> perf uses the obsolete getpagesize function.  Let's do better and use the
> correct POSIX interface to get the information: sysconf.
> 
> 
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

I have this already in my queue, thanks!

acme@parisc:~/git/linux-2.6-tip$ git show 578bb387c17692896a2a7c6b8bcba2c3945c33f4
commit 578bb387c17692896a2a7c6b8bcba2c3945c33f4
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Thu Jan 14 14:10:35 2010 -0200

    perf tools: Convert getpagesize() uses to sysconf(_SC_GETPAGESIZE)
    
    Using the more portable and equivalent sysconf call.
    
    Reported-by: Aristeu Rozanski <aris@redhat.com>
    Cc: Aristeu Rozanski <aris@redhat.com>
    Cc: Frédéric Weisbecker <fweisbec@gmail.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Paul Mackerras <paulus@samba.org>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 604e14f..1951e33 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -384,7 +384,7 @@ int perf_session__process_events(struct perf_session *self,
 
        perf_event_ops__fill_defaults(ops);
 
-       page_size = getpagesize();
+       page_size = sysconf(_SC_PAGESIZE);
 
        head = self->header.data_offset;
 
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 407fd65..5ea8973 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -515,7 +515,7 @@ int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
        write_or_die(buf, 1);
 
        /* save page_size */
-       page_size = getpagesize();
+       page_size = sysconf(_SC_PAGESIZE);
        write_or_die(&page_size, 4);
 
        read_header_files();
acme@parisc:~/git/linux-2.6-tip$
