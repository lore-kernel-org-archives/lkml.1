Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbYDVD1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbYDVD1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 23:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbYDVD1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 23:27:06 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:30900 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbYDVD1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 23:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=O7xk//PshJURehRID17w/Ri++RXn1rX6RG/4+oJBOyXiqZiPlRXX6KX6DZlJ6lPQoKMhSh9Nua0UYQHxKwaL6w0V2lk4mVzDt989g0erU1B26Jqx9fEkNzSaNTKcNDp8wWL/4w6tTnymdT4jX0AFbAGM/UICpDFS/fFSWSgs4uQ=
Message-ID: <386072610804212027i58895642n5320b96376c2732@mail.gmail.com>
Date: Tue, 22 Apr 2008 11:27:00 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH 03/15] [BLACKFIN] minor irq handler cleanups
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <0fc974582553292880b65973b4095297056eec03.1208559659.git.jgarzik@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
	 <0fc974582553292880b65973b4095297056eec03.1208559659.git.jgarzik@redhat.com>
X-Google-Sender-Auth: 9672e756a0db0c00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 7:22 AM, Jeff Garzik <jeff@garzik.org> wrote:
> - time_sched_init() should use standard irq_handler_t
>
>  - sys_timer0_int_handler() should not take 'regs' third argument
>
>  - remove pointless cast from void*
>
>  This change's main purpose is to prepare for the patchset in
>  jgarzik/misc-2.6.git#irq-remove, that explores removal of the
>  never-used 'irq' argument in each interrupt handler.
>
>  Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>  ---
>   arch/blackfin/kernel/time.c        |    5 ++---
>   arch/blackfin/oprofile/timer_int.c |    5 ++---
>   2 files changed, 4 insertions(+), 6 deletions(-)
>
>  diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
>  index 9bdc8f9..715b394 100644
>  --- a/arch/blackfin/kernel/time.c
>  +++ b/arch/blackfin/kernel/time.c
>  @@ -39,8 +39,7 @@
>   /* This is an NTP setting */
>   #define        TICK_SIZE (tick_nsec / 1000)
>
>  -static void time_sched_init(irqreturn_t(*timer_routine)
>  -                       (int, void *));
>  +static void time_sched_init(irq_handler_t timer_routine);
>   static unsigned long gettimeoffset(void);
>
>   static struct irqaction bfin_timer_irq = {
>  @@ -64,7 +63,7 @@ static struct irqaction bfin_timer_irq = {
>   #define TIME_SCALE 1
>
>   static void
>  -time_sched_init(irqreturn_t(*timer_routine) (int, void *))
>  +time_sched_init(irq_handler_t timer_routine)
>   {
>         u32 tcount;
>
>  diff --git a/arch/blackfin/oprofile/timer_int.c b/arch/blackfin/oprofile/timer_int.c
>  index 6c6f860..e2c825a 100644
>  --- a/arch/blackfin/oprofile/timer_int.c
>  +++ b/arch/blackfin/oprofile/timer_int.c
>  @@ -40,10 +40,9 @@ static void disable_sys_timer0()
>   {
>   }
>
>  -static irqreturn_t sys_timer0_int_handler(int irq, void *dev_id,
>  -                                         struct pt_regs *regs)
>  +static irqreturn_t sys_timer0_int_handler(int irq, void *dev_id)
>   {
>  -       oprofile_add_sample(regs, 0);
>  +       oprofile_add_sample(get_irq_regs(), 0);
>         return IRQ_HANDLED;
>   }
>

Sorry for the delay, it is pretty good for Blackfin.

Acked-by: Bryan Wu <cooloney@kernel.org>

-Bryan
