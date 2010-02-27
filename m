Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936306Ab0B0VuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:50:20 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60678 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936236Ab0B0VuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:50:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=om5JrByfQYvOYrIWBKNvBIcNqXQgQbu7bRQRx9IKDlXH5csuzFRfLNIBRwj6ykpPkw
         IKygxl6GWOWaJM9Uz9G4rygdz44cb9s78htFNM8Cx35Pa4vNzN4hc5Brc+Jd2hYJJgOt
         s9ZLfMTFoQkrhhL5adFdf0eaoV0jawmI4ZqSk=
MIME-Version: 1.0
In-Reply-To: <201002272007.43042.rjw@sisk.pl>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	 <201002271323.14402.rjw@sisk.pl> <20100227124710.GA21164@elte.hu>
	 <201002272007.43042.rjw@sisk.pl>
Date: Sat, 27 Feb 2010 22:50:15 +0100
X-Google-Sender-Auth: 3eaf8958b7f4d986
Message-ID: <10f740e81002271350n1d13b104i58207b40192e9f01@mail.gmail.com>
Subject: Re: linux-next requirements
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 20:07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday 27 February 2010, Ingo Molnar wrote:
>> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> > > > Lets see.  Over the last 60 days, I have reported 37 build errors.  Of
>> > > > these, 16 were reported against x86, 14 against ppc, 7 against other
>> > > > archs.
>> > >
>> > > So only 43% of them were even relevant on the platform that 95+% of the
>> > > Linux testers use? Seems to support the points i made.
>> >
>> > Well, I hope you don't mean that because the majority of bug reporters (vs
>> > testers, the number of whom is unknown to me at least) use x86, we are free
>> > to break the other architectures. ;-)
>>
>> It means exactly that: just like we 'can' break compilation with gcc296,
>> ancient versions of binutils, odd bootloaders, can break the boot via odd
>> hardware, etc. When someone uses that architectures then the 'easy' bugfixes
>> will actually flow in very quickly and without much fuss
>
> Then I don't understand what the problem with getting them in at the linux-next
> stage is.  They are necessary anyway, so we'll need to add them sooner or
> later and IMO the sooner the better.
>
> Apart from this, that cross-build issues aren't always "easy" and sometimes
> they take quite some time and engineering effort to resolve.  IMO that's better
> done at the linux-next stage than during a merge window.
>
>> - and without burdening developers to consider cases they have no good ways
>> to test.  Why should rare architectures be more important than those other
>> rare forms of Linux usage?
>
> Because the Linus' tree is supposed to build on those architectures.  As long
> as that's the case, linux-next should build on them too.
>
>> In fact those rare ways of building and booting the kernel i mentioned are
>> probably used _more_ than half of the architectures that linux-next
>> build-tests ...
>
> I don't know and you don't know either.  That's just pure speculation and
> therefore meaningless.

If only the CE Linux Forum member companies would publish figures about the
number of Linux devices they push onto the world population...

Yes I know, this still excludes `obsolete' architectures like parisc
and alpha, but it would
change the balance towards x86 (and powerpc?) drastically.

>> So yes, of course _all_ bugs need fixing if there's enough capacity, but the
>> process in general should be healthy, low-overhead and shouldnt concentrate on
>> an irrelevant portion of Linux usage in such a prominent way.
>>
>> Or, if it does, it should _first_ cover the other, much more burning areas of
>> testing interest. All the while our _real_ bugreports are often rotting on
>> bugzilla.kernel.org ...
>
> All right.  There are two _separate_ questions to ask IMO:
>
> (1) Do we need the kind of community service that Stephen has been doing?
>
> (2) Do we need more testing of linux-next and if so, who's task should that be?
>
> I think you agree that the aswer to (1) is "yes, we do".  So _someone_ has to
> do it and I'm very grateful to Stephen for taking care of it.
>
> [Thanks, Stephen!]
>
> Now, the part of this service is to check that the resulting tree will actually
> build in all conditions it's supposed to build in, if possible, or the whole
> merging exercise wouldn't have much practical meaning.  Stephen has been
> doing just that and IMO to a good result.
>
> To some extent, though, that's a matter of defining in what conditions the
> kernel is supposed to build in, but I think for linux-next these conditions
> should be the same as for the Linus' tree, for the simple reason that
> linux-next is supposed to be a "future snapshot" of it.   So linux-next should
> build on all architectures that the future Linus' tree is supposed to build on.
> Even on "exotic" ones.
>
> [IMO that's actually important, because such corner cases tend to reveal
> runtime bugs we wouldn't have been aware of otherwise.  Now, in the majority
> of cases a casual tester will be discouraged by the kernel not compiling for
> him while he might have found a "real" bug otherwise.]
>
> Now, as far as (2) and is concerned, I think the answer here is also "yes, we
> do", but that's not a part of the Stephen's job.

While wearing my m68k hat, I can say that I suffer an order of
magnitude more from
build failures than from boot failures. So I'm inclined to agree with
Linus when he says
`if it compiles, it's great; if it boots, it's perfect' :-)

Or perhaps this says more about our review process: we're quite good at catching
logical errors in our code, and worse at catching syntax and dependency errors.
Fortunately we have tools (and linux-next) to catch those...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
