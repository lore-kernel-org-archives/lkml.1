Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbYFBR4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbYFBR4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYFBR4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:56:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51567 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYFBR4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:56:09 -0400
Date: Mon, 2 Jun 2008 13:56:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3][RFC] ftrace: track dynamic ftrace update failures
In-Reply-To: <4842CB8F.2000702@gmail.com>
Message-ID: <Pine.LNX.4.58.0806021354520.10366@gandalf.stny.rr.com>
References: <4842CB8F.2000702@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 1 Jun 2008, Abhishek Sagar wrote:

>
> Hi Steven/Ingo,
>
> In dynamic ftrace any record which fails gets freed to be recycled. This
> happens normally during (although not limited to) tracing of init functions.
> In general, failures can happen due to multiple reason, such as external
> patching of kernel functions, instrumentation of the mcount calls-sites,
> hardware error etc. As an example, in the case of kprobes if a probe is
> installed on the mcount call site (before being converted to NOP or after) then
> eventually ftrace will detect it and free the corresponding record. Kprobes
> however will keep on single-sepping the instruction it installed the probe on.
>
> These patches prevent freeing of records which have failed (except for init
> functions). This prevents re-recording of failed functions and allows tracking
> them so that they can be listed using a new debugfs file -> 'failures'. The
> main change here is preventing removal of ftrace records from ftace_hash. This
> way records can be looked up by their 'ip' at any time.
>

Hi Abhishek,

Have you also taken into account adding and removing of modules? This can
cause some funny behaviours with ftrace that can be rather dangerous.

-- Steve

