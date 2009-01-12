Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZALR5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZALR5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZALR52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:57:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52432 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZALR51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:57:27 -0500
Date: Mon, 12 Jan 2009 12:57:23 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andy Whitcroft <apw@canonical.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch warning of struct indentation
Message-ID: <alpine.DEB.1.10.0901121253350.22796@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm now seeing the following warnings from checkpatch:

#325: FILE: kernel/trace/trace_stat.c:21:
+	void 			*stat;

ERROR: "foo 	*bar" should be "foo *bar"
#334: FILE: kernel/trace/trace_stat.c:27:
+	struct tracer_stat 	*ts;

ERROR: "foo		*bar" should be "foo	*bar"
#337: FILE: kernel/trace/trace_stat.c:30:
+	struct dentry		*file;

This is for:

struct tracer_stat_session {
        struct list_head        session_list;
        struct tracer_stat      *ts;
        struct list_head        stat_list;
        struct mutex            stat_mutex;
        struct dentry           *file;
};

Which looks a hell of a lot better than:

struct tracer_stat_session {
        struct list_head session_list;
        struct tracer_stat *ts;
        struct list_head stat_list;
        struct mutex stat_mutex;
        struct dentry *file;
};

We probably do not want to warn on such things.

-- Steve

