Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZCWNMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZCWNMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZCWNL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:11:57 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60474 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZCWNL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:11:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=UA3PMw8Wd50GEo8Ug8UibLeGJHaA/T/1JRdAnK/NZ3B2nVyDAJiEp5dX3luf7ZDaEm
         MsPu0hrqLE38NxxT5WeH7p7jApv8MhMzBBok1C9PYHaPQSRehKEO9xUTqXEI3KJg4kzW
         bsWu54aEOI7XlniYCzmlx2lEvYooPgmXxkWN8=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, compudj@krystal.dyndns.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] kmemtrace & tracing updates
Date: Mon, 23 Mar 2009 15:12:20 +0200
Message-Id: <cover.1237813499.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've updated kmemtrace to make it play well with the userspace app.

The first patch has been already submitted before, but it seems it didn't
make it into -tip.

Let me know what you think and please merge what's okay. There's a GSoC idea
regarding kmemtrace and it'd benefit other students to be able to run the
kmemtrace user application.


	Cheers,
	Eduard

Eduard - Gabriel Munteanu (7):
  RCU: don't include unnecessary headers, allow kmemtrace w/
    tracepoints
  tracing: provide trace_seq_reserve()
  tracing: add missing 'extern' keywords to trace_output.h
  kmemtrace: use tracepoints
  kmemtrace: kmemtrace_alloc() must fill type_id
  kmemtrace: restore original tracing data binary format, improve ABI
  kmemtrace: update usage of ring_buffer_lock_reserve()

 include/linux/rcuclassic.h  |    1 -
 include/linux/rcupdate.h    |    1 -
 include/linux/rcupreempt.h  |    2 +-
 include/linux/slab_def.h    |   10 +-
 include/linux/slub_def.h    |   12 +-
 include/trace/kmemtrace.h   |   92 +++++--------
 kernel/trace/kmemtrace.c    |  304 +++++++++++++++++++++++++++++++------------
 kernel/trace/trace.h        |    6 +
 kernel/trace/trace_output.c |   13 ++
 kernel/trace/trace_output.h |   38 +++---
 mm/slab.c                   |   24 ++--
 mm/slob.c                   |   28 ++---
 mm/slub.c                   |   30 ++---
 13 files changed, 340 insertions(+), 221 deletions(-)

