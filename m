Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZI3I1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZI3I1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 04:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZI3I1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 04:27:39 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:38467 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZI3I1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 04:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qe6q9rLV7ly50hI8WCBJcEAM/Rm/TAzs+oxRZfVsX5jgUlZD//SBv5571leGvuDZac
         J7JA86t2I1MlQI4NeroUp8JRPhiOXpYcwAtJk73jVVo23Jg/8oGZVYP2HDDCy5DZjpVx
         PZ5L/+oBWVaXMbn5AkGJd4KTi1tW08fbAH1PE=
MIME-Version: 1.0
In-Reply-To: <20090930102037.55db07ed@hammerfall>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
	 <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
	 <20090929072454.GA11414@elte.hu>
	 <2674af740909290231m5af0fbc6t5fba0b127c63bd9f@mail.gmail.com>
	 <20090930095043.48e7081f@hammerfall>
	 <2674af740909300101x2ef4bbdewc12d52e703bdadf@mail.gmail.com>
	 <20090930102037.55db07ed@hammerfall>
Date: Wed, 30 Sep 2009 16:27:42 +0800
Message-ID: <2674af740909300127k255715d8se1c267089ed9283a@mail.gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
	hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
	__sysdev_resume+0xc3/0xe0()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 4:20 PM, Michal Schmidt <mschmidt@redhat.com> wrote:
> Dne Wed, 30 Sep 2009 16:01:40 +0800
> Yong Zhang <yong.zhang0@gmail.com> napsal(a):
>> From my previous mail, I have ask Maciej to test the blow patch:
>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>> index fb0f46f..4a00a1a 100644
>> --- a/kernel/time/timekeeping.c
>> +++ b/kernel/time/timekeeping.c
>> @@ -569,6 +569,9 @@ static int timekeeping_resume(struct sys_device
>> *dev) unsigned long flags;
>>        struct timespec ts;
>>
>> +       WARN_ONCE(!irqs_disabled(),
>> +               KERN_INFO "timekeeping_resume() called with IRQs
>> enabled!"); +
>>        read_persistent_clock(&ts);
>>
>>        clocksource_resume();
>>
>> And indeed, the warning is showed.
>
> Is it? After Maciej tested it, he said:
>> no "timekeeping_resume() called with IRQs enabled!".
> which I read as: no such message was shown.
>

Just check again.
OMG, I'm blind for so long time.
Yeah, it seem like 89133f9 fix this issue.
Sorry again.

Thanks,
Yong

> Michal
>
