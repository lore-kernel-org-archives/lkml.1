Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbYIQSUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbYIQSUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbYIQSUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:20:13 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:31326 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbYIQSUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:20:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GUEN++CPe9J2V9TfZGMAcK3w2PoaUSw6J27h6qs91mWTm6iy9FEN1gSnRTcXmW0/jv
         uGIWNzTTaJHcTaVpR3nXQyr0k2a4iNjGD63O0L6n0S9TiVODX1S6iqHeUkIZgz6Bm0c3
         ONmkVpTtu1xRAY8uADTEGhmUiZBvoQmK4CVoQ=
Date: Wed, 17 Sep 2008 20:19:17 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] apci: dump slit with printk(KERN_ACPI...)
Message-ID: <20080917181856.GA5524@joi>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <1221640067-24389-6-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221640067-24389-6-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 01:27:46AM -0700, Yinghai Lu wrote:
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  drivers/acpi/numa.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux-2.6/drivers/acpi/numa.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/numa.c
> +++ linux-2.6/drivers/acpi/numa.c
> @@ -150,6 +150,15 @@ static __init int slit_valid(struct acpi
>  {
>  	int i, j;
>  	int d = slit->locality_count;
> +	printk(KERN_DEBUG KERN_ACPI "ACPI: SLIT: nodes = %d\n", d);
> +	for (i = 0; i < d; i++) {
> +		printk(KERN_DEBUG KERN_ACPI "  ");
> +		for (j = 0; j < d; j++)  {
> +			u8 val = slit->entry[d*i + j];
> +			printk(KERN_CONT KERN_ACPI " %d", val);
> +		}
> +		printk(KERN_CONT KERN_ACPI "\n");
> +	}

It will produce something like this:
<7><acpi>ACPI: SLIT: nodes = %d\n
<7><acpi>  <acpi> %d<acpi> %d<acpi> %d<acpi> %d<acpi>\n

bit wrong... ;)

Marcin
