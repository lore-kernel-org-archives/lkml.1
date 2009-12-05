Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbZLEREF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbZLEREF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 12:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbZLEREE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 12:04:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339AbZLERED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 12:04:03 -0500
Date: Sat, 5 Dec 2009 17:58:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Al Viro <viro@zeniv.linux.org.uk>, Miloslav Trmac <mitr@redhat.com>,
       James Morris <jmorris@namei.org>, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v2 4/4] copy_signal cleanup: clean tty_audit_fork()
Message-ID: <20091205165804.GD23152@redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com> <20091204143037.GK10052@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204143037.GK10052@darkmag.usersys.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04, Veaceslav Falico wrote:
>
> Remove unneeded initialization in tty_audit_fork().
> It is called only via copy_signal() and is useless after
> the kmem_cache_zalloc() was used.
>
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
> ---
>
> diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
> index ac16fbe..283a15b 100644
> --- a/drivers/char/tty_audit.c
> +++ b/drivers/char/tty_audit.c
> @@ -148,7 +148,6 @@ void tty_audit_fork(struct signal_struct *sig)
>  	spin_lock_irq(&current->sighand->siglock);
>  	sig->audit_tty = current->signal->audit_tty;
>  	spin_unlock_irq(&current->sighand->siglock);
> -	sig->tty_audit_buf = NULL;
>  }

Can't comment the changes in audit code, but the patch looks obviously
correct.



Off-topic question to this who understands this code.

But afaics we can also remove ->siglock from this helper and make
it really trivial for being inline. ->siglock buys nothing, we just
read a boolean. In fact, after the quick grep I do not understand
how ->siglock is connected to ->audit_tty. OK, it protects tty_audit_buf,
but why we always take ->siglock to access ->audit_tty ?

Oleg.

