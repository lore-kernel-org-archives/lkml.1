Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZETR0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZETR0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbZETR0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:26:07 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:52106 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZETR0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=aNbc5juitsT9zGZAoMNYfwkxRlPKlZUnEHT229Y9wgeBf9R+K0OVdJGXWc+wCxLu3a
         lQz/vs+9WXG0nrBstf0Es3Hnm8Ji4nZuMgyrV9E4ZYeYdaIyPV32WVSgvQpK5njoax+L
         fehuzUKXqVhxmpJLVp0YH2wmd98wsrVhozWIk=
Date: Wed, 20 May 2009 19:26:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ming Lei <tom.leiming@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: fix check for return value of
	register_module_notifier in event_trace_init
Message-ID: <20090520172559.GA5973@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is a fixlet from Ming Lei which fixes a spurious warning.

Thanks.


The following changes since commit fd51d251e4cdb21f68e9dbc4336514d64a105a79:
  Stefan Raspl (1):
        blktrace: remove debugfs entries on bad path

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Ming Lei (1):
      ftrace: fix check for return value of register_module_notifier in event_trace_init

 kernel/trace/trace_events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---
>From 5537937696c55530447c20aa27daccb8d0d29b33 Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Mon, 18 May 2009 23:04:46 +0800
Subject: [PATCH] ftrace: fix check for return value of register_module_notifier in event_trace_init

register_module_notifier() returns zero in the success case.
So fix the inverted fail case check in trace events modules
handler.

[ Impact: fix spurious warning on ftrace initialization]

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0eec0c5..9e91c4a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1174,7 +1174,7 @@ static __init int event_trace_init(void)
 	}
 
 	ret = register_module_notifier(&trace_module_nb);
-	if (!ret)
+	if (ret)
 		pr_warning("Failed to register trace events module notifier\n");
 
 	return 0;
-- 
1.6.2.3



