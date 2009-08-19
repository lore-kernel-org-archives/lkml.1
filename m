Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZHSVq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZHSVq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZHSVq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:46:56 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:45445 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZHSVq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:46:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j5icfcKCTE96kUdYNJU+YcpFj9lgzm3Q9kbIKKO1tCFzEGqJv66lzc2di5LLeb+iFG
         Quv8pm1Pk0m+HCjHy8yvp1O/Nrcj/vEXvN+/D/4q4/9s+sb+Hb23954etUzOJYkUJ1W6
         FAKgE21JHqjcHlaA9OElWBtsHCIFPwtlKoCIk=
MIME-Version: 1.0
In-Reply-To: <m14os3lkb9.fsf@fess.ebiederm.org>
References: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>
	 <4A80C2F8.2040208@gmail.com>
	 <d12c1890908101825t44138bf4x9a4733ece6f74b88@mail.gmail.com>
	 <d12c1890908111528p47cdd30bw24749e34fc1cc8d3@mail.gmail.com>
	 <4A835760.2050803@gmail.com> <m14os3lkb9.fsf@fess.ebiederm.org>
Date: Wed, 19 Aug 2009 18:46:56 -0300
Message-ID: <d12c1890908191446k5497d9c8t2f355074eb7ca4ff@mail.gmail.com>
Subject: Re: Flooded by do_IRQ: 0.91 No irq handler for vector
From: Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have changed my distro to sidux, so it won't be an easy task to
return to 2.6.24....
Anyway, I do use the 64bit kernel.
But I've downloaded the 32 bit version (sidux 2009.02 with the
2.6.30.1 kernel), and the very same error occurs. I've just used the
live cd, and it does happen.
Something that changed from 2.6.28 to 2.6.30 is that it no longer
happens the 0.99 message. All complaints are about 0.91...
One more thing: Deleting /usr/sbin/irqbalance changed nothing, which
is no surprise, as I had already tested the noirqbalance kernel
option....

I'm pasting here something I had previously replied personally to
Robert Hancock, and may be useful:

Well, as I've installed sidux, it has upgraded the kernel to 2.6.30.5,
but the error is the same.
I've also tried:
* noapic: the message changes to do_IRQ: 0.55 No irq handler for
vector (irq -1), but then the X server fails to start
* noacpi: have no effect on the error message.


Thanks a lot.
--
Luis Fernando Planella Gonzalez


2009/8/19 Eric W. Biederman <ebiederm@xmission.com>:
> Robert Hancock <hancockrwd@gmail.com> writes:
>
>> On 08/11/2009 04:28 PM, Luis Fernando Planella Gonzalez wrote:
>>> I'm really concerned that all those interrupts might slow down the
>>> computer somehow...
>>> Here is an attached syslog part after a reboot.
>>> Sometimes, the ratelimit says that thousands of callbacks were suppressed.
>>> Is there a way to make this message be displayed only once?
>>>
>>> In arch/x86/kernel/irq.c, the line 213 is:
>>> irq = __get_cpu_var(vector_irq)[vector];
>>>
>>> In my case, the returned irq is -1. Doesn't it makes sense to not log
>>> the "No irq handler for vector" message when irq<  0?
>>>
>>> Or even a deeper answer: Why, in my case, the resulting irq is -1?
>>
>> Not logging would just cover up the problem, the issue in your case is that
>> something seems to be asserting a ton of interrupts on an IRQ line that no
>> driver has claimed..
>
> It is slightly worse.  We are seeing interrupts asserted and we don't
> know which IRQ line they belong to.  This should never happen.
>
> You say it is first 0.99 and 0.91 so it is moving.
>
> Luis are you running a 64bit kernel?  I think you would have to be
> for your symptoms to go all of the way back to 2.6.24.
>
> My primary suspect is that something the irq migration code is not
> working properly on your computer.  Could you disable
> /usr/sbin/irqbalance (possibly just by deleting it) and tell me if
> that fixes your symptoms?
>
> If not we have a very nasty bug in how your ioapics are being programmed.
>
> Eric
>
