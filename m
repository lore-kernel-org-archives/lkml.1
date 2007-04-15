Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbXDOMxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbXDOMxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 08:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXDOMxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 08:53:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48514 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbXDOMxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 08:53:46 -0400
Message-ID: <46222051.9010104@garzik.org>
Date: Sun, 15 Apr 2007 08:53:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ulrich Eckhardt <doomster@knuut.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] use C99 initialisers for PCI_VDEVICE()
References: <200704151234.37463.doomster@knuut.de>
In-Reply-To: <200704151234.37463.doomster@knuut.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Eckhardt wrote:
> (Note: CC me please, I'm not subscribed.)
> 
> Not much to say about the patch (it's against 2.6.20.6), it just converts a 
> macro to generate C99-style initialisers.
> 
> --- include/linux/pci.h   (revision 17)
> +++ include/linux/pci.h   (working copy)
> @@ -407,9 +407,10 @@
>   * private data.
>   */
>  
> -#define PCI_VDEVICE(vendor, device)            \
> -       PCI_VENDOR_ID_##vendor, (device),       \
> -       PCI_ANY_ID, PCI_ANY_ID, 0, 0
> +#define PCI_VDEVICE(vend, dev)         \
> +       .vendor=PCI_VENDOR_ID_##vend, .device=(dev),    \
> +       .subvendor=PCI_ANY_ID, .subdevice=PCI_ANY_ID,   \
> +       .class=0, .class_mask=0

NAK.  C99 initializers were intentionally avoided.  Look at the usage of 
this macro.

	Jeff



