Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab0CBUcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:32:43 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:33007 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab0CBUcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:32:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jdZPubpXcUpJq5sxYY4bjhIEdlNYYgthoB+KjVdsp+egfu0peJADLWSsj0CAtMW7OQ
         6VbpBCLjt+9Vdd0J7UWfdHCt5IGavI/evbCxfLitblT57caqQxj8c1Pv5KTHl40bPOXF
         ioEdt/63MqkiS6bhD/0WHZtUWe0hGSDi6dQm0=
MIME-Version: 1.0
In-Reply-To: <1267461438.5157.9586.camel@thor.local>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
	 <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
	 <20100226081418.5902446f.akpm@linux-foundation.org>
	 <b170af451002260933i6a7a5e1el619f8e71c3ae0bc8@mail.gmail.com>
	 <20100226190100.GQ10145@sci.fi>
	 <b170af451002270133v6c44a6bcnf5751a6338c61a63@mail.gmail.com>
	 <1267461438.5157.9586.camel@thor.local>
Date: Tue, 2 Mar 2010 21:32:37 +0100
Message-ID: <b170af451003021232r7b4e961egbf572248d5784c26@mail.gmail.com>
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to sleep 
	(w. timeout) until wake_up
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 1 marca 2010 17:37 użytkownik Michel Dänzer <michel@daenzer.net> napisał:
> On Sat, 2010-02-27 at 10:33 +0100, Rafał Miłecki wrote:
>> W dniu 26 lutego 2010 20:01 użytkownik Ville Syrjälä <syrjala@sci.fi> napisał:
>> > Disabling the condition check doesn't make sense.
>> >
>> > You could use a completion.
>> >
>> > init_completion(vbl_irq);
>> > enable_vbl_irq();
>> > wait_for_completion(vbl_irq);
>> > disable_vbl_irq();
>> > and call complete(vbl_irq) in the interrupt handler.
>> >
>> > The same would of course work with just some flag or counter
>> > and a wait queue.
>>
>> Ouch, I can see it gone bad already.
>>
>> Firstly I simply just wanted to avoid condition in wait_event_*. It
>> looked unnecessary as I got interrupts (signals).
>
> So this code runs in user process context? If so, it should return to
> userspace ASAP on signal receipt, otherwise e.g. smoothness of X mouse
> movement may suffer.
>
> If that's a problem, then maybe the code should run in a different
> context, e.g. a tasklet or some kind of worker kernel thread.

It has nothing to do with userspace. Please see my previous description:



W dniu 26 lutego 2010 13:16 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> W dniu 26 lutego 2010 12:55 użytkownik Thomas Gleixner
>> Sleeping in the timer handler ? In which context runs this timer handler ?
>
> We have our struct delayed_work which we first init and then we use
> "queue_delayed_work" to start this "timer". So it's not real-real
> timer as struct timer_list.
>
> So this is actually delayed_work handler. Sorry (again) for my bad naming.



It's delayed_work.

-- 
Rafał
