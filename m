Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0ASPzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0ASPzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398Ab0ASPzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:55:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:7125 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab0ASPzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ir/1jg0gYhJoMiU2LPEOMyjoLPzuGM4oh3vdBG/up6nku/UMtV12QmJ19BzDgfilRQ
         N/3FoBCZqU07L8zzr+Kl27sVKuJ8yhB8ZVCZ8Td+J4tOrsto6WDVAJUwhSafOQW3PAKs
         vQ3S9F9wHeKGszXHIDkQ0dVRYwLqApsAntVAQ=
Date: Tue, 19 Jan 2010 16:55:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
Message-ID: <20100119155508.GE8061@nowhere>
References: <1263825158.4283.590.camel@laptop> <20100118144556.GE10364@nowhere> <1263826601.4283.603.camel@laptop> <20100118161836.GG10364@nowhere> <1263831973.4283.622.camel@laptop> <20100118165114.GJ10364@nowhere> <1263834806.4283.625.camel@laptop> <20100118172935.GM10364@nowhere> <1263903773.4283.657.camel@laptop> <1263907489.4283.663.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263907489.4283.663.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 02:24:49PM +0100, Peter Zijlstra wrote:
> Hrmph, so I read some of that hw_breakpoint stuff, and now I'm sorta
> confused, it looks like ->enable should never fail, but that means you
> cannot overcommit breakpoints, which doesn't fit the perf model nicely.



Yeah :)
I described this in my previous mail to you. Breakpoint events, for
now, are not supposed to fail on enable().


But once we have the strict pinned -> flexible ordering,
I'll rework this.

 
> Also, I see you set an ->unthrottle, but then don't implement it, but
> comment it as todo, which is strange because that implies its broken. If
> there's an ->unthrottle method it will throttle, so if its todo, the
> safest thing is to not set it.


Yeah, that's because I have a too vague idea on what is the purpose
of the unthrottle() callback.

I've read the concerned codes that call this, several times, and I still
can't figure out what happens there, not sure what is meant by throttle
or unthrottle there :-/

 
> /me mutters something and goes look at something else for a while.


Yeah, that's still a young code that needs improvement :)

