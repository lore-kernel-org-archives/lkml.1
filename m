Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbXL3RvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbXL3RvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXL3RvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:51:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:50322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbXL3RvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:51:07 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Sun, 30 Dec 2007 18:50:45 +0100
References: <9FXbU-3M4-11@gated-at.bofh.it> <9G2Om-4hg-1@gated-at.bofh.it> <9G7O3-3O2-7@gated-at.bofh.it> <9G8qN-4TX-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1J92JB-00013N-P3@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+/xhnzIOEIl9cRjkP+5JZDcPf/G/TeNhGeEBu
 9VL2wC488y6LiPqmb9riJmAS7/ma7z0a53C4QUZvMrR+4aBxlA
 dcPfVTfMkUFG8SkZDUK7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> do you have any memories about the outb_p() use of misc_32.c:
> 
>         pos = (x + cols * y) * 2;       /* Update cursor position */
>         outb_p(14, vidport);
>         outb_p(0xff & (pos >> 9), vidport+1);
>         outb_p(15, vidport);
>         outb_p(0xff & (pos >> 1), vidport+1);
> 
> was this ever needed? This is so early in the bootup that can we cannot
> do any sensible delay. Perhaps we could try a natural delay sequence via
> inb from 0x3cc:
> 
>         outb(14, vidport);
>          inb(0x3cc); /* delay */
>         outb(0xff & (pos >> 9), vidport+1);

I've never seen code which would do that, and it was not suggested by any
tutorial I ever saw. I'd expect any machine to break on all kinds of software
if it required this. The only thing I remember being warned about is writing
the index and the data register at the same time using outw, because that
would write both registers at the same time on 16-bit-cards.


BTW: The error function in linux-2.6.23/arch/i386/boot/compressed/misc.c
uses while(1) without cpu_relax() in order to halt the machine. Is this fixed?
Should it be fixed?

