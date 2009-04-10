Return-Path: <linux-kernel-owner+w=401wt.eu-S1763151AbZDJOru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763151AbZDJOru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 10:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZDJOrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 10:47:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:49501 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZDJOrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 10:47:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TcL7XINKkSir8i+fQwOCn4khlesMbDN7Z76GHTGjSAx4P9zJhlzZtSBX/42GrvSDn2
         TlpvIY0nVZL1k/a9NSUP8luTcaRoWrK+BcP2lWRs1IpadD5LqxpVSq91xQwmOdgBouLp
         0ovMaf3tajbq0QSGoDrhqPrmKBvkSAbpwR07k=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904101329170.21577@localhost.localdomain>
References: <8db1092f0904070037q426fd8dcx4aa48c70e40b5d6c@mail.gmail.com>
	 <20090409212028.7b2aa88c.akpm@linux-foundation.org>
	 <8db1092f0904100340g7b7eb310y805e8680a32e3ac8@mail.gmail.com>
	 <alpine.LFD.2.00.0904101329170.21577@localhost.localdomain>
Date: Fri, 10 Apr 2009 16:47:36 +0200
Message-ID: <8db1092f0904100747w297a0daas9ebd05486d06e706@mail.gmail.com>
Subject: Re: [2.6.29-git12] BUG: scheduling while atomic: swapper/0/0x10000100
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/10 Thomas Gleixner <tglx@linutronix.de>:
> On Fri, 10 Apr 2009, Maciej Rutecki wrote:
>
>> 2009/4/10 Andrew Morton <akpm@linux-foundation.org>
>>
>> > Did this get fixed?
>>
>> On 2.6.30-rc1-git3 still the same:
>> [  162.541793] BUG: scheduling while atomic: swapper/0/0x10000100
>
> Yikes.
>
> 0x10000100
>       ^----- softirq count leaked.
>
> We have a check for that in do_softirq, but none in do_IRQ. Can you
> please apply the patch below and test whether it triggers ?

When I try connect with bluetooth, and connecting hangs, very often I
observe high load of cpu, and system was very unresponsive. ksoftirqd
has up to 100% load:
http://unixy.pl/maciek/download/kernel/2.6.30-rc1-git3/laptop/img_0002.jpg

After this I reboot laptop.

>From syslog:
http://unixy.pl/maciek/download/kernel/2.6.30-rc1-git3/laptop/syslog.txt

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
