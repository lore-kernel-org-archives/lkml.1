Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbYJMMEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbYJMMEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 08:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYJMMDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 08:03:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:13201 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbYJMMDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:newsgroups:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding:from
         :sender;
        b=XTJJFpk0CgfgAIXo4/dgPcw6fS8OBBgthQj4RUhm8MH6JB7N3wAqzfRwlP7IsYSOO9
         hywLfWGbzI2waXcsK21JVUv9cMoiSZiam0n/nNcwUragRqiwzI5ZE90HmK17mC5M06/e
         VoBL4tbhIwKpsJfZD1DP8wumg6TLagz/8yzm4=
Message-ID: <48F33923.1050602@tuffmail.co.uk>
Date: Mon, 13 Oct 2008 13:03:47 +0100
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Yudha Harimantoro T <yudha.ht@gmail.com>
CC: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: 
References: <264b990a0810110030r307829afmc8c2e1dfe6713faa@mail.gmail.com>	 <48F0C24E.9030205@tmr.com>	 <264b990a0810122318p477f7d19ye5e17414c4f5e8f3@mail.gmail.com> <264b990a0810130129m434ce4d1s93ecb63c4d032d2b@mail.gmail.com>
In-Reply-To: <264b990a0810130129m434ce4d1s93ecb63c4d032d2b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yudha Harimantoro T wrote:
> Can you explain to me what the error means?
> I got the kernel panic with the
> http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.27.tar.bz2
> 
> <b>....
> Kernel panic - not syncing: No init found. Try passing init= option to
> kernel</b>
> 
> I still got the error.
> 
> Best regards,
> Yudha_HT


It literally means the kernel can't find /sbin/init, the first userspace program which starts everything else.  It's a less common error - it's more common to fail to mount the root filesystem, e.g. because you forgot to enable e.g. ext3 or sata.

My guess would be your kernel has mounted the wrong filesystem as root.  Which device (partition etc) is your root filesystem on, and what boot options do you pass to the kernel?


 
> 2008/10/13, Yudha Harimantoro T <yudha.ht@gmail.com>:
>> This morning I run `make mrproper` in the kernel tree and rebuild. But
>> it make the kernel panic at 9 s, with the same error.
>>
>> Maybe I'll get the 2.6.27 from the kernel.org now.
>>
>> Thx,
>>
>> Yudha_HT
>>
>> 2008/10/11, Bill Davidsen <davidsen@tmr.com>:
>>> Yudha Harimantoro T wrote:
>>>> Date:	Fri, 10 Oct 2008 16:41:36 -0400
>>>> From:	Bill Davidsen
>>>>
>>>>
>>>>
>>>>> Yudha Harimantoro T wrote:
>>>>>
>>>>>> Hi all,
>>>>>> Yesterday I build kernel 2.6.26.6 and it's run well. Today I got
>>>>>> 2.6.27 patch and try to build it.
>>>>>>
>>>>>> I build with `make oldconfig` and answer any question with default
>>>>>> answer, I just press [enter].
>>>>>> I build with `make`. No error and all compiled.
>>>>>> Then I install with `make modules_install` and `make install`.
>>>>>>
>>>>>>
>>>>
>>>>> I realize that this is a low-probability thought, but did you:
>>>>> - apply the patch against 2.6.26 NOT 2.6.26.6
>>>>>
>>>> Yup, I've did it.
>>>>
>>>>> - run make clean before applying the patch
>>>>>
>>>> I still need this for a pure 2.6.26? I'll try this.
>>>>
>>>>
>>>>>> After reboot the system I got 'kernel panic'.
>>>>>> This is the error picture :
>>>>>> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101358.jpg
>>>>>> Is it a bugs?
>>>>>>
>>>>>> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101353.jpg
>>>>>> [2.6.26.6 run well]
>>>>>>
>>>>
>>>>> I keep configs in a separate place. I would first copy a 2.6.26 tree to
>>>>> a
>>>>> new directory (cp -rl linux-2.6.26 linux2.6.27) then be sure I had a
>>>>> clean copy with "make distclean" (or "make mrproper") and then apply the
>>>>> 2.6.27 patch. Then I would copy the 2.6.26 (or maybe 2.6.26.6) config to
>>>>> .config, and make the oldconfig.
>>>>> None of that is magic, it just keeps me from making common mistakes,
>>>>> lets
>>>>> me start with a clean 2.6.27, etc, etc.
>>>>> You mentioned oldconfig, but not starting back with a clean 2.6.26,
>>>>> which
>>>>> made me think of this.
>>>>>
>>>> Hm, I `cp /boot/config .config` in new kernel tree [2.6.27] for the
>>>> config. Do I make mistakes?
>>>>
>>> No, I was just noting that I try to start oldconfig with a known working
>>> config, to reduce the number of choices and possible errors. I wasn't
>>> sure if you did that, so I mentioned it.
>>>
>>> --
>>> Bill Davidsen <davidsen@tmr.com>
>>>   "Woe unto the statesman who makes war without a reason that will still
>>>   be valid when the war is over..." Otto von Bismark
>>>
>>>
>>>

