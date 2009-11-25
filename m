Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbZKYM1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbZKYM1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758698AbZKYM1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:27:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40854 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZKYM1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=RoeLgQ6giEOX/iNr9rHorHtCKN934aTfUF9IMAHKaI40Cu6bf5lkxwZH6xNINOGRGl
         wWY+YzlTXpE0NmyhuULq9PlbHYazleM3xaTZ/v1SnYnZn3zIXIfsboRipp0jCHsg1HAC
         RZV//6/tsl1c9OSIDRDo2Rwpbktv7ky3Ubmac=
MIME-Version: 1.0
In-Reply-To: <5dcc4c8a0911241202s1d56354el9628763b05451fb9@mail.gmail.com>
References: <5dcc4c8a0911241202s1d56354el9628763b05451fb9@mail.gmail.com>
Date: Wed, 25 Nov 2009 15:27:28 +0300
Message-ID: <5dcc4c8a0911250427g73f7a3a0y26eff2379fb86edf@mail.gmail.com>
Subject: Kernel module, undefined symbol show_regs
From: Tanya Gornak <errizo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. I can't solve problem that happens while I'm making my kernel module.

part of my module:
// ...
#include <linux/sched.h>
//....
static u32 task_syscall_entry(enum utrace_resume_action action,
                                struct utrace_engine *engine,
                                struct task_struct *task,
                                struct pt_regs *regs){
    // ...
        show_regs(regs);

}
But, while making I get:

WARNING: "show_regs" [/home/tehhi/module/trace.ko] undefined!

extern void show_regs(struct pt_regs *);  define in header
linux/sched.h, place of source code is
linux/arch/x86/kernel/process_32.c
It use extern void __show_regs(struct pt_regs *); and extern
asmlinkage void __backtrace(void);
I think that extern means that I can use it (and there are no static
symbols in this function).

When trying to insert module, it predictably complains of an unknown
symbol show_regs.

What am I missing here?

Thanks in advance.
