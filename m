Return-Path: <linux-kernel-owner+w=401wt.eu-S1761812AbZJNPEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761812AbZJNPEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760942AbZJNPEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:04:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761288AbZJNPEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:04:09 -0400
Subject: [BUG] perf top shows no data
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 14 Oct 2009 11:02:10 -0400
Message-Id: <1255532530.7113.4570.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I have a box where "perf top" shows no data. I get the header, but it
never shows anything. I bisected it down to this commit.

42e59d7d19dc4b49feab2a860fd9a8ca3248c833
perf tools: Default to 1 KHz auto-sampling freq events

Which, besides the whitespace clean ups is simply:

-static int                     freq                            =  0;
+static int                     freq                            =   1000; /* 1 KHz */

Which, BTW, whitespace clean ups would have been nicer in a separate
patch. It was a bit of a PITA to find what actually changed.

Peter tells me that the freq stuff is a bit fragile. Note, latest pref
top works on other boxes. Just not this one.

-- Steve


