Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZLEQbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZLEQbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 11:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757116AbZLEQbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 11:31:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZLEQbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 11:31:31 -0500
Date: Sat, 5 Dec 2009 17:25:11 +0100
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
Subject: Re: [PATCH v2 1/4] copy_signal cleanup: use zalloc and remove
	initializations
Message-ID: <20091205162511.GA23152@redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com> <20091204142814.GH10052@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204142814.GH10052@darkmag.usersys.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04, Veaceslav Falico wrote:
>
> Use kmem_cache_zalloc() on signal creation and remove unneeded initialization
> lines in copy_signal().
>
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
> ---
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 166b8c4..160477d 100644
> @@ -855,7 +844,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  	if (clone_flags & CLONE_THREAD)
>  		return 0;
>
> -	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
> +	sig = kmem_cache_zalloc(signal_cachep, GFP_KERNEL);
> ...

I think this is nice cleanup,

Acked-by: Oleg Nesterov <oleg@redhat.com>

