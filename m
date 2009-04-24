Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZDXTQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZDXTQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZDXTQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:16:50 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:15238 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbZDXTQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gnlwUpTukSukWKMsLwVJAo0Xnw/vk7X0kyIEnoRx416GUpIt4nI5C987Ru7cpyRgUK
         7AD5oM4J7Q0U+h5PbcIVJ2RWMcpY291SA+FEHMZL5IXEBa4o43LH5Y/fgS9o5wtlomsB
         dkLDkYG/rBBDNDbtHFzcbHB5m1s5FaVosmgBQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
	 <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com>
	 <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
Date: Fri, 24 Apr 2009 21:16:48 +0200
Message-ID: <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
From: Zeno Davatz <zdavatz@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Hannes Wyss <hwyss@ywesee.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David

On Fri, Apr 24, 2009 at 9:00 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 24 Apr 2009, Zeno Davatz wrote:
>
>> Apr 24 09:01:06 thinpower [1349923.693331] Out of memory: kill process
>> 21490 (apache2) score 53801 or a child
>> Apr 24 09:01:06 thinpower [1349923.693410] Killed process 21490 (apache2)
>>
>
> If your machine hangs here, then it's most likely because apache2 is
> getting stuck in D state and cannot exit (and it has access to memory
> reserves because of TIF_MEMDIE since it has been oom killed, so it may
> deplete all memory).
>
> I'm assuming that you're describing a machine hang as the inability to
> ping it or ssh into it, not simply your apache server dying.

Yes correct. I could neither SSH into the machine nor could I type
anything on the screen after I connected the monitor and the keyboard
directly to the machine.

> These types of livelocks are possible with the oom killer when a task
> fails to exit, one possible way to fix that is to introduce an oom killer
> timeout such that if a task fails to exit for a pre-defined period of
> time, the oom killer will choose to kill another task in the hopes of
> future memory freeing.  The problem with that approach, however, is that
> the hung task can consume an enormous amount of memory that will never be
> freed.

Thanks for the hint! Is there another solution as well? Any
Kernel-Upgrades in the Pipeline? What does Linus think about this?

>> > If this is reproducible, I'd recommend enabling
>> > /proc/sys/vm/oom_dump_tasks so that the oom killer will dump the tasklist
>> > and show us what may be causing the livelock.
>>
>> Ok, how do I enable that? I will google for it.
>>
>
> You're right in your reply, you can enable it with
>
>        echo 1 > /proc/sys/vm/oom_dump_tasks
>
> This will print the tasklist and some pertinent information alongside the
> oom killer output you've already posted.  It will give a better idea of
> the memory usage on the machine and if killing a subsequent task would
> actually help in this case.

Ok done that. Actually not looking forward that it hangs again but if
it does we should catch some fish. ;)

Best
Zeno
