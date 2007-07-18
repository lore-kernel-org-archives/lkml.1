Return-Path: <linux-kernel-owner+w=401wt.eu-S934355AbXGRRxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355AbXGRRxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762287AbXGRRxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:53:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:12621 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbXGRRxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:53:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q82PjB/6LojRsNKG2BAQDdL0DgZOaeSafcvhTov3ZREYUaQRZz/xP7KRYxEzjdXFPqGCRUp7SF8ayXmF8rPOqlqwYvUZCYiZEooxazVSpSu3bVURkdwOkuAYMdfHmmMo//aAKNtOb39UQiSTRNR8LPLsGgWFMhs4smSagPnatU8=
Message-ID: <29495f1d0707181053n13c3a1b4r8b05a5e20de59e22@mail.gmail.com>
Date: Wed, 18 Jul 2007 10:53:34 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Roman Zippel" <zippel@linux-m68k.org>,
       "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <469C3FE8.30505@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21003.1184596954@lwn.net>
	 <Pine.LNX.4.64.0707161654130.1817@scrub.home>
	 <2c0942db0707160857s25cbce19j7f057b14e74651e8@mail.gmail.com>
	 <29495f1d0707160908x32704c7o41ab7857ceac1558@mail.gmail.com>
	 <469C3FE8.30505@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Nish Aravamudan wrote:
>
> > Well, before these changes, the only guarantee msleep() could make,
> > just like the only guarantee schedule_timeout() could make, was that
> > it would not return early. The 1-jiffy sleep was always tough to deal
> > with, because of rounding and such. And it's simply exacerbated with
> > HZ=100. It's not technically 20 times longer in all cases, it's 2
> > jiffies longer, which depends on HZ, so varies from 2 msecs longer to
> > 20 msecs longer.
>
> I don't think you should rely on anything else actually, because Linux
> is not an RT OS. If your driver needs a specific sequence in a given
> amount of time, you have to do something like disable interrupts and
> use delays.

I agree -- I wasn't trying to indicate what one should or should not
do. Just tried to provide some insight into the intent behind the
interfaces. They were never meant to be precise, per se -- simply
guaranteeing the request would be satisfied, with no upper bound. I
agree that if timing really is that critical then delays or more
accurate timing specifications would be appropriate (one reason to use
msecs_to_jiffies() and co. rather than jiffies directly in drivers,
perhaps).

Thanks,
Nish
