Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZINQG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZINQG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZINQGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:06:54 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46543 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZINQGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Teayv2ByevSWFqoxG/d4XP/MeaQVBb0nSv4oo1iXOaZ2OmJ7FPrC7DAzpD1vW/7llz
         57UoZ8F276RjgzsbtX+GsAX+blru3b2ligFUdFImKfWf/OzPyaKN+Ry1EkGmH7zx3MpX
         aa/lDlmbRmscRMMl4vQb/roHUxxzvLhQvla7U=
MIME-Version: 1.0
In-Reply-To: <20090914153616.GD3164@pengutronix.de>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
	 <20090913230008.GC30169@n2100.arm.linux.org.uk>
	 <20090914002100.GD30621@shareable.org>
	 <20090914081001.GB14519@n2100.arm.linux.org.uk>
	 <94a0d4530909140558nd8d2c47lc9954563c80a574f@mail.gmail.com>
	 <20090914140059.GC21580@n2100.arm.linux.org.uk>
	 <94a0d4530909140738t7e4d646r134cfd884da21348@mail.gmail.com>
	 <20090914144028.GG21580@n2100.arm.linux.org.uk>
	 <94a0d4530909140814w36f7f5f0td2c25db07fbd4e57@mail.gmail.com>
	 <20090914153616.GD3164@pengutronix.de>
Date: Mon, 14 Sep 2009 19:06:55 +0300
Message-ID: <94a0d4530909140906v72865664w3976766e57bf2aa3@mail.gmail.com>
Subject: Re: [PATCH] arm: remove unused code in delay.S
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Marek Vasut <marek.vasut@gmail.com>, Jamie Lokier <jamie@shareable.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 6:36 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Mon, Sep 14, 2009 at 06:14:08PM +0300, Felipe Contreras wrote:
>> On Mon, Sep 14, 2009 at 5:40 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Mon, Sep 14, 2009 at 05:38:32PM +0300, Felipe Contreras wrote:
>> >> On Mon, Sep 14, 2009 at 5:00 PM, Russell King - ARM Linux
>> >> <linux@arm.linux.org.uk> wrote:
>> >> > On Mon, Sep 14, 2009 at 03:58:24PM +0300, Felipe Contreras wrote:
>> >> >> On Mon, Sep 14, 2009 at 11:10 AM, Russell King - ARM Linux
>> >> >> <linux@arm.linux.org.uk> wrote:
>> >> >> > On Mon, Sep 14, 2009 at 01:21:00AM +0100, Jamie Lokier wrote:
>> >> >> >> Russell King - ARM Linux wrote:
>> >> >> >> > On Sun, Sep 13, 2009 at 11:28:47PM +0200, Marek Vasut wrote:
>> >> >> >> > > >                 bhi     __delay
>> >> >> >> > > >                 mov     pc, lr
>> >> >> >> > > >  ENDPROC(__udelay)
>> >> >> >> > > >
>> >> >> >> > > Hi
>> >> >> >> > >
>> >> >> >> > > why was this code there in the first place ?
>> >> >> >> >
>> >> >> >> > To make the delay loop more stable and predictable on older CPUs.
>> >> >> >>
>> >> >> >> So why has it been commented out, if it's needed for that?
>> >> >> >
>> >> >> > We moved on and it penalises later CPUs, leading to udelay providing
>> >> >> > shorter delays than requested.
>> >> >> >
>> >> >> > So the choice was either stable and predictable on older CPUs but
>> >> >> > buggy on newer CPUs, or correct on all CPUs but gives unnecessarily
>> >> >> > longer delays on older CPUs.
>> >> >>
>> >> >> Why not add an #ifdef CPU_V4 or whatever?
>> >> >
>> >> > Because then you get it whenever you configure for V4 as the lowest
>> >> > denominator CPU, which leads to the buggy behaviour on better CPUs.
>> >> > It's far better to leave it as is and just accept that the old CPUs
>> >> > will have longer than necessary delays.  If people really really
>> >> > care (and there's likely to only be a small minority of them now)
>> >> > changing the '0' to a '1' is a very simple change for them to carry
>> >> > in their local tree.  Unlike getting the right unrolling etc.
>> >>
>> >> Well, they can also 'git revert' this patch. If somebody really cares
>> >> I think they should shout now and provide a better patch, otherwise
>> >> this one should be merged.
>> >
>> > On the other hand, having the code there as it currently stands is not
>> > harmful in any way, so leaving it there is just as easy.
>>
>> It makes the code less understandable. I'm not sure about linux's
>> practices, but an #if 0 generally means somebody is being lazy.
>
> And what about a comment like "Try including the following code if ..."? I
> think I saw this somewhere else in the kernel and I'd be fine with that. So,
> while I generally agree that "#if 0" looks suspicious, there are a few cases
> for it, though they need documentation IMHO.

I agree. I don't think the current form is acceptable, at the very
least there should be a comment: enable the following code if ...

Then the next question arises: why not make it a configuration option?
To which the answer seems to be: because very very few people would
care about this.

Which would then be followed by: if we don't care enough about this
code in order to have a configuration option to actually use it; why
do we have it all?

The minority that would make use of this code is theoretical, and
these users by definition know they need this code, therefore, if the
code is not there, they'll notice, then, if the change is acceptable
by them, they will just revert the patch and not complain, if it's
unacceptable, then they will complain and the code can be
re-introduced. The issue will sort itself out.

If it turns out nobody complains about removing this code you would
have made the linux kernel 16 lines cleaner for free.

Cheers.

-- 
Felipe Contreras
