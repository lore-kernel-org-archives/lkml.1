Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZJGRBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZJGRBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZJGRBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:01:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZJGRBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:01:19 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] tracing - wrong scale in ftrace_release
Date: Wed,  7 Oct 2009 19:00:33 +0200
Message-Id: <1254934835-363-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the module is about the unload we release its call records.
The ftrace_release function was given wrong values representing
the module core boundaries, thus not releasing its call records.

I prepared 2 patches:

1/2 - simple fix putting correct core boundaries 
2/2 - making ftrace_release function module specific

Please choose whichever version you like more.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c       |  150 +++++++++++-------------------------------
 kernel/trace/trace.c        |  106 ++++++++++++++++++++++++++++++
 kernel/trace/trace.h        |   35 ++++++++++
 kernel/trace/trace_events.c |   60 ++++-------------
 4 files changed, 194 insertions(+), 157 deletions(-)
