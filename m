Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbXLNUjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbXLNUjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXLNUjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:39:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33715 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbXLNUjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:39:31 -0500
Message-ID: <4762E9FE.1070707@garzik.org>
Date: Fri, 14 Dec 2007 15:39:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: netdev@vger.kernel.org, randy.dunlap@oracle.com, auke-jan.h.kok@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/10] e1000e: make E1000E default to the same kconfig
 setting as E1000
References: <200712140002.lBE02pUb025505@imap1.linux-foundation.org>
In-Reply-To: <200712140002.lBE02pUb025505@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make E1000E default to the same kconfig setting as E1000.  So people's
> machiens don't stop working when they use oldconfig.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> Cc: Auke Kok <auke-jan.h.kok@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/net/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -puN drivers/net/Kconfig~e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000 drivers/net/Kconfig
> --- a/drivers/net/Kconfig~e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000
> +++ a/drivers/net/Kconfig
> @@ -1986,6 +1986,7 @@ config E1000_DISABLE_PACKET_SPLIT
>  config E1000E
>  	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
>  	depends on PCI
> +	default E1000

I am not inclined to apply this one.  This practice, applied over time, 
will tend to accumulate weird 'default' and 'select' statements.

So I think the breakage that occurs is mitigated by two factors:
1) kernel hackers that do their own configs are expected to be able to 
figure this stuff.
2) kernel builders (read: distros, mainly) are expected to have put 
thought into the Kconfig selection and driver migration strategies.

PCI IDs move across drivers from time, and we don't want to apply these 
sorts changes:  Viewed in the long term, the suggested patch is merely a 
temporary change to allow kernel experts to more easily deal with the 
PCI ID migration across drivers.

I would prefer simply to communicate to kernel experts and builders 
about a Kconfig issue that could potentially their booting/networking... 
  because this patch is only needed if the kernel experts do not already 
know about a necessary config update.

	Jeff


