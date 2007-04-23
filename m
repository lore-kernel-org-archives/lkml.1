Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbXDWIpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbXDWIpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXDWIpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:45:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:1220 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbXDWIpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=LQB0GYUahS1MhTmYOO2iugGLiuZ/z+n8sfDVOYOvLdOTlTfbs2iNZxflO/dSCwXpsZBDPSYwGoLF3495qCDL1R7hPi2bplMD79Dy6qwInUPvDolVwdIXw8dMR9RNALDAA67wIKwVkcVyvYg69xqZiPDKicZUxTF5xE3SjAt7G5U=
Date: Mon, 23 Apr 2007 11:45:38 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <74966835.20070423114538@gmail.com>
To: David Brownell <david-b@pacbell.net>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: is there any generic GPIO chip framework like IRQ chips?
In-Reply-To: <200704181922.44635.david-b@pacbell.net>
References: <f17812d70704090309l8dd764cxc06fbd7b765c55d8@mail.gmail.com> <200704151247.57724.david-b@pacbell.net> <424488534.20070417190535@gmail.com> <200704181922.44635.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

Thursday, April 19, 2007, 5:22:44 AM, you wrote:

>> >> > So, talking about what an (optional) implementation framework might
>> >> > look like (and which could handle the SOC, FPGA, I2C, and MFD cases
>> >> > I've looked at):
>> 
>> > See patches in following messages ... a preliminary "gpio_chip" core
>> > for such a framework, plus example support for one SOC family's GPIOs,
>> > and then updating one board's handling of GPIOs, including over I2C.
>> 
>>         Just to compare, diffstats for GPIODEV:

> Now, if they were functionally equivalent, such a comparison
> would be less of an apples/oranges thing!

        But of course they are functionally equivalent! They do the
same thing - manage GPIOs. They even do it in very similar ways. To
remind, the only differences we (I) come to, are:

1. Structured GPIO identifiers instead of scalar.
2. No explicit adhoc structures similar to irq_desc & irq_chip.
3. Lesser (even though slightly) latency.
4. Not tied to not really directly related notions like "platform".

        Any optimization which you apply to your implementation can be
applied to GPIODEV. GPIODEV was submitted in that form because its
first requirement was to replace simple chip-adhoc GPIO accessors, so
there's no additional things like reporting GPIO info to userspace
(but again, that can be added, even based on your implementation).


> The most useful comparison would focus on technical aspects of
> the gpio_chip abstraction itself (i.e. $SUBJECT).

        Nice. But $SUBJECT is a specific question, and it was answered
in one of the first messages of the thread: No, there's no GPIO chip
framework like IRQ chips [in the mainline], and there're concerns if a
framework in such form ("like IRQ chips") is needed at all, and
alternative implementation was proposed.

>>       it needs work - it doesn't adhere to your own
>> optimization scheme by using lookup table instead of list.

> I thought it was more important to address the $SUBJECT first:

        Well, is this your last argument why your implementation is
better: GPIO chip framework is needed just because there's some random
mail subject which mentions it?

        Anyway, the discussion happens under this subject just because
current of discussion followed in this way. The one of topics of
the discussion was presentation of alternative to gpio_chip
implementation, so please don't tell I do offtopic here.

> get a working gpio_chip abstraction which covers all the needed
> functionality.  The patch had a hook for implementing such tweaks,
> but it wasn't used.

> The next version you'll see lets the platform code use its own
> existing lookup code, as part of slimming things down a bit.
> I also decided to take out the debugfs support.


>>                you speak about constructor
>> parts which "anyone" can use to construct whatever GPIO API they like,
>> whereas I'm speaking about exact API implementation which can be used
>> right away.

> I most certainly did not speak about "whatever GPIO API they like"!!

> Quite the contrary, in fact.  Please don't put words in my mouth.
> (You've been doing it quite extensively in this thread; it's rude.)

        I kindly apologize if heat of discussion led me so far. But
maybe information you supplied was a bit scarce, and that made me
imagine too much?

        Let's recollect with what the discussion started: proposal
from myself and other HH.org developers of the alternative implementation,
and you quickly verdicted that without specific patches, you stop the
discussion. They were posted, technical aspects of them were
discussed, and compared to your proposed implementation. In the end,
you posted your patches, which doesn't even correspond with the
implementation you yourself presented, and adapted only for OMAP.

        And we both understand well why we can't reach agreement here:
we represent different communities with different needs. You
represent "platform hacking" community, and it's all sunny in your
realm, while we're machine-hacking guys, and we'd rather exactly hack
machines, but regularly bump into different "platform" and
"architecture" issues which we'd be glad not to deal with at all. But
we have to, and then based on this painful experience we design new
things which are not unnecessarily tied to specific platform or
architecture, at the same time trying to alleviate burden on
platform on architecture maintainers.

> And that "core" patch I posted was clearly usable "right away";
> otherwise the two examples _using_ it couldn't have worked.

        It works "right away" only on OMAP. For other (sub)archs,
header patching is required and that's clearly not "right away" for
the scope of mainline Linux, which we discuss here (because it makes
little sense to discuss feudalistic trees at all - in them, anything
can be done in any way without my or your guidelines how to do that).

        Now that other (sub)archs need cut'n'paste patches, it's quite
another task to push them back to mainline, as again, that would go
thru overbusy platform and architecture maintainers, and their
platforms and architectures oftentimes have more priority stuff to be
done, or have quite another vision at all, etc. etc.


>>         Well, besides gpio_keys we here have asic3_keys, samcop_keys,
>> etc. - all that duplication just because the current GPIO API doesn't
>> allow extensibility to more chips.

> When I get tired of repeating myself, just remember:  the current
> programming interface *DOES* allow such extensibility.

        Well, I tirelessly keep agreeing to that, like I did
thruout the whole thread. It's just way of such extensibility is
challenged, and arguably better way is proposed.

>   That's what it
> means to be an "interface", rather than an implementation:  it defines
> inputs and outputs, allowing any process that conforms to both.

> In fact, the patches I sent demonstrated exactly that extensibility.
> Same interface, additional chips; different implementation inside.


>> > So you're agreeing that, at a technical level, what I described
>> > could be augmented by a "caching" facility ... giving a programming
>> > interface with all the characteristics of your "GPIODEV" thingie.
>> 
>> > All you're really disagreeing with is bootstrapping issues; and
>> > whether there is in fact a need for such a layer.  The only argument
>> > I could possibly buy is that it avoids the lookup of (b) ... but
>> > that doesn't seem to matter in most cases I've looked at.


>> So, now the most important question is what we all would get
>> with your approach in the end.
>> 
>> So, if you could make sure gpiolib.c doesn't contain inefficient
>> implementation,

> I can make it comparable to existing implementations that work
> the same way ... e.g. AT91 and OMAP code.

        Why would you compare it to such implementations? Please
compare it to the patches that we submitted, which address the same
problem as yours, not to some random implementation for specific
architecture.

>   Of course, it's not
> possible to get away from the cost of function indirection, with
> a generic gpio_chip abstraction.  Or those lookup costs; but as
> you agreed, those costs don't seem to matter much.  And if they
> ever do matter, caching support would be easy to add.


>> and make such extensible implementation available by default
>> for ARM PXA/S3Cxxx/OMAP, then it's for sure cover Handhelds.org's,
>> and many other peoples' usecases, and that would be highly
>> appreciated.
>> 
>> If you could do it for 2.6.22 merge window, that would
>> straight ideal.

> I think having an optional gpio_chip, not unlike what was in
> that one patch, should be reasonable; also, making it work on
> some platforms that I use.  But I don't think there's much
> overlap between those platforms and what hh.org uses.

        Pity to hear. Especially taking into account that we proposed
the implementation which works on any platform and even architecture
at all (in the sense that it doesn't require special assistance from
platform to allow extensible GPIO handling in the first place).

        I also hear shade of encouragement to keep elaborating
and submitting GPIODEV in your words, but unfortunately that's not
really what I'd like. The whole argument was about having one good
runtime-extensible framework, not two. And I can only accept your
primacy in this question. For us it is after all just one of very many
good patches we'd like to share with community, so I'd better move to
next of them.


> - Dave



-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

