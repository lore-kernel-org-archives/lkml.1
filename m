Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268Ab0BZQPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:15:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965245Ab0BZQPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:15:23 -0500
Date: Fri, 26 Feb 2010 08:14:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to
 sleep  (w. timeout) until wake_up
Message-Id: <20100226081418.5902446f.akpm@linux-foundation.org>
In-Reply-To: <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
	<b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 11:38:59 +0100 Rafa Miecki <zajec5@gmail.com> wrote:

> +#define wait_interruptible_timeout(wq, timeout)
>     \
> +({                                   \
> +    long ret = timeout;                      \
> +                                    \
> +    DEFINE_WAIT(wait);                      \
> +    prepare_to_wait(&wq, &wait, TASK_INTERRUPTIBLE);       \
> +    if (!signal_pending(current))                  \
> +        ret = schedule_timeout(ret);            \
> +    finish_wait(&wq, &wait);                   \
> +                                    \
> +    ret;                             \
> +})

It's often a mistake to use signals in-kernel.  Signals are more a
userspace thing and it's better to use the lower-level kernel-specific
messaging tools in-kernel.  Bear in mind that userspace can
independently and asynchronously send, accept and block signals.

Can KMS use wait_event_interruptible_timeout()?
