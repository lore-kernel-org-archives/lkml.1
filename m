Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYLVJZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYLVJZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 04:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYLVJYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 04:24:54 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:3494 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYLVJYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 04:24:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rdgo+97anatJm039C58YF6sLF00YDLeSPSiMnVPvPnWDBMGnt0ZPKs59dETxEjN4/8
         FKY6H6T4vmrDpI4vpaXQpnVW13Ua68L0/c26qUillCqW1b6GVpxdwB6R8ljCm+CAPa+J
         Xh5FbJqbTdZR/fyB5+islkROZbKLvUHrInTq8=
Message-ID: <c62985530812220124r5360df9fxa814af5345064b07@mail.gmail.com>
Date: Mon, 22 Dec 2008 10:24:51 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] hrtimer: increase clock min delta threshold while interrupt hanging
Cc: "Frans Pop" <elendil@planet.nl>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081222090545.GA2064@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <494EEC60.4080708@gmail.com> <200812220307.16808.elendil@planet.nl>
	 <20081222070044.GC29160@elte.hu>
	 <c62985530812220100m775c2e5ek5889f7891e4c1f4d@mail.gmail.com>
	 <20081222090545.GA2064@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/22 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> > Also, there's min_delta doubling in tick_dev_program_event() itself
>> > too - that interacts with the irq-overload logic:
>> >
>> > +       dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
>> >
>> >        Ingo
>>
>> That's what I explained above, the doubling of min delta in
>> tick_dev_program_event() is never reached in my case. And moreover I'm
>> not sure it is ever reached whatever the call sites of
>> tick_dev_program_event() unless min delta has a very low value...
>
> yeah, that looks all rather messy and probably ineffective. Thomas, mind
> to take a look?
>
> Frederic's patch solves a real timer-irq-overload extreme situation so i
> find it rather valuable. Maybe we should do Frederic's patch as-is, have
> the 'softer' min_delta behavior for the usual hrtimer codepaths - and the
> more agressive one for the timer tick only?
>
>        Ingo
>

Oh a little thing.
I wonder if 5 iterations to notice a hang is not too low for embedded
systems on certain
situations.... Since embedded systems could need high resolution
timers for real time....

Actually perhaps 10 iterations would be more reasonable....
