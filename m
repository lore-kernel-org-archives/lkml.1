Return-Path: <linux-kernel-owner+w=401wt.eu-S932291AbXIAVd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbXIAVd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 17:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbXIAVdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 17:33:20 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:63599 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150AbXIAVdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 17:33:20 -0400
Date: Sat, 1 Sep 2007 14:33:01 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, Andi Kleen <ak@suse.de>, B.Steinbrink@gmx.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] i386: fix a hang on stuck nmi watchdog
Message-ID: <20070901213301.GB9778@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070901205417.305538884@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070901205417.305538884@mvista.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

Thanks for your help tracking down this bug. Maybe we can close
the bugzilla report now.

On Sat, Sep 01, 2007 at 01:54:17PM -0700, Daniel Walker wrote:
> In the case when an nmi gets stucks the endflag stays equal to zero. This
> causes the busy looping on other cpus to continue, even tho the nmi test
> is done.
> 
> On my machine with out the change below the system would hang right after
> check_nmi_watchdog(). The change below just sets endflag prior to checking
> if the test was successful or not.
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  arch/i386/kernel/nmi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.22/arch/i386/kernel/nmi.c
> ===================================================================
> --- linux-2.6.22.orig/arch/i386/kernel/nmi.c
> +++ linux-2.6.22/arch/i386/kernel/nmi.c
> @@ -115,12 +115,12 @@ static int __init check_nmi_watchdog(voi
>  			atomic_dec(&nmi_active);
>  		}
>  	}
> +	endflag = 1;
>  	if (!atomic_read(&nmi_active)) {
>  		kfree(prev_nmi_count);
>  		atomic_set(&nmi_active, -1);
>  		return -1;
>  	}
> -	endflag = 1;
>  	printk("OK.\n");
>  
>  	/* now that we know it works we can reduce NMI frequency to
> -- 
> 
> -- 

-- 

-Stephane
