Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZCKTER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZCKTER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZCKTEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:04:04 -0400
Received: from web50102.mail.re2.yahoo.com ([206.190.38.30]:26439 "HELO
	web50102.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752621AbZCKTED convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:04:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=GlvWngRE1ijN+qBf9XSW7otRpwA045xwxcCjzDiVOEiwCjB7PcyI8qH+8C9ipqLWVlOrNFtLGvEtsgnEj9tFSILg/02jFooSYKW0HRTi9GFC3ge/W4xRU35Qy/yn5aiPaba67h5f6xfGF7oy5QkqWmavj260uIphEjHB/rCqWNU=;
Message-ID: <264247.38837.qm@web50102.mail.re2.yahoo.com>
X-YMail-OSG: IOO4.LMVM1nz3N_2kZYF2djsHXuAypbrdFfuO2.r6e_OS8c9WPE-
X-Mailer: YahooMailClassic/5.1.19 YahooMailWebService/0.7.289.4
Date: Wed, 11 Mar 2009 12:03:59 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [v2 PATCH 7/7] EDAC: AMD8131 driver Kconfig and Makefile - errors
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net,
       Harry Ciao <qingtao.cao@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Tue, 3/10/09, Harry Ciao <qingtao.cao@windriver.com> wrote:

> From: Harry Ciao <qingtao.cao@windriver.com>
> Subject: [v2 PATCH 7/7] EDAC: AMD8131 driver Kconfig and Makefile
> To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
> Date: Tuesday, March 10, 2009, 9:25 PM
> Introduce Kconfig and Makefile
> options for AMD8131 EDAC driver.
> 
> Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
> ---
>  drivers/edac/Kconfig  |    7 +++++++
>  drivers/edac/Makefile |    1 +
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 46f8e77..13ccec6 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -181,4 +181,11 @@ config EDAC_AMD8111
>        Support for error detection and
> correction on the
>        AMD8111 HyperTransport I/O Hub
> chip.
>  
> +config EDAC_AMD8131
> +    tristate "AMD8131 HyperTransport PCI-X
> Tunnel"
> +    depends on EDAC_MM_EDAC && PCI
> +    help
> +      Support for error detection and
> correction on the
> +      AMD8131 HyperTransport PCI-X
> Tunnel chip.
> +
>  endif # EDAC
> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
> index c324956..407601f 100644
> --- a/drivers/edac/Makefile
> +++ b/drivers/edac/Makefile
> @@ -35,4 +35,5 @@
> obj-$(CONFIG_EDAC_MPC85XX)   
>     += mpc85xx_edac.o
>  obj-$(CONFIG_EDAC_MV64X60)   
>     += mv64x60_edac.o
>  obj-$(CONFIG_EDAC_CELL)   
>         += cell_edac.o
>  obj-$(CONFIG_EDAC_AMD8111)   
>     += amd8111_edac.o
> +obj-$(CONFIG_EDAC_AMD8131)   
>     += amd8131_edac.o
>  
> -- 
> 1.5.6.2

Andrew,

I notice that the above is different from what is now in mmotm.

In the patches posted, amd8111 module IS and the amd8131 modules is NOT, configured in the Makefile to be compiled.

In the mmotm version NEITHER is configured to be compiled. When I do add them I get the following errors:

drivers/edac/amd8111_edac.c: In function ‘amd8111_lpc_bridge_init’:
drivers/edac/amd8111_edac.c:259: error: implicit declaration of function ‘__do_inb’
drivers/edac/amd8111_edac.c:273: error: implicit declaration of function ‘__do_outb’
drivers/edac/amd8111_edac.c: In function ‘amd8111_dev_probe’:
drivers/edac/amd8111_edac.c:383: warning: passing argument 2 of ‘edac_device_alloc_ctl_info’ discards qualifiers from pointer target type


and

drivers/edac/amd8111_edac.c: In function ‘amd8111_lpc_bridge_init’:
drivers/edac/amd8111_edac.c:259: error: implicit declaration of function ‘__do_inb’
drivers/edac/amd8111_edac.c:273: error: implicit declaration of function ‘__do_outb’
drivers/edac/amd8111_edac.c: In function ‘amd8111_dev_probe’:
drivers/edac/amd8111_edac.c:383: warning: passing argument 2 of ‘edac_device_alloc_ctl_info’ discards qualifiers from pointer target type


I assume that is why it is currently not enabled. I just didn't see it mentioned anywhere, but you are probably aware of it.

doug t



