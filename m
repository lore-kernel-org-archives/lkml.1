Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbZBJVtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbZBJVtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbZBJVs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:48:56 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:57455 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbZBJVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:48:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=odLPZeJw5lJwwBKN3ReXfpwmCaNzzuqkrF/3vGZYFdObAm4rlb8E17IcGe0f5Ori8d
         yzVyTqunTned7qCRyU6TFW/R60lm8pySz7aJHAVy/VJulQn1OJCMZFiH6ryoR8N2Cbl9
         XwSafNS8tLpTk1toALnxQlTflzcS0Eg9FJmgQ=
MIME-Version: 1.0
In-Reply-To: <20090210202405.GB1382@ucw.cz>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	 <20090204221451.GA27254@uranus.ravnborg.org>
	 <adavdrplty2.fsf@cisco.com> <20090210202405.GB1382@ucw.cz>
Date: Tue, 10 Feb 2009 22:48:52 +0100
Message-ID: <56e1b5710902101348h5ae7b98bk97a69b2718f22bb1@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
From: Floris Kraak <randakar@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 9:24 PM, Pavel Machek <pavel@suse.cz> wrote:
> On Wed 2009-02-04 14:26:45, Roland Dreier wrote:
>>  > Before judging on this patch could you please post what warning it
>>  > triggers and one or a few patches to fix some of them.
>>
>> The warnings are things like:
>>
>>     init/main.c: In function 'start_kernel':
>>     init/main.c:557: warning: format not a string literal and no format arguments
>>
>
> Would it be possible to declare linux_banner const or something?
>
>> diff --git a/init/main.c b/init/main.c
>> index 8442094..78fc0d8 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -554,7 +554,7 @@ asmlinkage void __init start_kernel(void)
>>       boot_cpu_init();
>>       page_address_init();
>>       printk(KERN_NOTICE);
>> -     printk(linux_banner);
>> +     printk("%s", linux_banner);
>
> Actually
>         printk(KERN_NOTICE "%s", linux_banner);
>
> is a better fix that will save some code, too.
>

Noted. Adding that to the patch tomorrow.

Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
