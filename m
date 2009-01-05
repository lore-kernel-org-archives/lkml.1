Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZAEXQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZAEXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbZAEXQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:16:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:40310 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZAEXQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:16:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pUbQxeG1aoVPhPH+slM5RoLB1dHR2Mve/Nkew+F0MUjN10F6MbZEecuc3I7zyazjiV
         REaHE6O7vypHJkYKSSpqvKAetEZmbAkny2dkZSMTSCUw6sp4VZyQ6kVMFtErc+7lAKd7
         y1qqXP3Cq59x+ZofczgNgYZeGJj+J2Wc5XdXE=
Date: Tue, 6 Jan 2009 02:21:19 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pmorreale@novell.com, riel@redhat.com
Subject: Re: + mm-add-proc-controls-for-pdflush-threads.patch added to -mm
	tree
Message-ID: <20090105232119.GA3860@x200.localdomain>
References: <200901052253.n05Mr3au014416@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901052253.n05Mr3au014416@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 02:53:03PM -0800, akpm@linux-foundation.org wrote:
> Subject: mm: add /proc controls for pdflush threads

> @@ -1022,6 +1023,28 @@ static struct ctl_table vm_table[] = {
>  		.proc_handler	= &proc_dointvec,
>  	},
>  	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "nr_pdflush_threads_min",
> +		.data		= &nr_pdflush_threads_min,
> +		.maxlen		= sizeof nr_pdflush_threads_min,
> +		.mode		= 0644 /* read-write */,
> +		.proc_handler	= &proc_dointvec_minmax,
> +		.strategy	= &sysctl_intvec,

.strategy isn't needed for /proc-only sysctls.

> +		.extra1		= &one,
> +		.extra2		= &nr_pdflush_threads_max,
> +	},
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "nr_pdflush_threads_max",
> +		.data		= &nr_pdflush_threads_max,
> +		.maxlen		= sizeof nr_pdflush_threads_max,
> +		.mode		= 0644 /* read-write */,
> +		.proc_handler	= &proc_dointvec_minmax,
> +		.strategy	= &sysctl_intvec,

.strategy isn't needed for /proc-only sysctls.
