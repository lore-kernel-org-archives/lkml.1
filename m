Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXJEFmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXJEFmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXJEFmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:42:05 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37204 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXJEFmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:42:03 -0400
Date: Fri, 5 Oct 2007 11:12:05 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>, Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 1/2] add tunable_notifier function
Message-ID: <20071005054205.GB4893@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <4704D0BA.4090507@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4704D0BA.4090507@ah.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 08:38:34PM +0900, Takenori Nagano wrote:
> This patch adds new notifier function tunable_notifier_chain. Its base is
> atomic_notifier_chain.
> 
> Thanks,
> 
> ---
> 
> Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>
> 
> ---
> diff -uprN linux-2.6.23-rc9.orig/include/linux/notifier.h
> linux-2.6.23-rc9/include/linux/notifier.h
> --- linux-2.6.23-rc9.orig/include/linux/notifier.h	2007-10-02 12:24:52.000000000
> +0900
> +++ linux-2.6.23-rc9/include/linux/notifier.h	2007-10-03 14:48:04.288000000 +0900
> @@ -13,6 +13,7 @@
>  #include <linux/mutex.h>
>  #include <linux/rwsem.h>
>  #include <linux/srcu.h>
> +#include <linux/kobject.h>
> 
>  /*
>   * Notifier chains are of four types:
> @@ -53,6 +54,14 @@ struct notifier_block {
>  	int priority;
>  };
> 
> +struct tunable_notifier_block {
> +	struct notifier_block *nb;
> +	struct tunable_notifier_head *head;
> +	struct dentry *dir;
> +	struct dentry *pri_dentry;
> +	struct dentry *desc_dentry;
> +};
> +

Should this be tunable_atomic_notifier_block? I think there are two kind
of lists. One where handlers have to be atomic and other one where handlers
can be blocking one. I think you are making atomic one tunable. If that's
the case it should be reflected in the naming everywhere.

Thanks
Vivek
