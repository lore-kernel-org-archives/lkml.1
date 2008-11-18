Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbYKROgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbYKROgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYKROgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:36:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37366 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYKROgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:36:10 -0500
Date: Tue, 18 Nov 2008 09:36:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: walimis <walimisdev@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: fix wrong pos computing when read buffer
 has been fulfilled.
In-Reply-To: <1226733546-23190-1-git-send-email-walimisdev@gmail.com>
Message-ID: <alpine.DEB.1.10.0811180933490.15003@gandalf.stny.rr.com>
References: <1226733546-23190-1-git-send-email-walimisdev@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 15 Nov 2008, walimis wrote:

> 
> hi Steven,
> 
> Could you help me to review this patch?
> 
> Thanks.
> 
> Impact: make output of available_filter_functions complete
> 
> phenomenon:
> 
> The first value of dyn_ftrace_total_info is not equal with
> `cat available_filter_functions | wc -l`, but they should be equal.
> 
> root cause:
> 
> When printing functions with seq_printf in t_show, if the read buffer
> is just overflowed by current function record, then this function
> won't be printed to user space through read buffer, it will
> just be dropped. So we can't see this function printing.
> So, every time the last function to fill the read buffer, if overflowed,
> will be dropped.
> This also applies to set_ftrace_filter if set_ftrace_filter has
> more bytes than read buffer.
> 
> fix:
> 
> Through checking return value of seq_printf, if less than 0, we know
> this function doesn't be printed. Then we decrease position to force
> this function to be printed next time, in next read buffer.

A lot of the code for seq files I cut and paste from other places that I 
have written it. The seq files always confuse me, so I like to use stuff 
that worked before. Some of the things that walimis fixed were not needed 
for this file, and was overkill.

> 
> another little fix is to show correct allocating pages count.

Ack.

> 
> Signed-off-by: walimis <walimisdev@gmail.com>

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

