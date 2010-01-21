Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020Ab0AUMCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0AUMCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 07:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795Ab0AUMCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 07:02:32 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:35762 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0AUMCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 07:02:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B563mTZDFUZoYMqmhLHDBD9zqcG+Jt8iY4An4BY3WCzkjHVznz35BiqQFiFn1M0Rq6
         YErdnHZ55Q+XKAEYS0unJUVnMugKEUGakBC0Vx27PM4mQ0wSfkoiqyIwccELdkJGRQ6x
         8NcsQM+sLo8syTToIyuuZy00CF4FoCzjuibeI=
Date: Thu, 21 Jan 2010 13:02:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
Message-ID: <20100121120224.GE5017@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com> <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop> <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop> <20100118144556.GE10364@nowhere> <bd4cb8901001210208h758a546cw19fc81300164ec55@mail.gmail.com> <20100121104513.GA5017@nowhere> <bd4cb8901001210344n1aea2f78l62848f55ea462e84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4cb8901001210344n1aea2f78l62848f55ea462e84@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 12:44:03PM +0100, Stephane Eranian wrote:
> > If the scheduling validation fails, then you just need to rollback
> > the whole group.
> >
> > That's sensibly what you did in your patch, right? Except the loop
> > is now handled by the core code.
> >
> >
> Ok, I think I missed where you were actually placing that loop.
> So you want to do this in group_sched_in(), right?



Exactly!


 
> >
> > I don't understand why that can't be done with the above model.
> > In your patch we iterate through the whole group, collect events,
> > and schedule them.
> >
> > With the above, the collection is just done on enable(), and the scheduling
> > is done with the new pmu callbacks.
> >
> > The thing is sensibly the same, where is the obstacle?
> >
> There is none. You've just hoisted the some of the code from
> hw_perf_group_sched_in().


Exactly :)

