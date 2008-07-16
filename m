Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYGPJcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYGPJcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYGPJcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:32:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:29314 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYGPJcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MAsdJNPhZ/bfe3WVWoEl2/2/MVFldwjfuWZuwVSzguF5gkuiSg/iByv3I8if7HxSfl
         VUZd0XKZegV6qAImFJE9mv/j47txKdyDESa5HKuMXOMSg+e5rZ0PuEZlGpaiuefp3W3e
         XQAffgRGcQFojcY1Y4lWMEDBrdJPei50Oud/Y=
Message-ID: <19f34abd0807160232u635891fai2450f29e71c801b6@mail.gmail.com>
Date: Wed, 16 Jul 2008 11:32:03 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 4d3702b6 (post-v2.6.26): WARNING: at kernel/lockdep.c:2731 check_flags (ftrace)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>
In-Reply-To: <Pine.LNX.4.58.0807160010490.25043@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807151855k22dc80d5tf3629da2e52ee6de@mail.gmail.com>
	 <Pine.LNX.4.58.0807160010490.25043@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 6:13 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Things get weird between lockdep and ftrace because ftrace can be called
> within lockdep internal code (via the mcount pointer) and lockdep can be
> called with ftrace (via spin_locks).
>
> Can you try this patch out and see if it fixes your problem. I only
> compiled tested it.
>
> Note: I'll be traveling for the next couple of weeks, so I will be on and
> off with email.
>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace_sched_wakeup.c |   27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)

Works for me! :-)

There's no warning during self-tests. But then again, I didn't try
tracing anything else either.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
