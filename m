Return-Path: <linux-kernel-owner+w=401wt.eu-S1764212AbXGVUNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764212AbXGVUNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762204AbXGVUNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:13:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:62474 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761058AbXGVUNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hLntS8yf0SPqdOL2GnTLXu4IV6ZLZslD5IwGzvW6WTqORbarnCT6OqfVG7UrN+ytZMliLNTNNmLalFWDRDGtDOzbLmBQexhtBMgZeTrH/8RKvEtJhgIG++6/NIWp9OlFZLF6jqu+P1UseJok0fYHaM2QIzey8sXxhAGer91gjDs=
Message-ID: <46A3BA7D.3030000@gmail.com>
Date: Sun, 22 Jul 2007 22:13:49 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix drivers/char/cyclades.c warning with CONFIG_PCI=n
References: <46A3A0A9.3020100@googlemail.com>
In-Reply-To: <46A3A0A9.3020100@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C napsal(a):
> Hi,
> 
> when CONFIG_PCI is not set I get this warning :
> 
> ...
> 
> drivers/char/cyclades.c: In function 'cy_init':
> drivers/char/cyclades.c:5488: warning: label 'err_unr' defined but not used
> 
> ...
> 
> 
> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> 
> ---
> 
> diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
> index 9e0adfe..1fa0bda 100644
> --- a/drivers/char/cyclades.c
> +++ b/drivers/char/cyclades.c
> @@ -5485,8 +5485,11 @@ static int __init cy_init(void)
>  #endif
>  
>  	return 0;
> +
> +#ifdef CONFIG_PCI
>  err_unr:
>  	tty_unregister_driver(cy_serial_driver);
> +#endif
>  err_frtty:
>  	put_tty_driver(cy_serial_driver);
>  err:

NAK

remove the ifdef at all. pci_register_driver becomes a void function if
!CONFIG_PCI. This will get rid of ugly macros inside the code. And Cc akpm.

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
