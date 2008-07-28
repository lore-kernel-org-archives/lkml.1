Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbYG1Sek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbYG1Sek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYG1Sec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:34:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:44021 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbYG1Seb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YT+Cir0lv+XSDQHhjzJ1lF90lb65cSiy78/ygerb0bqJVC75kI4gX0y0s3JIRaVzC5
         RPAO9wc4ubTQG0GRVmoGXtSiTAHATLqmWPY7sNSLqQtXJdImXPtXTMRjgzfunXr9WB8B
         O+myMe2XWWTIQKbCSQ9AQ3NtLSfDGiumMBXDI=
Message-ID: <5d6222a80807281134r6f7ed626m21be399bbc0ca4a3@mail.gmail.com>
Date: Mon, 28 Jul 2008 15:34:31 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: -git: BUG: unable to handle kernel paging request at c0100248 [CPU hotplug]
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, "Thomas Meyer" <thomas@m3y3r.de>,
       "the arch/x86 maintainers" <x86@kernel.org>
In-Reply-To: <19f34abd0807271240x71fb85e3qae5d7beaad6eaba3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807270255o1ff260a8ucb9d931905aa4947@mail.gmail.com>
	 <b647ffbd0807271014j17d1a14cncd0976ff4d3ff3fd@mail.gmail.com>
	 <19f34abd0807271019i2112498ay57c267354bd63a8c@mail.gmail.com>
	 <alpine.LFD.1.10.0807272118460.574@apollo.tec.linutronix.de>
	 <19f34abd0807271235q516fc2e1rc43c6736044eabfc@mail.gmail.com>
	 <19f34abd0807271240x71fb85e3qae5d7beaad6eaba3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 4:40 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Sun, Jul 27, 2008 at 9:35 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> On Sun, Jul 27, 2008 at 9:23 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>> On Sun, 27 Jul 2008, Vegard Nossum wrote:
>>>> Booting processor 1/1 ip 6000
>>>> Initializing CPU#1
>>>> [...]
>>>> Write protecting the kernel text: 5648k
>>>>
>>>> So it succeeds because the protection happens much later :-)
>>>
>>> Patch below fixes the issue. I get it to Linus ASAP.
>>
>> Nice :)

Just saw this one. Thanks for the quick fix! ;-)

>> [...]
>>
>>> +.section .cpuinit.data,"wa"
>>> +.align 4
>>> +ENTRY(initial_code)
>>> +       .long i386_start_kernel
>>> +
>>>  .section .text
>>>  /*
>>>  * Real beginning of normal "text" segment
>>>
>>
>> Hm, isn't there some kind of "section stack" that can be used to
>> restore the previous section? .pushsection/.popsection directives?
>
> Oh, never mind :-)
>
> (Sorry for the noise.)
>
>
> Vegard
>
> --
> "The animistic metaphor of the bug that maliciously sneaked in while
> the programmer was not looking is intellectually dishonest as it
> disguises that the error is the programmer's own creation."
>        -- E. W. Dijkstra, EWD1036
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
