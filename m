Return-Path: <linux-kernel-owner+w=401wt.eu-S965409AbYD1Prf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965409AbYD1Prf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935278AbYD1PkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:40:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39836 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934933AbYD1PkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:40:23 -0400
Date: Mon, 28 Apr 2008 17:39:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Pekka Paalanen <pq@iki.fi>
Subject: Re: ftrace and debugfs weird interaction
Message-ID: <20080428153956.GH18776@elte.hu>
References: <20080426185403.GA22522@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426185403.GA22522@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi,
> 
> When trying to figure out what was going on with the sched tracer
> "tracing_enabled" file (sched-devel.git tree), I fell on this strange
> behavior :
> 
> echo 1>tracing_enabled seems _not_ to send 1 to the tracing_ctrl_write
> callback. However, sending garbage, e.g. echo s> tracing_enabled,
> correctly sends the 's' character down the chain. echo 0>tracing_enabled
> sometimes results in the callback not even being called.
> 
> The debugfs file has been created with
> 
>         entry = debugfs_create_file("tracing_enabled", 0644, d_tracer,
>                                     &global_trace, &tracing_ctrl_fops);
>         if (!entry)
>                 pr_warning("Could not create debugfs 'tracing_enabled' entry\n");
> 
> I wonder what kind of weird debugfs interaction we might have here ?

hm. Cc:-ed more ftrace developers.

	Ingo
