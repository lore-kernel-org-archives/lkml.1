Return-Path: <linux-kernel-owner+w=401wt.eu-S965645AbXCMJc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbXCMJc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965656AbXCMJc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:32:26 -0400
Received: from mail05.syd.optusnet.com.au ([211.29.132.186]:37832 "EHLO
	mail05.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965645AbXCMJc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:32:26 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 20:31:38 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200703111457.17624.kernel@kolivas.org> <20070313081805.GA22327@elte.hu> <200703132021.50712.kernel@kolivas.org>
In-Reply-To: <200703132021.50712.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703132031.39370.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 20:21, Con Kolivas wrote:
> On Tuesday 13 March 2007 19:18, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > > [...] The situation as we speak is that you can run cpu intensive
> > > tasks while watching eye-candy.  With RSDL, you can't, you feel the
> > > non-interactive load instantly. [...]
> >
> > i have to agree with Mike that this is a material regression that cannot
> > be talked around.
> >
> > Con, we want RSDL to /improve/ interactivity. Having new scheduler
> > interactivity logic that behaves /worse/ in the presence of CPU hogs,
> > which CPU hogs are even reniced to +5, than the current interactivity
> > code, is i think a non-starter. Could you try to fix this, please? Good
> > interactivity in the presence of CPU hogs (be them default nice level or
> > nice +5) is _the_ most important scheduler interactivity metric.
> > Anything else is really secondary.
>
> Well I guess you must have missed where I asked him if he would be happy if
> I changed +5 metrics to do whatever he wanted and he refused to answer me.
> That would easily fit within that scheme. Any percentage of nice value he
> chose. I suggest 50% of nice 0. Heck I can even increase it if he likes.
> All I asked for was an answer as to whether that would satisfy his
> criterion.

It seem Mike has chosen to go silent so I'll guess on his part. 

nice on my debian etch seems to choose nice +10 without arguments contrary to 
a previous discussion that said 4 was the default. However 4 is a good value 
to use as a base of sorts.

What I propose is as a proportion of nice 0:
nice 4 1/2
nice 8 1/4
nice 12 1/8
nice 16 1/16
nice 20 1/32 (of course nice 20 doesn't exist)

and we can do the opposite in the other direction
nice -4 2
nice -8 4
nice -12 8
nice -16 16
nice -20 32

Assuming no further discussion is forthcoming I'll implement that along with 
Al's suggestion for staggering the latencies better with nice differences 
since the two are changing the same thing.

-- 
-ck
