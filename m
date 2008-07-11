Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYGKOss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYGKOss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbYGKOs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:48:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:43115 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYGKOs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=alnqSCzTpQPHXtuSZ5drOjzwwi2r1gNVYELeeUaa4WxlMPyYl+dqd4jIrqP24XH7Ve
         BO4iVlCD+RNmI89xXGbllTeK5QB3/sV0vTvTgkK9nq4ryzFLx9GAvnGf8BtKUbA+e6t3
         BYqV9r4iseA6ToLdHrMtq2+5qT1SPbj5dddTs=
Message-ID: <487772B6.4090100@gmail.com>
Date: Fri, 11 Jul 2008 17:48:22 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: today's linux-next fails to boot
References: <4877400B.1000400@gmail.com> <s5hy747rvpr.wl%tiwai@suse.de> <48775C69.6050107@gmail.com> <20080711135937.GA25004@elte.hu>
In-Reply-To: <20080711135937.GA25004@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-07-11 16:59, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>
>   
>>> [Added Ingo to Cc]
>>>
>>> I get the boot problem on i386 with 2008-07-11 linux-next tree, too.
>>> In my case, no error appears on the screen, just staying blank and
>>> dead.  It seems stopping at the very beginning, soon after GRUB, so
>>> could be the same reason.
>>>   
>>>       
>> I don't see any boot messages on the screen, I get that BUG message as
>> soon as grub's menu dissapears.
>> I have bisected it to this range so far:
>> git-bisect good aa03060a78c1aec53075a0c8ca7be19cedfbea8f
>> git-bisect bad b1611c0058bc6635e7257e755c3f194933a7a6df
>>
>> Should I continue to bisect?
>>     
>
> could you check latest tip/master, does it boot fine with the same 
> config?
>   

tip/master boots fine.

On 2008-07-11 16:36, Vegard Nossum wrote:
> One really simple way of getting some more info out of this is to take
> the EIP value (here c0181ca0) and run it through addr2line:
>
>     $ addr2line -e vmlinux -i c0181ca0

Thanks for the hint, I rebuilt a failing kernel, and this is what
addr2line says:

$ addr2line -e vmlinux -i c0181ca0

??:0
$ addr2line -e vmlinux -f c0181ca0
kmem_cache_alloc
??:0

Best regards,
--Edwin


