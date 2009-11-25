Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbZKYRpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbZKYRpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbZKYRo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:44:59 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37168 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478AbZKYRo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:44:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q8tnMUJ/5Ut6tAgm3yw50aYUSng6xurvZgJLZYVMDk1n6UM41TJoTprbZbXS0BFPBf
         Btu8uTWrh6qeZY00SKtU9o5L9gOgbYgJUE7exFcAs2u/fy1juLG2YI+XmV6pbnWtEAnz
         qouCRbWPtgv61RXiWUv6W3wAxmi6t/tg4NEBw=
MIME-Version: 1.0
In-Reply-To: <5dcc4c8a0911250427g73f7a3a0y26eff2379fb86edf@mail.gmail.com>
References: <5dcc4c8a0911241202s1d56354el9628763b05451fb9@mail.gmail.com>
	 <5dcc4c8a0911250427g73f7a3a0y26eff2379fb86edf@mail.gmail.com>
Date: Wed, 25 Nov 2009 18:45:02 +0100
Message-ID: <9ea470500911250945x72052c22hb0ccebf2fe96798a@mail.gmail.com>
Subject: Re: Kernel module, undefined symbol show_regs
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tanya Gornak <errizo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 1:27 PM, Tanya Gornak <errizo@gmail.com> wrote:
> Hello. I can't solve problem that happens while I'm making my kernel module.
>
> part of my module:
> // ...
> #include <linux/sched.h>
> //....
> static u32 task_syscall_entry(enum utrace_resume_action action,
>                                 struct utrace_engine *engine,
>                                 struct task_struct *task,
>                                 struct pt_regs *regs){
>     // ...
>         show_regs(regs);
>
> }
> But, while making I get:
>
> WARNING: "show_regs" [/home/tehhi/module/trace.ko] undefined!
>
> extern void show_regs(struct pt_regs *);  define in header
> linux/sched.h, place of source code is
> linux/arch/x86/kernel/process_32.c
> It use extern void __show_regs(struct pt_regs *); and extern
> asmlinkage void __backtrace(void);
> I think that extern means that I can use it (and there are no static
> symbols in this function).
>
> When trying to insert module, it predictably complains of an unknown
> symbol show_regs.
>
> What am I missing here?

You're using a function in a module which is not exported to modules.
See http://lwn.net/images/pdf/LDD3/ch02.pdf for more details.

-- 
Regards/Gruss,
Boris
