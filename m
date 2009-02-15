Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZBOM72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZBOM72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZBOM7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:59:19 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33165 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbZBOM7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:59:19 -0500
X-Sasl-enc: 7RbUJ1xjSiK4vwVQ8LJmRG8cSjPPRn+illLLHVcKrkuO 1234702757
Date: Sun, 15 Feb 2009 09:59:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mathieu Chouquet-Stringer <mchouque@free.fr>, ibm-acpi@hmh.eng.br,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATH] No Thinkpad Module Autoloading On T30
Message-ID: <20090215125915.GC7660@khazad-dum.debian.net>
References: <20090214223407.GA3367@mobydick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090214223407.GA3367@mobydick>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Feb 2009, Mathieu Chouquet-Stringer wrote:
> Looking at the source, there seems to be a missing * to match my DMI
> string.  I mean for newer IBM and Lenovo's laptops you match either one
> of the following:
> MODULE_ALIAS("dmi:bvnIBM:*:svnIBM:*:pvrThinkPad*:rvnIBM:*");
> MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO:*:pvrThinkPad*:rvnLENOVO:*");
> 
> While for older Thinkpads, you do this (for instance):
> IBM_BIOS_MODULE_ALIAS("1[0,3,6,8,A-G,I,K,M-P,S,T]");
> 
> with IBM_BIOS_MODULE_ALIAS being MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW")
> 
> Note there's no * terminating the string.  As result, udev doesn't load
> anything because modprobe cannot find anything matching this (my
> machine actually):
> 
> udevtest: run: '/sbin/modprobe dmi:bvnIBM:bvr1IET71WW(2.10):bd06/16/2006:svnIBM:pn236621U:pvrNotAvailable:rvnIBM:rn236621U:rvrNotAvailable:cvnIBM:ct10:cvrNotAvailable:'
> 
> So here's my contribution...
> 
> Best,
> 
> Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

I will:
1. retitle the patch to "thinkpad-acpi: fix module autoloading on older models"
2. add the cc for stable@kernel.org
2. queue it to make sure it won't get lost
3. check if Len would take it for 2.6.29 since it is a simple, obvious fix.
If not, it will go in during the 2.6.30 merge window.  After it gets into
mainline, it will go to the stable trees.

Thank you.

> ---
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index bcbc051..70e702a 100644
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
