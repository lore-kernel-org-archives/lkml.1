Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbZCWQoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbZCWQoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760000AbZCWQoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:44:12 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41541 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759841AbZCWQoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o+G1Wcb4BaGa7Kf8hPqZ6NFc7oCUmyEA8QntE5YkeTgIaOh4rzJMUlwTPE9sgEG6/+
         51+Ih7MfeJnc9d31UAmjpTkheNf62EkETI5o2ztcf/cvQKvgGDLn1thLdzRftCXNfxe3
         ypvD83vR6EVGRQpdyuMC4ppiVKtGdDTzAwFLU=
Date: Mon, 23 Mar 2009 19:51:26 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 07/12] DRBD: main
Message-ID: <20090323165126.GA2649@x200.localdomain>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-2-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-3-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-4-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-5-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-6-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-7-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-8-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237823287-12734-8-git-send-email-philipp.reisner@linbit.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 04:48:02PM +0100, Philipp Reisner wrote:
> +#if CONFIG_PROC_FS
> +	/*
> +	 * register with procfs
> +	 */
> +	drbd_proc = create_proc_entry("drbd",  S_IFREG | S_IRUGO , NULL);
> +
> +	if (!drbd_proc)	{
> +		printk(KERN_ERR "drbd: unable to register proc file\n");
> +		goto Enomem;
> +	}
> +
> +	drbd_proc->proc_fops = &drbd_proc_fops;

Use proc_create().

> +	drbd_proc->owner = THIS_MODULE;

Unnecessary now.

> +#else
> +# error "Currently drbd depends on the proc file system (CONFIG_PROC_FS)"
> +#endif

You should "depends on PROC_FS" then and remove this #error.
#ifdef would also become unnecessary.
