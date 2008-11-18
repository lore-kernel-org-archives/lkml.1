Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbYKRPcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbYKRPcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYKRPby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:31:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYKRPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:31:53 -0500
Date: Tue, 18 Nov 2008 10:31:51 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: walimis <walimisdev@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: fix wrong pos computing when read buffer
 has been fulfilled.
In-Reply-To: <20081118151721.GA23383@ubuntu.mshome.net>
Message-ID: <alpine.DEB.1.10.0811181031200.15003@gandalf.stny.rr.com>
References: <1226733546-23190-1-git-send-email-walimisdev@gmail.com> <alpine.DEB.1.10.0811180933490.15003@gandalf.stny.rr.com> <20081118151721.GA23383@ubuntu.mshome.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Nov 2008, walimis wrote:
> On Tue, Nov 18, 2008 at 09:36:07AM -0500, Steven Rostedt wrote:
> >> 
> >> fix:
> >> 
> >> Through checking return value of seq_printf, if less than 0, we know
> >> this function doesn't be printed. Then we decrease position to force
> >> this function to be printed next time, in next read buffer.
> >
> >A lot of the code for seq files I cut and paste from other places that I 
> >have written it. The seq files always confuse me, so I like to use stuff 
> >that worked before. Some of the things that walimis fixed were not needed 
> >for this file, and was overkill.

> It also confuse me a lot. I also checked all places using seq files in
> trace/ftrace code, to see whether there are similar problem.
>   - trace.c: in s_start() it force pos to decrease one such as: 
> 	l = *pos - 1;
> 	so it works well.
>   - trace_stack.c: t_start, in almost all cases, can be only called
>     once, so we don't see the error. But I wonder whether it still works
>     well if output message exceeds the size of seq file buffer and call
>     t_start twice. If needed, I can test it.
>   - trace_branch.c : the same with above.
> 

If you can find a bug, then by all means, fix it ;-)

Thanks,

-- Steve

