Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZCNRzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZCNRzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 13:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZCNRzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 13:55:45 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49029 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753577AbZCNRzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 13:55:44 -0400
X-Sasl-enc: tgMq46HCiOm7RlbQxu3Y00PEmotmOhLaPXecrHA5ds9z 1237053342
Date: Sat, 14 Mar 2009 14:55:38 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Len Brown <lenb@kernel.org>,
       ibm-acpi-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] thinkpad-acpi: fix module autoloading for older models
Message-ID: <20090314175538.GA27278@khazad-dum.debian.net>
References: <20090314104204.GA11226@mobydick> <ac3eb2510903140814t26954869m4f07623c25b5948f@mail.gmail.com> <20090314153526.GA13084@mobydick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314153526.GA13084@mobydick>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009, Mathieu Chouquet-Stringer wrote:
> On Sat, Mar 14, 2009 at 04:14:19PM +0100, Kay Sievers wrote:
> > On Sat, Mar 14, 2009 at 11:42, Mathieu Chouquet-Stringer
> > <mchouque@free.fr> wrote:
> > 
> > > While for older Thinkpads, you do this (for instance):
> > > IBM_BIOS_MODULE_ALIAS("1[0,3,6,8,A-G,I,K,M-P,S,T]");
> > 
> > Aliases are shell-style globs. Any idea what the ',' are doing in a
> > character class? Confused ...
> 
> Good point...  I guess it's a typo: perhaps the original authors thought
> of it as a brace expansion?  Something like 1{0,3,6,...}?

I bet that's exactly what happened...  it was a long time ago, so I don't
recall exactly what I was (not) thinking about when I did it.

Thanks for noticing this, and the revised patch looks good.

> A proper patch would then be:
> 
> Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>
>  drivers/platform/x86/thinkpad_acpi.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index bcbc051..d243320 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -7532,7 +7532,7 @@ MODULE_ALIAS(TPACPI_DRVR_SHORTNAME);
>   * if it is not there yet.
>   */
>  #define IBM_BIOS_MODULE_ALIAS(__type) \
> -	MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW")
> +	MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW*")
>  
>  /* Non-ancient thinkpads */
>  MODULE_ALIAS("dmi:bvnIBM:*:svnIBM:*:pvrThinkPad*:rvnIBM:*");
> @@ -7541,9 +7541,9 @@ MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO:*:pvrThinkPad*:rvnLENOVO:*");
>  /* Ancient thinkpad BIOSes have to be identified by
>   * BIOS type or model number, and there are far less
>   * BIOS types than model numbers... */
> -IBM_BIOS_MODULE_ALIAS("I[B,D,H,I,M,N,O,T,W,V,Y,Z]");
> -IBM_BIOS_MODULE_ALIAS("1[0,3,6,8,A-G,I,K,M-P,S,T]");
> -IBM_BIOS_MODULE_ALIAS("K[U,X-Z]");
> +IBM_BIOS_MODULE_ALIAS("I[BDHIMNOTWVYZ]");
> +IBM_BIOS_MODULE_ALIAS("1[0368A-GIKM-PST]");
> +IBM_BIOS_MODULE_ALIAS("K[UX-Z]");
>  
>  MODULE_AUTHOR("Borislav Deianov, Henrique de Moraes Holschuh");
>  MODULE_DESCRIPTION(TPACPI_DESC);

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
