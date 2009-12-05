Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbZLEQje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbZLEQje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 11:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZLEQjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 11:39:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757116AbZLEQjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 11:39:32 -0500
Date: Sat, 5 Dec 2009 17:33:14 +0100
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
Subject: Re: [PATCH v2 2/4] copy_signal cleanup: clean acct_init_pacct()
	and taskstats_tgid_init()
Message-ID: <20091205163314.GB23152@redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com> <20091204142901.GI10052@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204142901.GI10052@darkmag.usersys.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04, Veaceslav Falico wrote:
>
> Remove unneeded initializations in acct_init_pacct() and taskstats_tgid_init().
> These are accessed only via copy_signal() and are useless after using
> kmem_cache_zalloc() in copy_signal().
>
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
> ---
>
> diff --git a/include/linux/taskstats_kern.h b/include/linux/taskstats_kern.h
> index 3398f45..d66167a 100644
> --- a/include/linux/taskstats_kern.h
> +++ b/include/linux/taskstats_kern.h
> @@ -16,7 +16,6 @@ extern struct mutex taskstats_exit_mutex;
>
>  static inline void taskstats_tgid_init(struct signal_struct *sig)
>  {
> -	sig->stats = NULL;
>  }
>
>  static inline void taskstats_tgid_free(struct signal_struct *sig)
> diff --git a/kernel/acct.c b/kernel/acct.c
> index 9a4715a..8909c26 100644
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -592,8 +592,6 @@ out:
>   */
>  void acct_init_pacct(struct pacct_struct *pacct)
>  {
> -	memset(pacct, 0, sizeof(struct pacct_struct));
> -	pacct->ac_utime = pacct->ac_stime = cputime_zero;
>  }

Looks good to me, but I'd suggest you to send the next patch (on top
of this) which kills both these helpers. Otherwise we have empty
definitions with and without CONFIG_TASKSTATS, a bit strange.

Oleg.

