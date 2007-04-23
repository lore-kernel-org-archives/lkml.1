Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbXDWObg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbXDWObg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 10:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbXDWObg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 10:31:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:25864 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbXDWObf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 10:31:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jCRuaVF23yeYY+jqsfH8ewmbm4n/43Ig3XMSWlAy2lyIRX1d6I5MHa0wypC7Kcv/UbIJZvodpqD/1EvX3XPdzroB9+eLlWCaqOeFxdKHrGJE85fCu7aItTosX+Rqfkqyd2GnvnMIqLWG0py9vrR2IjC2SO7aKzNJjHPe6SE84qY=
Subject: Re: [PATCH] Nvidia/Riva FB: Switch to pci_get refcounting APIs not
	pci_find_slot
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070423150134.6fcb815e@the-village.bc.nu>
References: <20070423150134.6fcb815e@the-village.bc.nu>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 22:24:56 +0800
Message-Id: <1177338296.4756.3.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 15:01 +0100, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@redhat.com>

Thanks, and this actually helped expose 2 bugs.

>  	pll = NV_RD32(par->PRAMDAC0, 0x0500);
>  	M = (pll >> 0) & 0xFF;
>  	N = (pll >> 8) & 0xFF;
> @@ -707,19 +707,21 @@
>  	sim_data.pix_bpp = (char)pixelDepth;
>  	sim_data.enable_video = 0;
>  	sim_data.enable_mp = 0;
> -	pci_find_slot(0, 1);
> +	/* pci_find_slot(0, 1); */

This should have been dev = pci_find_slot/pci_get_bus_and_slot().


>  	pci_read_config_dword(dev, 0x7C, &sim_data.memory_type);
> +	pci_dev_put(dev);
>  	sim_data.memory_type = (sim_data.memory_type >> 12) & 1;
>  	sim_data.memory_width = 64;
>  
> -	dev = pci_find_slot(0, 3);
> +	dev = pci_get_bus_and_slot(0, 3);
>  	pci_read_config_dword(dev, 0, &memctrl);
> +	pci_dev_put(dev);
>  	memctrl >>= 16;
>  
>  	if ((memctrl == 0x1A9) || (memctrl == 0x1AB) || (memctrl == 0x1ED)) {
>  		int dimm[3];
>  
> -		pci_find_slot(0, 2);
> +		/* pci_find_slot(0, 2); */

Ditto.

Will resubmit.

Tony


