Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbYKDEWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbYKDEWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 23:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbYKDEWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 23:22:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52929 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbYKDEWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 23:22:06 -0500
Message-Id: <20081104041554.605521183@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 03 Nov 2008 23:15:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] ftrace: code consolidation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ For 2.6.29 ]

The first two patches makes ftrace function calling and other
sensitive tracing use a macro to handle preemption disabling.
This removes a lot of duplicate code that works on preventing
the scheduler from infinite recursion.

The last patch sets an easy way for the user to either use
irq disabling or preemption disabing for the function tracer.

Peter Zijlstra noticed a bit of a trace that was not showing
up due to lost traces caused by interrupts when the function
tracer was running.

Due to the sensitive nature of the function tracer, it can
not allow for recursive tracing, so it needs to disable
recursion while it records the trace. But this also means
that without disabling interrupts, any interrupt that happens
while the trace is happening will be lost from the trace
itself.

-- Steve

