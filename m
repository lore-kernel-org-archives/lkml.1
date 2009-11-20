Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbZKTH4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbZKTH4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZKTH4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:56:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:2717 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZKTH4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:56:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ewSO2rfh9UE837dAzM8g6EwjSL/nHnRh3F6Dj5FUiBxYAicZGfoPcK27Xnd+YJTAPz
         aOZpbes9Eq+/gQ5OAd05aonXbAWnkhLZwIH/F5t6FJIe65hawiaRK6PvsVzqQYTj91o2
         cejwvs3Cc69WjlAJN8Si4ukuhshYiz20t8LFc=
MIME-Version: 1.0
In-Reply-To: <20090927115833.GA10316@merkur.ravnborg.org>
References: <1253119466-19488-1-git-send-email-tabbott@ksplice.com>
	 <1253119466-19488-2-git-send-email-tabbott@ksplice.com>
	 <10f740e80909270255y18c2840bh14c6a4ddfdb0a916@mail.gmail.com>
	 <20090927115833.GA10316@merkur.ravnborg.org>
Date: Fri, 20 Nov 2009 08:56:27 +0100
X-Google-Sender-Auth: 115408b94a154e62
Message-ID: <10f740e80911192356i5f256751yf5a5c7f80081011c@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] m68k: Make thread_info.h usable from assembly.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@ksplice.com>, Roman Zippel <zippel@linux-m68k.org>,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 12:58, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sun, Sep 27, 2009 at 11:55:55AM +0200, Geert Uytterhoeven wrote:
>> On Wed, Sep 16, 2009 at 18:44, Tim Abbott <tabbott@ksplice.com> wrote:
>> > Signed-off-by: Tim Abbott <tabbott@ksplice.com>
>> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>> > Cc: Roman Zippel <zippel@linux-m68k.org>
>> > Cc: linux-m68k@lists.linux-m68k.org
>> > Cc: Sam Ravnborg <sam@ravnborg.org>
>> > ---
>> >  arch/m68k/include/asm/thread_info_mm.h |    2 ++
>> >  1 files changed, 2 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/arch/m68k/include/asm/thread_info_mm.h b/arch/m68k/include/asm/thread_info_mm.h
>> > index b6da388..5f36cf1 100644
>> > --- a/arch/m68k/include/asm/thread_info_mm.h
>> > +++ b/arch/m68k/include/asm/thread_info_mm.h
>> > @@ -8,6 +8,7 @@
>> >  #include <asm/types.h>
>> >  #include <asm/page.h>
>> >
>> > +#ifndef __ASSEMBLY__
>> >  struct thread_info {
>> >        struct task_struct      *task;          /* main task structure */
>> >        unsigned long           flags;
>> > @@ -16,6 +17,7 @@ struct thread_info {
>> >        __u32 cpu; /* should always be 0 on m68k */
>> >        struct restart_block    restart_block;
>> >  };
>> > +#endif /* __ASSEMBLY__ */
>> >
>> >  #define PREEMPT_ACTIVE         0x4000000
>>
>> This is not sufficient. <asm/thread_info_mm.h> pulls in <asm/current.h>,
>> which contains C only. So you also need:
>>
>> --- a/arch/m68k/include/asm/thread_info_mm.h
>> +++ b/arch/m68k/include/asm/thread_info_mm.h
>> @@ -4,11 +4,12 @@
>>  #ifndef ASM_OFFSETS_C
>>  #include <asm/asm-offsets.h>
>>  #endif
>> -#include <asm/current.h>
>>  #include <asm/types.h>
>>  #include <asm/page.h>
>>
>>  #ifndef __ASSEMBLY__
>> +#include <asm/current.h>
>> +
>>  struct thread_info {
>>       struct task_struct      *task;          /* main task structure */
>>       unsigned long           flags;
>
>
> upstream m68k does not build for me so I could not test.
> But I think the correct fix is to drop the include or current from thread_info.
> No-one except m68k needs to include current.h in thread_info.h.

Dropping it causes lots of undeclared errors, so I'm gonna apply Tim's
patch with my additional fix.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
