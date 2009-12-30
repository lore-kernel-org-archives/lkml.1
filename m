Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023AbZL3BSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbZL3BSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZL3BSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:18:53 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60351 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZL3BSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:18:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V+YIYUmbzLnOQ0Nm/Ncfvqn0SSDn/UeXSMK6u/gOr9bONLRC7XKyhZfE5w41fyM7Fp
         dWCU4tmM8YmZut3RXXlBecJ4F3j5sL53BNrex5iNrqha2FNPwAVMl0KAQS3OkvpQb9kr
         D+0KbxFWuoIzWLyZoKTMIGosIilgg9b1HK+fc=
MIME-Version: 1.0
In-Reply-To: <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
References: <200912271003.631128760@firstfloor.org>
	 <20091227233816.GC2399@basil.fritz.box>
	 <1261986136.808.2.camel@wall-e>
	 <20091228145749.GD4994@basil.fritz.box>
	 <1262016510.12656.25.camel@wall-e>
	 <20091228172651.GE4994@basil.fritz.box>
	 <1262030653.15368.37.camel@wall-e>
	 <20091228204003.GH4994@basil.fritz.box>
	 <1262076056.23095.21.camel@wall-e>
	 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
Date: Tue, 29 Dec 2009 20:18:50 -0500
Message-ID: <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Vikram Dhillon <dhillonv10@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stefani Seibold <stefani@seibold.net>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO you can process elements rather than bytes, which is a good
improvement, but then again its my opinion, if others don't like it
then we can always change it :D

Regards,
Vikram Dhillon

~~~
There are lots of Linux users who don't care how the kernel works, but
only want to use it. That is a tribute to how good Linux is.
-- Linus Torvalds



On Tue, Dec 29, 2009 at 5:27 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Dec 29, 2009, at 12:40 AM, Stefani Seibold <stefani@seibold.net> wrote:
>
>> Am Montag, den 28.12.2009, 21:40 +0100 schrieb Andi Kleen:
>>
>>
>>> OK i checked and they all use power-of-two currently so by sheer
>>> luck (I doubt it is by design) they work. Still I think that
>>> open deathtrap should be fixed.
>>>
>>
>> It is fixed, and i hope it will be included in 2.6.34.
>>
>>> I also don't understand how that patch "breaks your future work"
>>> Please elaborate on that.
>>>
>>
>> Very difficult to explain in a email, but i will try it:
>>
>> The new macro based kfifo API handles everything as elements of a given
>> type. So you can have the old "unsigned char"-fifo, but also fifo of
>> every other type like int's, struct's and so on. The kfifo_in() and
>> kfifo_out() len parameter is than in the meaning of elements not bytes.
>> So you are able to process more than one value at a time and the macros
>> will return the number of processed elements (not bytes).
>
> Does anyone want this kind of functionality though? Why can't we keep the
> old interface as is (and maybe deprecate it) and use the new record API you
> mentioned below for record-oriented kfifos.
>
> Thanks.
>
> --
> Dmitry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
