Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbZBTBdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbZBTBdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZBTBdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:33:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396AbZBTBdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:33:22 -0500
Date: Thu, 19 Feb 2009 17:32:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, fweisbec@gmail.com, torvalds@linux-foundation.org,
       arjan@infradead.org, rusty@rustcorp.com.au,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, srostedt@redhat.com
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
 conversions
Message-Id: <20090219173210.73318ebc.akpm@linux-foundation.org>
In-Reply-To: <20090220011521.003556651@goodmis.org>
References: <20090220011316.379904625@goodmis.org>
	<20090220011521.003556651@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 20:13:20 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> +int ftrace_arch_modify_prepare(void)
> +{
> +	/* at boot up, we are still writable */
> +	if (system_state != SYSTEM_RUNNING)
> +		return 0;
> +
> +	set_kernel_text_rw();
> +	return 0;
> +}
> +
> +int ftrace_arch_modify_post_process(void)
> +{
> +	/* at boot up, we are still writable */
> +	if (system_state != SYSTEM_RUNNING)
> +		return 0;
> +
> +	set_kernel_text_ro();
> +	return 0;
> +}

It would be prudent to avoid using system_state.  People can change the
point at which it transitions and can unexpectedly insert (or move)
code to sites where system_state has new values, etc.  It was a bad
idea.

It would be clearer and more robust to create your own little flag for
this purpose and set to it true and false at the places where that is
appropriate for this application.  It's just one more byte...
