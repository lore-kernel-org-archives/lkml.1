Return-Path: <linux-kernel-owner+w=401wt.eu-S965044AbXDKDRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044AbXDKDRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966128AbXDKDRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:17:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:17083 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965044AbXDKDRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lHnXPxP9FLiu+0U5iiZK86o68Kc7/RAeej1uix7JVTkVdf8/khw83/zkFl4mRPQS8BdJJmM4aAwfv2+aIF0cch6lKx7HAHJwGq/CChx09tAKFnDx5PRpAqCR7DZRcZBcL8K6Ny5izCPK4Z+2ak12k0o4H/iGuMZs9j7e8Z4txVM=
Message-ID: <787b0d920704102017g7b7a1b04k4e7b1cae8ea5380@mail.gmail.com>
Date: Tue, 10 Apr 2007 23:17:11 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [PATCH] Only send pdeath_signal when getppid changes.
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Robin Holt" <holt@sgi.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       "Jack Steiner" <steiner@americas.sgi.com>
In-Reply-To: <20070410174852.88661D82F8@pipsqueak.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m1ejmsxh33.fsf@ebiederm.dsl.xmission.com>
	 <20070410174852.88661D82F8@pipsqueak.sf.frob.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, Roland McGrath <roland@redhat.com> wrote:
> > Does a parent death signal make most sense between separately written programs?
>
> I don't think it does.  It has always seemed an utterly cockamamy feature
> to me, and I've never understood what actually motivated it.

It's useful, but the other case is more important.

> > Does a parent death signal make most sense between processes that are part of
> > a larger program.
>
> That is the only way I can really see it being used.  The only actual
> example of use I know is what Albert Cahalan reported.  To my mind, the
> only semantics that matter for pdeath_signal are what previous uses
> expected in the past and still need for compatibility.  If we started with
> a fresh rationale from the ground up on what the feature is good for, I am
> rather skeptical it would pass muster to be added today.

Until inotify and dnotify work on /proc/12345/task, there really isn't
an alternative for some of us. Polling is unusable.

Ideally one could pick any container, session, process group,
mm, task group, or task for notification of state change.
State change means various things like destruction, addition
of something new, exec, etc. (stuff one can see in /proc)
With appropriate privs, having the debug-related stuff would be
good as well.
