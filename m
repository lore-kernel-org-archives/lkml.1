Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbZCYMBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbZCYMBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZCYMBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:01:07 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60593 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbZCYMBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=poWkDm4uTFmVnsTbBNHonKrmXKnPYRKKS2ZH6Mh81llR8rYcBll2shrIJhbMMwtBg+
         7YFnIoe7SZEt7HeKHob1OZqbCTJ7Aef5jnUyiNwxJhKzOlqE5pKG6Y+O1rMUqUiWTTYX
         5bLWqdrmO98JE4RBCLyXA6OFkkPuFuXQfZYjs=
MIME-Version: 1.0
In-Reply-To: <OFF2006E59.395DC6C3-ON48257584.001642FB-48257584.0017258D@sunplusct.com>
References: <OFF2006E59.395DC6C3-ON48257584.001642FB-48257584.0017258D@sunplusct.com>
Date: Wed, 25 Mar 2009 12:01:02 +0000
Message-ID: <87a5b0800903250501k3884dfb5qa09c67d209f80a05@mail.gmail.com>
Subject: Re: [PATCH] score - New architecure port to SunplusCT S+CORE 
	processor
From: Will Newton <will.newton@gmail.com>
To: liqin.chen@sunplusct.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/25  <liqin.chen@sunplusct.com>:
>>
>> To allow people to more easily review your patches it is recommended
>> to spit them up into smaller pieces and submit them to the mailing
>> list.
>
> According to the "The linux-kernel mailing list FAQ" and
> "Documentation/SubmittingPatches",
> E-mail size exceeds 40 kB, "it is preferred that you store
> your patch on an Internet-accessibleserver, and provide
>  instead a URL (link) pointing to your patch."
> linux/score patch size over 400 kB, so we only provide
> the URL (link) in mail.

Yes, that's true. However if you split that up into 10-20 separate
emails then it's quite manageable. The advantage of posting to the
list is that many more people will review your code.

You could also cc the linux-arch mailing list.

> But if other person or Linus also think we should spit them up
> into smaller pieces, we will do it.
>
>>
>> Your port looks relatively clean but it looks like it is borrowing
>> heavily from the mips port and you may have a few leftovers from that
>> e.g.:
>>
>
> Yes, we use linux/mips as reference for linux/score platform.
> In order to make the patch clear, we used more C code instead of
> assembler code. After patch merge to the mainline,
> we will provide optimized assembler code one by one.
>
>> - mentions of o32 (unless S+CORE has an o32 ABI?)
>> - does SCORE+ have ll/sc instructions or is that another leftover from
> MIPS?
>
> No, I had removed these leftover code.
>
>> - compatibility syscalls, sys_ipc, old-style signal handling. Are
>> these really needed for a new arch?
>
> Because we use glibc-2.3.6 as base library, LTP and many applications
> are all running on it. so we leave many old syscall in score code,
> once we are sure it's not necessary, we will remove these syscall.

Once code is merged into mainline it becomes a lot harder to justify
making changes that break backwards compatibility such as removing
system calls. It's easier in the long term to make sure your system
call interface is cleaned up now rather than later.

Have you come across Arnd Bergmann's work on creating a generic arch
for porting?

http://lwn.net/Articles/307713/

It's a good reference to check which system calls are considered
current and which headers are generic in new ports etc.

>> - does your port support SMP?
>
> No, but we consider todo it next step.
>
> We have updated the patch use the same URL(link)
> http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch
> if other person think it should be splited into smaller pieces,
> please let me know.
>
> Thanks Will Newton
> --
> liqin
>
> Will Newton <will.newton@gmail.com> Ð´ÓÚ 2009-03-24 19:00:05:
>
>> On Tue, Mar 24, 2009 at 3:46 AM,  <liqin@sunnorth.com.cn> wrote:
>> > Hello, Linus and folks,
>> >
>> > We have ported Linux to the S+CORE processor, which is a 32-bit RISC
>> > embedded
>> > microprocessor of Sunplus Core Technology.
>> >
>> > SPG29X, SPG300(score core) processor have been used in game products.
>> > and score toolchain have commit to gnu in 2006. We have a team to
> maintain
>> > score code for linux kernel.
>> >
>> > We would like to release a patch for kernel 2.6.29-rc8.
>> > This patch include score header files, arch files and serial driver
> for
>> > spct6600(score core) platform.
>> >
>> > For the other driver patches, I'll send them one by one in
>> > small size latter. Thanks!
>> >
>> > Would you merge them to the stock kernel?
>> >
>> > Patch information is slightly bigger, so I placed it on our SunplusCT
> web
>> > site.
>> >
> http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch
>> >
>> > Signed off by: Chen Liqin <liqin.chen@sunplusct.com,
>> > liqin@sunnorth.com.cn>
>
