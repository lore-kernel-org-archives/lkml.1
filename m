Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZEGGp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZEGGp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 02:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZEGGpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 02:45:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45897 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZEGGpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 02:45:17 -0400
Date: Thu, 7 May 2009 08:41:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to
	simplify do_wait() pathes
Message-ID: <20090507064120.GB15220@redhat.com>
References: <20090506053324.GA31988@redhat.com> <20090506072756.GA17457@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506072756.GA17457@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06, Ingo Molnar wrote:
>
> One small nit with the definition above: when using vertical spacing
> (which really looks nice) we tend to put the asterix to the type
> itself, not to the variable. I.e.:
>
> 	enum pid_type		wtype;
> 	struct pid *		wpid;
> 	int			wflags;
>
> ( This is done to separate the field name from the type - the
>   pointer nature of the field is part of the type, not part of the
>   name. )

Indeed, I like this more too. But checkpatch.pl disagrees!

> it makes sense to write this as:
>
> > +	wopts.wtype	= type;
> > +	wopts.wpid	= pid;
> > +	wopts.wflags	= options;
> > +
> > +	wopts.winfo	= infop;
> > +	wopts.wstat	= NULL;
> > +	wopts.wrusage	= ru;
> > +
> > +	ret = do_wait(&wopts);
>
> (and in other places as well). Vertical spacing for assignments
> looks messy if done for 1-3 assignment lines, but in the case above
> we've got 6 of them so it has a nice vertical structure already that
> helps readability.

Done.

> Regarding the patch itself: i guess we could do it as-is - but if
> you think there's regression risks, a safer approach would be to
> create 5-6 patches to build up all the structure parameters one by
> one.

Oh, I tried to do it this way first. But I got lost and decided to
make a single patch. Besides, if I make 6 patches I should try to test
each one...

> Anyway ... provided you give it some testing:

Well, I did now. But of course this needs more testing. As you see,
the patch is trivial, it "must" be correct. Except some silly typos
are possible.

> Reviewed-by: Ingo Molnar <mingo@elte.hu>

Thanks!

Oleg.

