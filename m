Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbXJXGri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbXJXGri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbXJXGr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:47:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:55398 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbXJXGr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pOqkAcxLUXu2lP1wmvYAim6dcoHuZolRvFppMyiZmcavmjHPmITIx/KoNu5olEMwevCYNcp3YEFZYlLkDDqdVZ3y4oAtBIZYkVUQZFPNJgNuW+9qb6u247hLJmit7sroVOd+tc8T4zmPUrefpqsWGKCQxEX+kBPyV6CYMqxzqQQ=
Message-ID: <471EEA7B.8070008@gmail.com>
Date: Wed, 24 Oct 2007 08:47:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [PATCH 4/12] riscom8: fix SMP brokenness
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223638.DD9FE1F81A8@havoc.gtf.org>
In-Reply-To: <20071023223638.DD9FE1F81A8@havoc.gtf.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2007 12:36 AM, Jeff Garzik wrote:
> After analyzing the elements that save_flags/cli/sti/restore_flags were
> protecting, convert their usages to a global spinlock (the easiest and
> most obvious next-step).  There were some usages of flags being
> intentionally cached, because the code already knew the state of
> interrupts.  These have been taken into account.
> 
> This allows us to remove CONFIG_BROKEN_ON_SMP.  Completely untested.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
> 
[...]
> diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
> index b37e626..45d109c 100644
> --- a/drivers/char/riscom8.c
> +++ b/drivers/char/riscom8.c
[...]
> @@ -82,6 +83,8 @@
>  static struct riscom_board * IRQ_to_board[16];
>  static struct tty_driver *riscom_driver;
>  
> +static spinlock_t riscom_lock = SPIN_LOCK_UNLOCKED;

This is deprecated (see linux/spinlock_types.h for details), use DEFINE_SPINLOCK
instead, otherwise seems OK.

Revieweved-by: Jiri Slaby <jirislaby@gmail.com>

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
