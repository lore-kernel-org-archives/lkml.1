Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZBDQuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZBDQuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZBDQu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:50:28 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:37591 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZBDQu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:50:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iFQuWo68E9gc90NDzPWlp7xMwBYTGtJfxQeVCEz7pTDMdiV+gFXKAPeKZnPk9eKO5V
         mQ4rV5C4+84pdBH3u/aHQY+zSFTuqpZ1Tdo9ZlYiekrH9ie3PrrYwfwfuN6J2NfALbXY
         pceTaU/Mio/5B6QY8BA0ukTbiTs1Lbt8SsLAo=
MIME-Version: 1.0
In-Reply-To: <20090204153643.GA16681@oksana.dev.rtsoft.ru>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
	 <20090204150840.GC30027@oksana.dev.rtsoft.ru>
	 <c62985530902040726x34aeee7fr3b2937d898d3061e@mail.gmail.com>
	 <20090204153643.GA16681@oksana.dev.rtsoft.ru>
Date: Wed, 4 Feb 2009 17:50:24 +0100
Message-ID: <c62985530902040850u5f9e7ca2w6ffbf553ec15eec5@mail.gmail.com>
Subject: Re: [PATCH 3/3] tracing: Tracers that use CALLER_ADDR macros should 
	select FRAME_POINTER
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: avorontsov@ru.mvista.com, Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/4 Steven Rostedt <srostedt@redhat.com>:
>
> >From ftrace.h:
>
> #ifdef CONFIG_FRAME_POINTER
> /* TODO: need to fix this for ARM */
> # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> # define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
> # define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
> # define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
> # define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
> # define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
> # define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
> #else
> # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> # define CALLER_ADDR1 0UL
> # define CALLER_ADDR2 0UL
> # define CALLER_ADDR3 0UL
> # define CALLER_ADDR4 0UL
> # define CALLER_ADDR5 0UL
> # define CALLER_ADDR6 0UL
> #endif
>
> Yep!
>

Ok.

2009/2/4 Anton Vorontsov <avorontsov@ru.mvista.com>:
> It depends on the architecture. On PowerPC we always have frame pointers,
> thus __builtin_return_address(1..) will always work. On x86 it won't work
> that way.
>
> Thanks,
>
> --
> Anton Vorontsov

Thanks for your answers!
