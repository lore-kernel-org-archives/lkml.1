Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbZJLBiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbZJLBiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 21:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZJLBiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 21:38:23 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:46302 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbZJLBiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 21:38:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SHtJZgU571gtAgX3vgfVOPXrMzYY4AyhUntvJitPFwJtBekIjgdT9SQ8gok9s/y6u/
         LLoKThuSOpvkz/A1/MgLaMHLU9PQSy/DVSNlf7s601tgh2TGug7eGZ7KDZfDLSRR6OMk
         tVgfEDfX00EfFXupA8Sfop8pLKuh4G1YFFeAs=
MIME-Version: 1.0
In-Reply-To: <200910120026.n9C0QdSe019248@clem.clem-digital.net>
References: <200910120026.n9C0QdSe019248@clem.clem-digital.net>
Date: Mon, 12 Oct 2009 09:37:47 +0800
Message-ID: <7b6bb4a50910111837t7120e914p4d0796a826db7ba1@mail.gmail.com>
Subject: Re: 2.6.32-rc4 fail compile -- drivers/char/rtc.c
From: Xiaotian Feng <xtfeng@gmail.com>
To: Pete Clements <clem@clem.clem-digital.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may be caused by commit d43c36dc6b357fa1806800f18aa30123c747a6d1.
Can insert #include <linux/sched.h> into drivers/char/rtc.c fix this?

On Mon, Oct 12, 2009 at 8:26 AM, Pete Clements
<clem@clem.clem-digital.net> wrote:
> Fyi:
> (i386 SMP)
>
>
>  CC      drivers/char/rtc.o
> drivers/char/rtc.c: In function 'rtc_interrupt':
> drivers/char/rtc.c:271: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> drivers/char/rtc.c:271: error: (Each undeclared identifier is reported only once
> drivers/char/rtc.c:271: error: for each function it appears in.)
> drivers/char/rtc.c:273: error: 'SIGIO' undeclared (first use in this function)
> drivers/char/rtc.c:273: error: 'POLL_IN' undeclared (first use in this function)
> drivers/char/rtc.c: In function 'rtc_read':
> drivers/char/rtc.c:362: error: implicit declaration of function '__set_current_state'
> drivers/char/rtc.c:362: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> drivers/char/rtc.c:376: error: implicit declaration of function 'signal_pending'
> drivers/char/rtc.c:380: error: implicit declaration of function 'schedule'
> drivers/char/rtc.c:393: error: 'TASK_RUNNING' undeclared (first use in this function)
> drivers/char/rtc.c: In function 'rtc_dropped_irq':
> drivers/char/rtc.c:1206: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> drivers/char/rtc.c:1208: error: 'SIGIO' undeclared (first use in this function)
> drivers/char/rtc.c:1208: error: 'POLL_IN' undeclared (first use in this function)
> make[2]: *** [drivers/char/rtc.o] Error 1
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2
>
> --
> Pete Clements
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
