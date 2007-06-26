Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbXFZF6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbXFZF6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXFZF57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:57:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:43043 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbXFZF56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:57:58 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc4-mm1 -- x86_64 ACPI panic
Date: Tue, 26 Jun 2007 02:00:32 -0400
User-Agent: KMail/1.9.5
Cc: "Luming Yu" <luming.yu@gmail.com>, "Andy Whitcroft" <apw@shadowen.org>,
       linux-kernel@vger.kernel.org, "Yu, Luming" <luming.yu@intel.com>,
       "Alexey Starikovskiy" <alexey.y.starikovskiy@intel.com>,
       linux-acpi@vger.kernel.org
References: <20070606020737.4663d686.akpm@linux-foundation.org> <3877989d0706080215x22f35292g8cb999f8720cd87c@mail.gmail.com> <20070608111215.5c492330.akpm@linux-foundation.org>
In-Reply-To: <20070608111215.5c492330.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706260200.32665.lenb@kernel.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.
thanks,
-Len

On Friday 08 June 2007 14:12, Andrew Morton wrote:
> On Fri, 8 Jun 2007 17:15:45 +0800
> "Luming Yu" <luming.yu@gmail.com> wrote:
> 
> > The only problem known as to the acpi throttling changes in the mm tree
> > is a typo ,and the patch to fix it is available here.  Please test and
> > get results back to me. BTW,the log shows that the acpi-cpufreq.ko has
> > problem. Would please also try not to load acpi-cpufreq.
> > 
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0706.0/2509.html
> 
> Sigh.  Is this some sort of contest to see how many things we can
> do wrong in a single patch?
> 
> - Include a changelog
> 
> - Include Signed-off-by:
> 
> - Don't use attachments
> 
> - If you _must_ use attachments, use text/plain, not application/octet-stream
> 
> - Format code to remain within 80 columns.
> 
> - Don't do "if(".  Do "if ("
> 
> Oh well.  Good to hear that the oops got fixed, thanks.
> 
> 
> From: "Luming Yu" <luming.yu@gmail.com>
> 
> Cc: Len Brown <lenb@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/acpi/processor_throttling.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/acpi/processor_throttling.c~acpi-fix-oops-in-acpi_processor_throttling_seq_show drivers/acpi/processor_throttling.c
> --- a/drivers/acpi/processor_throttling.c~acpi-fix-oops-in-acpi_processor_throttling_seq_show
> +++ a/drivers/acpi/processor_throttling.c
> @@ -656,18 +656,20 @@ static int acpi_processor_throttling_seq
>  		   pr->throttling.state_count - 1);
>  
>  	seq_puts(seq, "states:\n");
> -	if (acpi_processor_get_throttling == acpi_processor_get_throttling_fadt)
> +	if (pr->throttling.acpi_processor_get_throttling ==
> +			acpi_processor_get_throttling_fadt) {
>  		for (i = 0; i < pr->throttling.state_count; i++)
>  			seq_printf(seq, "   %cT%d:                  %02d%%\n",
>  				   (i == pr->throttling.state ? '*' : ' '), i,
>  				   (pr->throttling.states[i].performance ? pr->
>  				    throttling.states[i].performance / 10 : 0));
> -	else
> +	} else {
>  		for (i = 0; i < pr->throttling.state_count; i++)
>  			seq_printf(seq, "   %cT%d:                  %02d%%\n",
>  				   (i == pr->throttling.state ? '*' : ' '), i,
>  				   (int)pr->throttling.states_tss[i].
>  				   freqpercentage);
> +	}
>  
>        end:
>  	return 0;
> _
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
