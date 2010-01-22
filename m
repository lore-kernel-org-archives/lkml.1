Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994Ab0AVBQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab0AVBQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498Ab0AVBQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:16:26 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53143 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab0AVBQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=D3XaP2Rt3BLDn1l4jQ9z+b6lqFmBSni/kEWA3nbOeNJetwfg34aJN68Vi9MzDzF2j9
         p3TamUeWdi9sconWXz7PCiiHi+7UcWBhODjV6AWnXgaOqCQzawFdMr8iX8A/rK/1VFlD
         qkp2B3MBb9hRCdRO0c/s6PH9MaOxCgliO64ME=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 00/10] Ftrace functions hashlist
Date: Fri, 22 Jan 2010 02:16:12 +0100
Message-Id: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This set exports the functions hashlist in use by the functions
profiler for more general uses.

For now it has fixed a scalability problem in the function graph
tracer concerning the function start filtering (toward
set_graph_function file).

This is especially the beginning of a work to allow multiple function
(and function graph) tracers instances usable in parallel with
their own dynamic ftrace parameters. The plan is then to make
these tracers available for wider uses like perf, toward the trace
event api or whatever...

This is still in RFC stage because with this patchset,
the set of function filters from set_graph_function is only
active after the function graph tracer is enabled. If
set_graph_function is changed in the middle of the tracing, the
filters will be actually updated only after you switch to another
tracer and re-switch to the grah tracer. But that should be
fixed in a further iteration.

Frederic Weisbecker (9):
  ftrace: Generalize the function hashlist from function profiler
  ftrace: Ensure tracing has really stopped before leaving unregister_ftrace_graph
  ftrace: Drop the ftrace_profile_enabled checks in tracing hot path
  ftrace: Ensure buffers are visibles to tracing callbacks right away
  ftrace: Drop buffer check in function profiler callbacks
  ftrace: Release the function hlist if we don't need it anymore
  ftrace: Make the function hashlist concurrently usable
  tracing: Use the hashlist for graph function
  ftrace: Factorize search and insertion in the function hashlist

Lai Jiangshan (1):
  tracing: Simplify test for function_graph tracing

 kernel/trace/Makefile                |    1 +
 kernel/trace/ftrace.c                |  378 ++++++++++------------------------
 kernel/trace/functions_hlist.c       |  289 ++++++++++++++++++++++++++
 kernel/trace/functions_hlist.h       |   54 +++++
 kernel/trace/trace.h                 |   21 +--
 kernel/trace/trace_functions_graph.c |   46 ++++-
 6 files changed, 493 insertions(+), 296 deletions(-)
 create mode 100644 kernel/trace/functions_hlist.c
 create mode 100644 kernel/trace/functions_hlist.h

