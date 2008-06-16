Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYFPGuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYFPGuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYFPGuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:50:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:47146 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYFPGuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZK8cpKNWYleFx40bGqlC3xtdzb+3lvkVwgNI8ndINOyBgOIdBOBM7sb/rXSA3Od9eG
         OMZ4L2oL1ju8kqCYiR06nHf8t1TQ/QjskCFoeaQtGEmonnRJzRPmVAmhaNQOKJPhux1I
         ZTrq7vj7w/ebNnPn+TG2pnsq6yaS6CAM5nfp4=
Message-ID: <86802c440806152350m34f751a9qf29c98d09b7b9f7a@mail.gmail.com>
Date: Sun, 15 Jun 2008 23:50:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 1/8] x86 boot: x86_64 build reserve_bootmem_generic fix
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Jack Steiner" <steiner@sgi.com>, "Mike Travis" <travis@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 11:29 PM, Paul Jackson <pj@sgi.com> wrote:
> From: Paul Jackson <pj@sgi.com>
>
> Fix x86_64 build.  The addition of a third 'flags' argument
> to reserve_bootmem() and similar routines missed one instance.
>
> Signed-off-by: Paul Jackson <pj@sgi.com>
>
> ---
>  arch/x86/kernel/e820.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- linux.orig/arch/x86/kernel/e820.c   2008-06-10 21:31:21.000000000 -0700
> +++ linux/arch/x86/kernel/e820.c        2008-06-10 22:37:27.256448098 -0700
> @@ -636,7 +636,8 @@ void __init early_res_to_bootmem(u64 sta
>                printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
>                        final_start, final_end - 1, r->name);
>  #ifdef CONFIG_X86_64
> -               reserve_bootmem_generic(final_start, final_end - final_start);
> +               reserve_bootmem_generic(final_start, final_end - final_start,
> +                               BOOTMEM_DEFAULT);
>  #else
>                reserve_bootmem(final_start, final_end - final_start,
>                                BOOTMEM_DEFAULT);
>
> --

can you check latest tip/master?

YH
