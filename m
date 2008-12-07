Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYLGXCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYLGXCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 18:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYLGXCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 18:02:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:45031 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbYLGXC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 18:02:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:cc:content-disposition:from:date:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=djZQFk83Tj8dWEB3e83SI28/5wTcIYB/C5wS68ATaxeMQC6q5NCTvV4WLhG7trcjP5
         RR1Mwx7Hfx5GJVjMm76Fd1NumHx7ENSUWzndcx7c+fNaXhO277uC3+lu1hz3/7lzve6u
         DPeFM1vH6BKPL8TK35vic/iCF/UnaZyb6EDB0=
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [x86] do_arch_prctl
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Eric Lacombe <goretux@gmail.com>
Date: Mon, 8 Dec 2008 00:02:20 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200812080002.21192.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sorry to insist, but I really want to understand what occurs in this 
portion of kernel code. And that's why I resend my previous message with the 
hope that someone could enlighten my mind.

Thanks in advance,

	Eric

Le lundi 24 novembre 2008 19:22:18 Jeremy Fitzhardinge, vous avez écrit :
> Eric Lacombe wrote:
> > Hello,
> >
> > Does the "doit case" (line 822 in ARCH_GET_FS, function do_arch_prctl)
> > exist for performance reasons? Else, why "task->thread.fs" (line 824)
> > does not contain the fs base in the "doit case"?
>
> "doit" gets set when you're operating on yourself.  If you're operating
> on another process, then you need to use their task structure values
> rather than the current process's values.  If you're doing it to
> yourself, then the task structure may be out of date because its only
> updated on a context switch.

The task_struct is also updated in sys_arch_prctl (ARCH_SET_FS and 
ARCH_SET_GS), so not just on a context switch.
How the task structure could be out of date wrt thread.gs and thread.fs?
What could be a typical scenario that could induced gs or fs to be modified and 
not thread.gs and thread.fs?

Why we have a difference between ARCH_GET_GS :

> 833                 else if (doit) {
> 834                         asm("movl %%gs,%0" : "=r" (gsindex));
> 835                         if (gsindex)
> 836                                 rdmsrl(MSR_KERNEL_GS_BASE, base);
> 837                         else
> 838                                 base = task->thread.gs;
> 839                 }

and ARCH_GET_FS :

> 821                 else if (doit)
> 822                         rdmsrl(MSR_FS_BASE, base);

If I follow what you say, why can't we have the same optimization in 
ARCH_GET_FS?

thanks,

	Eric



