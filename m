Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbXEUIJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbXEUIJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbXEUIJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:09:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:49884 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbXEUIJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AbbAiNOgv7TEYt4RlHlQI+6Xu9+W95zR1ZJ2ioT4T8sHm5yy4xzqyRZMO7ifOIwJb8Nuw894tXpM4Xcz1VHw6um01m4z0ZlsdrI86fApBTcG9lb89QAu0MgEVpqr95X6GNGEDalHjV0SjPxLqyqChxnEOo9uCW1f8l8oL5UpTDU=
Message-ID: <465153AF.5030008@gmail.com>
Date: Mon, 21 May 2007 10:09:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc2 BUG: at include/linux/slub_def.h:77 kmalloc_index()
References: <1179728579.11803.1.camel@localhost>
In-Reply-To: <1179728579.11803.1.camel@localhost>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg napsal(a):
> a regression (well I switched to slub) happens on boot...
> 
> ...
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:1d.3 to 64
> uhci_hcd 0000:00:1d.3: UHCI Host Controller
> uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004040
> usb usb5: configuration #1 chosen from 1 choice
> hub 5-0:1.0: USB hub found
> hub 5-0:1.0: 2 ports detected
> usb 1-4: new high speed USB device using ehci_hcd and address 3
> BUG: at include/linux/slub_def.h:77 kmalloc_index()
>  [<c0176448>] get_slab+0x1c8/0x250
>  [<c02f18f4>] usb_get_configuration+0x854/0xfa0
>  [<c01778ec>] __kmalloc_track_caller+0x1c/0x80
>  [<c0162e2a>] __kzalloc+0x1a/0x50
>  [<c02f18f4>] usb_get_configuration+0x854/0xfa0
>  [<c02ee560>] usb_start_wait_urb+0x70/0xb0
>  [<c02e9250>] hub_port_init+0x90/0x5f0
>  [<c02ea2e4>] usb_new_device+0x14/0x100
>  [<c02eae2b>] hub_thread+0x5ab/0xc30
>  [<c013f710>] autoremove_wake_function+0x0/0x50
>  [<c02ea880>] hub_thread+0x0/0xc30
>  [<c013f432>] kthread+0x42/0x70
>  [<c013f3f0>] kthread+0x0/0x70
>  [<c0104df3>] kernel_thread_helper+0x7/0x14
>  =======================
> usb 1-4: configuration #1 chosen from 1 choice
> usb 2-2: new full speed USB device using uhci_hcd and address 2
> usb 2-2: configuration #1 chosen from 1 choice
> usb 4-2: new full speed USB device using uhci_hcd and address 2
> ...

Could you try this patch:
http://lkml.org/lkml/2007/5/19/171

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
