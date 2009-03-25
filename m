Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZCYCfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZCYCfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZCYCfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:35:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62369 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbZCYCfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:35:33 -0400
Date: Tue, 24 Mar 2009 22:35:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Avoid double-free of dyn_ftrace
Message-ID: <20090325023531.GA9748@goodmis.org>
References: <49BA23D9.1050900@cn.fujitsu.com> <20090313092558.GD2571@elte.hu> <18199AAD941A4071B7FD8A0D6C67733A@zhaoleiwin> <alpine.DEB.2.00.0903241152020.22830@gandalf.stny.rr.com> <7867D4500D2F4CFFB36A9EA93C0DC2D5@zhaoleiwin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7867D4500D2F4CFFB36A9EA93C0DC2D5@zhaoleiwin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 10:25:47AM +0800, Zhaolei wrote:
> >> > 
> >> > I'm wondering, did you trigger this in practice (if yes, how?), 
> >> > or have you found it via code review?
> >> Hello, Ingo
> >> 
> >> It is found via code review.
> > 
> > Hmm, could you explain this more. I'm thinking that this scenario should 
> > not happen, and if it does, it should probably be a bug.
> > 
> > Because when we call ftrace_free_rec we change the rec->ip to point to the 
> > next record in the chain. Something is very wrong if rec->ip >= s && 
> > rec->ip < e and the record is already free.
> Hello, Steven
> 
> Thanks for your comment.
> I got your meaning, and I agree that if rec->ip >= s && rec->ip < e,
> this record is not freed.
> But IMHO, "if rec->ip >= s && rec->ip < e" is used to select records in the module,
> and function of ignore "freed record" is only its side-effect.
> So, add a special judgement to avoid "freed record" is not a bad idea.
> And I also agree your suggestion of add a WARN_ON, because this should not happened.

Hi Zhaolei,

Great! Feel free to send another patch ;-)

Note, use FTRACE_WARN_ON() macro. This way it shuts down ftrace if it is hit and 
helps to avoid further damage later.

-- Steve

