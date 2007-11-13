Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbXKMAty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbXKMAty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXKMAtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:49:46 -0500
Received: from gw.goop.org ([64.81.55.164]:42414 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbXKMAtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:49:46 -0500
Message-ID: <4738F442.3040905@goop.org>
Date: Mon, 12 Nov 2007 16:48:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mm_release() call in exit_mm() looks dangerous
References: <9a8748490711111540q10503eday7f06b3e72b20fe82@mail.gmail.com>
In-Reply-To: <9a8748490711111540q10503eday7f06b3e72b20fe82@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> In kernel/exit.c we have this code :
>
> static void exit_mm(struct task_struct * tsk)
> {
>         struct mm_struct *mm = tsk->mm;
>
>         mm_release(tsk, mm);
>         if (!mm)
>                 return;
> ...
>
>
> But, mm_release() may dereference it's second argument ('mm'), so
> shouldn't we be doing the "!mm" test *before* we call mm_release() and
> not after?
> I don't know the mm code well enough to be able to tell if some of the
> other stuff mm_release does needs to be done always and the mm
> dereference can't actually happen, but maybe someone else who knows
> the code better can tell...  In any case, what's currently there looks
> a little shaky..
>   

Yeah, it looks wrong.  mm_release() calls deactivate_mm() as its first
act, which could well dereference mm (though it often doesn't).

    J
