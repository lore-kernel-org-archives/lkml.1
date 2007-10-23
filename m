Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbXJWFga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbXJWFga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXJWFgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:36:23 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:47378 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbXJWFgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tODaN6g08C+ItvdPnWiqYZ7UU+3ffKoqJRk7afGyyTr6bltcTxjWvxSIv7wkBFPeP3ceHs81/I8SUf0PFMuu2DdkL6nX27SAPX0tulFnk9OHva5/6v/1E4+tmYhJj5GYuTFZC0/wXDS3a/T3JuGMB92GNF2L6GMuMWdJcyA0Cog=
Message-ID: <86802c440710222236j481d09a7odfa3ce279644f5bd@mail.gmail.com>
Date: Mon, 22 Oct 2007 22:36:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "travis@sgi.com" <travis@sgi.com>
Subject: Re: [PATCH 1/1] x86: convert-cpuinfo_x86-array-to-a-per_cpu-array fix
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Suresh B Siddha" <suresh.b.siddha@intel.com>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20071012225434.102879000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071012225433.928899000@sgi.com>
	 <20071012225434.102879000@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/07, travis@sgi.com <travis@sgi.com> wrote:
> This fix corrects the problem that early_identify_cpu() sets
> cpu_index to '0' (needed when called by setup_arch) after
> smp_store_cpu_info() had set it to the correct value.
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  arch/x86_64/kernel/smpboot.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux.orig/arch/x86_64/kernel/smpboot.c     2007-10-12 14:28:45.000000000 -0700
> +++ linux/arch/x86_64/kernel/smpboot.c  2007-10-12 14:53:42.753508152 -0700
> @@ -141,8 +141,8 @@ static void __cpuinit smp_store_cpu_info
>         struct cpuinfo_x86 *c = &cpu_data(id);
>
>         *c = boot_cpu_data;
> -       c->cpu_index = id;
>         identify_cpu(c);
> +       c->cpu_index = id;
>         print_cpu_info(c);
>  }
>

why not removing assignment in early_identify_cpu?

YH
