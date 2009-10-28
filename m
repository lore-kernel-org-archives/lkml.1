Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZJ1RRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZJ1RRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZJ1RRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:17:24 -0400
Received: from web50110.mail.re2.yahoo.com ([206.190.38.38]:20471 "HELO
	web50110.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752331AbZJ1RRY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:17:24 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2009 13:17:24 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=luOJllGjDRJ35kimNaS5cpYbVksAUz3wCX1eV08RxDWzh6mvUeUToylTvDMcVck79RINTsAsXg2jQKSShR1dH/vmXab1m2rD8vzulSG9VP5n6H5YwvXVjHS8N8g4+hu9pvqix0pzXiQSJlOvELXT1g51wf0g0H0QJ0BiJZfUcSU=;
Message-ID: <829334.85094.qm@web50110.mail.re2.yahoo.com>
X-YMail-OSG: e8P3oPEVM1nT5bc4QP.eTyEueq3gvj5AfThNOozY1kat.TxsD6BJJrUazUBFNrvwUtm_DhImBW8ucM16AH9I1Pg65zrdfhqlV_nDFEX9d3gz64cIKz.G0dAmmQGlhHl36Ho._4A0gqvcuCxOtb3AVsEkpA3fFEfWHzkFIhq2W3m1P6EvJXXySb40JPVKyRr8FWX3uDwlAIZ2Iw8lClbtbfdJhDMsvVtVF.0EQtNMKUNdsggEnhSevdUqtNznXmoB.f9S5IPhm4dK7It477N5sGxbY8dUCR0leZx2_b6e6dRBTURHjhRUCR3ntxIP.C7H.VHUBM8BWZlOpmwYy4Vvzc1NPGXSYHTzYyFZszxI
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.7.361.4
Date: Wed, 28 Oct 2009 10:10:47 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] edac: i7core_edac produces undefined behaviour on 32bit
To: dougthompson@xmission.com, mchehab@redhat.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
In-Reply-To: <20091028105200.6097.58279.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 10/28/09, Alan Cox <alan@linux.intel.com> wrote:

> From: Alan Cox <alan@linux.intel.com>
> Subject: [PATCH] edac: i7core_edac produces undefined behaviour on 32bit
> To: dougthompson@xmission.com, mchehab@redhat.com, linux-kernel@vger.kernel.org
> Date: Wednesday, October 28, 2009, 4:52 AM
> Fix the shifts up
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Acked-by: Doug Thompson <dougthompson@xmission.com>


> ---
> 
>  drivers/edac/i7core_edac.c |   24
> ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/drivers/edac/i7core_edac.c
> b/drivers/edac/i7core_edac.c
> index b6fce2e..bd7c727 100644
> --- a/drivers/edac/i7core_edac.c
> +++ b/drivers/edac/i7core_edac.c
> @@ -916,41 +916,41 @@ static ssize_t
> i7core_inject_enable_store(struct mem_ctl_info *mci,
>  
>      /* Sets pvt->inject.dimm mask */
>      if (pvt->inject.dimm < 0)
> -        mask |= 1L <<
> 41;
> +        mask |= 1LL <<
> 41;
>      else {
>          if
> (pvt->channel[pvt->inject.channel].dimms > 2)
> -           
> mask |= (pvt->inject.dimm & 0x3L) << 35;
> +           
> mask |= (pvt->inject.dimm & 0x3LL) << 35;
>          else
> -           
> mask |= (pvt->inject.dimm & 0x1L) << 36;
> +           
> mask |= (pvt->inject.dimm & 0x1LL) << 36;
>      }
>  
>      /* Sets pvt->inject.rank mask */
>      if (pvt->inject.rank < 0)
> -        mask |= 1L <<
> 40;
> +        mask |= 1LL <<
> 40;
>      else {
>          if
> (pvt->channel[pvt->inject.channel].dimms > 2)
> -           
> mask |= (pvt->inject.rank & 0x1L) << 34;
> +           
> mask |= (pvt->inject.rank & 0x1LL) << 34;
>          else
> -           
> mask |= (pvt->inject.rank & 0x3L) << 34;
> +           
> mask |= (pvt->inject.rank & 0x3LL) << 34;
>      }
>  
>      /* Sets pvt->inject.bank mask */
>      if (pvt->inject.bank < 0)
> -        mask |= 1L <<
> 39;
> +        mask |= 1LL <<
> 39;
>      else
> -        mask |=
> (pvt->inject.bank & 0x15L) << 30;
> +        mask |=
> (pvt->inject.bank & 0x15LL) << 30;
>  
>      /* Sets pvt->inject.page mask */
>      if (pvt->inject.page < 0)
> -        mask |= 1L <<
> 38;
> +        mask |= 1LL <<
> 38;
>      else
> -        mask |=
> (pvt->inject.page & 0xffffL) << 14;
> +        mask |=
> (pvt->inject.page & 0xffff) << 14;
>  
>      /* Sets pvt->inject.column mask */
>      if (pvt->inject.col < 0)
> -        mask |= 1L <<
> 37;
> +        mask |= 1LL <<
> 37;
>      else
> -        mask |=
> (pvt->inject.col & 0x3fffL);
> +        mask |=
> (pvt->inject.col & 0x3fff);
>  
>      /*
>       * bit    0:
> REPEAT_EN
> 
> 
