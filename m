Return-Path: <linux-kernel-owner+w=401wt.eu-S933805AbXDAS3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbXDAS3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933814AbXDAS3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:29:03 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:50487 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933805AbXDAS3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:29:01 -0400
Message-ID: <460FF9E7.1080107@gmail.com>
Date: Sun, 01 Apr 2007 20:28:55 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pedram M <pmessri@gmail.com>, kernel-janitors@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: my first janitorial
References: <9c9aa5d00703310639q68fa5d19k4d8e3bfb56b1fa6@mail.gmail.com>	<9c9aa5d00703312224t1948b24bhe34199f19cbda4fb@mail.gmail.com> <20070401170043.27a581cb@the-village.bc.nu>
In-Reply-To: <20070401170043.27a581cb@the-village.bc.nu>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox napsal(a):
> On Sat, 31 Mar 2007 22:24:12 -0700
> "Pedram M" <pmessri@gmail.com> wrote:
> 
>> How about this one? Am I doing it right now?
>> If not, please try to explain more to me what I am
>> doing wrong.
> 
> You need to hold a reference to the PCI device for the entire duration it
> is used. I think you actually also need something like this to get the whole
> thing using pci references and pci_get_* properly
> 
> Alan
> 
> --- drivers/char/cyclades.c~	2007-04-01 15:52:16.000000000 +0100
> +++ drivers/char/cyclades.c	2007-04-01 15:52:16.000000000 +0100
> @@ -4803,7 +4782,7 @@
>                  cy_card[j].bus_index = 1;
>                  cy_card[j].first_line = cy_next_channel;
>                  cy_card[j].num_chips = cy_pci_nchan/4;
> -		cy_card[j].pdev = pdev;
> +		cy_card[j].pdev = pci_dev_get(pdev);

No, please let this code be, I have a bunch of patches to have pci_probing
for this driver, the remaining part for first set of patches is testing.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
