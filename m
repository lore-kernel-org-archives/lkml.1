Return-Path: <linux-kernel-owner+w=401wt.eu-S1762824AbXJDQRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762824AbXJDQRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759283AbXJDQRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:17:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41601 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760278AbXJDQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:17:33 -0400
Date: Thu, 4 Oct 2007 09:07:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 2/2] implement new notifier function to
 panic_notifier_list
Message-Id: <20071004090711.456b6338.randy.dunlap@oracle.com>
In-Reply-To: <4704D0CA.4080001@ah.jp.nec.com>
References: <4704D0CA.4080001@ah.jp.nec.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 20:38:50 +0900 Takenori Nagano wrote:

> This patch implements new notifier function to panic_notifier_list. We can
> change the list of order by debugfs.
> 
> Thanks,
> 
> ---
> 
> Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>
> 
> ---

...

> diff -uprN linux-2.6.23-rc9.orig/kernel/softlockup.c
> linux-2.6.23-rc9/kernel/softlockup.c
> --- linux-2.6.23-rc9.orig/kernel/softlockup.c	2007-10-02 12:24:52.000000000 +0900
> +++ linux-2.6.23-rc9/kernel/softlockup.c	2007-10-04 09:46:25.784000000 +0900
> @@ -31,10 +31,18 @@ softlock_panic(struct notifier_block *th
>  	return NOTIFY_DONE;
>  }
> 
> -static struct notifier_block panic_block = {
> +static struct notifier_block panic_block_base = {
>  	.notifier_call = softlock_panic,
>  };
> 
> +static struct tunable_notifier_block panic_block = {
> +	.nb		= &panic_block_base,
> +	.head		= NULL,
> +	.dir		= NULL,
> +	.pri_dentry	= NULL,
> +	.desc_dentry	= NULL
> +};
> +
>  /*
>   * Returns seconds, approximately.  We don't need nanosecond
>   * resolution, and we don't need to waste time with a big divide when
> @@ -193,5 +201,6 @@ __init void spawn_softlockup_task(void)
>  	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
>  	register_cpu_notifier(&cpu_nfb);
> 
> -	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
> +	tunable_notifier_chain_register(&panic_notifier_list, &panic_block,
> +						"softlookup", NULL);
>  }

                                                "softlockup"

---
~Randy
