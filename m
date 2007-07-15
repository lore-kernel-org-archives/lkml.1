Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbXGOKi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbXGOKi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 06:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbXGOKiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 06:38:15 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54421
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864AbXGOKiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 06:38:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bryan.wu@analog.com
Subject: Re: [PATCH try#2] Blackfin ethernet driver: on chip ethernet MAC controller driver
Date: Sun, 15 Jul 2007 12:36:51 +0200
User-Agent: KMail/1.9.6
Cc: Mike Frysinger <vapier.adi@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
References: <1184491629.3140.59.camel@roc-laptop>
In-Reply-To: <1184491629.3140.59.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707151236.51779.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 July 2007 11:27:09 Bryan Wu wrote:
> +#if defined(CONFIG_BFIN_MAC_USE_L1)
> +# define bfin_mac_alloc(dma_handle, size)  l1_data_sram_zalloc(size)
> +# define bfin_mac_free(dma_handle, ptr)    l1_data_sram_free(ptr)
> +#else
> +# define bfin_mac_alloc(dma_handle, size) \
> +	 dma_alloc_coherent(NULL, size, dma_handle, GFP_NORMAL)

What is GFP_NORMAL? It's not defined in latest linus' tree.
I think you should use GFP_KERNEL, if you can sleep, or GFP_ATOMIC,
if you can't.

The rest looks OK. Except the endianess issues. It might be no
issue on the hardware this runs on, but in favour of "clean code"
you might use leXX_to_cpu and friends anyway. :)
This kind of bugs is done so often, even in places where it _does_
matter. So, at least for the human reader, the leXX_to_cpu stuff
says that you really understood what you were doing when writing
the code. The current code says (to me), that it works by
accident, somehow, although it seems you knew what you were doing. :)

-- 
Greetings Michael.
