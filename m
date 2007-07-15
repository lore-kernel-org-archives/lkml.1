Return-Path: <linux-kernel-owner+w=401wt.eu-S932737AbXGOAMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbXGOAMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 20:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760962AbXGOAMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 20:12:47 -0400
Received: from web50109.mail.re2.yahoo.com ([206.190.38.37]:27935 "HELO
	web50109.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760763AbXGOAMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 20:12:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=O3ROgY/s6dtO+vu4DxFPKy8qXjaxDuodlLklYjbh+xNF3rCQEtD7jq3EnvNgUrMY7qqCtNHRGXpwPO97wDcjut4IygmD/e5Tn7quXVSVqkrNLzOpCLhTwnB+QBlnoVeg+NETSHs4Re0fsEqSXmDhBkByD205JalRk3toATnb630=  ;
Message-ID: <20070715001245.32242.qmail@web50109.mail.re2.yahoo.com>
X-YMail-OSG: Kk2Vh_UVM1nDPwbIvyA77.pvPPcNJKuN4mRjF2xtu54y3vgQUW3nIUDHVhy_xS2M9pB4ocY42lPqY_vN6gVlVqLMufhU.SySUKtUCxo5uQLRRy6QfY.c5m2J7azESIDwh67u6u8Hn9A-
Date: Sat, 14 Jul 2007 17:12:45 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH 3/8] drivers edac new pasemi driver
To: Andrew Morton <akpm@linux-foundation.org>, dougthompson@xmission.com
Cc: greg@kroah.com, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Egor Martovetsky <egor@pasemi.com>
In-Reply-To: <20070713113641.52157b67.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morton <akpm@linux-foundation.org> wrote:


> > +		default:
> > +			edac_mc_printk(mci, KERN_ERR,
> > +				       "Unrecognized Rank Config\n");
> 
> If this message ever comes out, you're gonna say "argh, I wish I'd printed
> rankcfg".
> 
> Do you want to do this??

Yeah, I will gen a patch for him. He is in india and turn around takes a day or two

doug thompson



> 
> --- a/drivers/edac/pasemi_edac.c~drivers-edac-new-pasemi-driver-fix
> +++ a/drivers/edac/pasemi_edac.c
> @@ -168,7 +168,8 @@ static int pasemi_edac_init_csrows(struc
>  			break;
>  		default:
>  			edac_mc_printk(mci, KERN_ERR,
> -				       "Unrecognized Rank Config\n");
> +				"Unrecognized Rank Config. rankcfg=%u\n",
> +				rankcfg);
>  			return -EINVAL;
>  		}
>  
> @@ -244,9 +245,8 @@ static int __devinit pasemi_edac_probe(s
>  	 */
>  	pasemi_edac_get_error_info(mci);
>  
> -	if (edac_mc_add_mc(mci, system_mmc_id++)) {
> +	if (edac_mc_add_mc(mci, system_mmc_id++))
>  		goto fail;
> -	}
>  
>  	/* get this far and it's successful */
>  	return 0;
> _
> 
> 

