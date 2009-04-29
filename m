Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbZD2FKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbZD2FKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZD2FK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:10:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbZD2FK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:10:27 -0400
Date: Tue, 28 Apr 2009 22:07:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/5] tracing: convert ftrace_dump spinlocks to raw
Message-Id: <20090428220723.5b85fcae.akpm@linux-foundation.org>
In-Reply-To: <20090429045904.381487770@goodmis.org>
References: <20090429044814.138790038@goodmis.org>
	<20090429045904.381487770@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 00:48:15 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> +	local_irq_save(flags);
> +	__raw_spin_lock(&ftrace_dump_lock);

I'm counting twentyish instances of this.  Maybe it's time to give up
and implement raw_spin_lock_irqsave().

