Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbXEVUTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbXEVUTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbXEVUS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:18:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:48001 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbXEVUS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iZb5IGh8i+uxNm7k0ahZ90+y2JvnDVTgBUTgUGP7QzE7PS9QuqM1Q85Qs9KUMM8auIt9JKguPtAQNyetfQVWJHWbSI4RT6c+GIWAA8e0qfQ5nRcs3paoFS8UV0UbBQpJ7Qh5f8UFAhP6la4kJTYmeyF2jAf+mQVhO3azz686aeA=
Message-ID: <b14e81f00705221318n43dbb53ex77a454e0eade4fb7@mail.gmail.com>
Date: Tue, 22 May 2007 16:18:57 -0400
From: "Michael Chang" <thenewme91@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [ck] Re: [PATCH] mm: swap prefetch improvements
Cc: "Con Kolivas" <kernel@kolivas.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Ray Lee" <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       "ck list" <ck@vds.kolivas.org>, linux-mm@kvack.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070522104648.GA10622@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <200705222020.58474.kernel@kolivas.org>
	 <20070522102530.GB2344@elte.hu>
	 <200705222037.54741.kernel@kolivas.org>
	 <20070522104648.GA10622@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Con Kolivas <kernel@kolivas.org> wrote:
>
> > On Tuesday 22 May 2007 20:25, Ingo Molnar wrote:
> > > * Con Kolivas <kernel@kolivas.org> wrote:
> > > > > > there was nothing else running on the system - so i suspect the
> > > > > > swapin activity flagged 'itself' as some 'other' activity and
> > > > > > stopped? The swapins happened in 4 bursts, separated by 5 seconds
> > > > > > total idleness.
> > > > >
> > > > > I've noted burst swapins separated by some seconds of pause in my
> > > > > desktop system too (with sp_tester and an idle gnome).
> > > >
> > > > That really is expected, as just about anything, including journal
> > > > writeout, would be enough to put it back to sleep for 5 more seconds.
> > >
> > > note that nothing like that happened on my system - in the
> > > swap-prefetch-off case there was _zero_ IO activity during the sleep
> > > period.
> >
> > Ok, granted it's _very_ conservative. [...]
>
> but your first reaction was "it should not have slept for 5 seconds":
>
> | Hmm.. The timer waits 5 seconds before trying to prefetch, but then
> | only stops if it detects any activity elsewhere. It doesn't actually
> | try to go idle in between
>
> It clearly should not consider 'itself' as IO activity. This suggests
> some bug in the 'detect activity' mechanism, agreed? I'm wondering
> whether you are seeing the same problem, or is all swap-prefetch IO on
> your system continuous until it's done [or some other IO comes
> inbetween]?

The only "problem" I can see with this idea is in the potential case
that it takes up all the IO activity, and so there is never enough IO
activity from other progams to trigger the wait mechanism because they
don't get a chance to run.

That could probably be "fixed" by capping the IO, though... (with one
of those oh-so-lovable "magic numbers" or a tunable)

That said, I don't think there are any issues with the code
compensating for its own activity in the "detect activity" mechanism
-- assuming there wasn't a major impact in e.g. maintainability or
something.

As for the burstyness... considering the "no negative impact" stance,
I can understand that. But it seems inefficient, at best...

-- 
Michael Chang

Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html
Thank you.
