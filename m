Return-Path: <linux-kernel-owner+w=401wt.eu-S1030397AbXCCTaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030397AbXCCTaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 14:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030395AbXCCTaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 14:30:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36211 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030390AbXCCTaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 14:30:17 -0500
Date: Sat, 3 Mar 2007 20:33:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@osdl.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_cmd640: CMD640 PCI support
Message-ID: <20070303203339.6f605ac9@lxorguk.ukuu.org.uk>
In-Reply-To: <45E9AC6B.50701@ru.mvista.com>
References: <20070302150306.368e24b9@lxorguk.ukuu.org.uk>
	<45E8B28D.7030500@garzik.org>
	<45E9AC6B.50701@ru.mvista.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +    if (t.active > 16)
> >> +        t.active = 16;
> 
>     Erm, clamping active time is not a right thing to do. Right thing to do 
> was to bail out. I didn't do it in the legacy driver rewrite though...

As far as I can work out its a "can't happen"

> >> +        pci_read_config_byte(pdev, ARTIM23, &reg);
> 
>     It's not even expensive, it may be just unsafe.

You have to serialize the channels and idle both so its very expensive -
or is that what you meant by unsafe.

> >> +    /* CMD640 detected, commiserations */
> >> +    pci_write_config_byte(pdev, 0x5C, 0x00);
> 
> > magic number
> 
>    Indeed, completely undocumented. And I don't even see it in the legacy 
> driver...

Should be 0x5B which is still undocumented. Will fix that.

>     It's used to be a well known fact (soon after Intel put that chip on their 
> motherboards :-) that PCI0640 may return bad data on command block reads if 
> another channel has data port I/O going on. That's why the interrupts needed 
> to be disabled during PIO in the legacy driver (and the channels serialized).

I was under the impression this was only the situation with the
FIFO/readahead logic enabled, as with the RZ1000 ? Can you clarify that
at all ?

Alan
