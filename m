Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbXHGO03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbXHGO03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXHGO0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:26:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51237 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbXHGO0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:26:11 -0400
X-Sasl-enc: ExVcRj/TdGr3qccKijk4pk1hq7ooidkPqNyweKu7HHUt 1186496769
Date: Tue, 7 Aug 2007 11:26:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: ibm-acpi-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: refcounting problems with ibm_acpi but acpi=off
Message-ID: <20070807142607.GA7414@khazad-dum.debian.net>
References: <20070807104500.GA1684@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807104500.GA1684@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007, Pavel Machek wrote:
> Perhaps this is needed?
> 								Pavel
> 
> diff --git a/drivers/acpi/ibm_acpi.c b/drivers/acpi/ibm_acpi.c
> index a664f2b..654a124 100644
> --- a/drivers/acpi/ibm_acpi.c
> +++ b/drivers/acpi/ibm_acpi.c
> @@ -2695,6 +2695,9 @@ static void acpi_ibm_exit(void)
>  {
>  	int i;
>  
> +	if (acpi_disabled)
> +		return;
> +
>  	for (i = ARRAY_SIZE(ibms) - 1; i >= 0; i--)
>  		ibm_exit(&ibms[i]);
>  
> 

Indeed it is required, my bad.

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Do you want me to forward a git patch to Len brown?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
