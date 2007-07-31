Return-Path: <linux-kernel-owner+w=401wt.eu-S940160AbXGaBgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940160AbXGaBgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761588AbXGaBg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:36:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:34524 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760682AbXGaBgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:36:25 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX1/1lBdaIlb1qE6Xdbc+zFzVYr52qAOKkL8uqlVzGC
	2vXiqStC7DCIxe
Message-ID: <46AE9221.70302@gmx.net>
Date: Tue, 31 Jul 2007 03:36:33 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SUSE/1.0.8-0.1 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Sasa Ostrouska <casaxa@gmail.com>, Avuton Olrich <avuton@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: forcedeth ?
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>	 <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com>	 <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com>	 <46AE6029.60308@googlemail.com> <dcf706c60707301510n6c2b649p44739 <46AE6372.20808@googlemail.com>
In-Reply-To: <46AE6372.20808@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.07.2007 00:17, Gabriel C wrote:
> Sasa Ostrouska wrote:
>
>> Gabriel, hmm, shouldnt udev be able to autoconfigure that ? But I need
>> to check that, thx for the tip.
> 
> Yes udev does this based on the MAC address but AFAIK forcedeth is 'special' for some reason 
> ( which I can really remember now and gets on each boot a new MAC address or alike )

Ah yes, that's a workaround for certain buggy boards to make sure you're
not left without networking even if the MAC address stored on the board
is bogus.

Basically, forcedeth checks if the MAC address supplied by your
mainboard is bogus and autogenerates a random MAC address from a private
range (prefix 00:00:6c) as workaround. However, it will complain loudly
if it has to do that.

Quoting from forcedeth.c:
> if (!is_valid_ether_addr(dev->perm_addr)) {
> 	/*
> 	 * Bad mac address. At least one bios sets the mac address
> 	 * to 01:23:45:67:89:ab
> 	 */
> 	printk(KERN_ERR "%s: Invalid Mac address detected: %02x:%02x:%02x:%02x:%02x:%02x\n",
> 		pci_name(pci_dev),
> 		dev->dev_addr[0], dev->dev_addr[1], dev->dev_addr[2],
> 		dev->dev_addr[3], dev->dev_addr[4], dev->dev_addr[5]);
> 	printk(KERN_ERR "Please complain to your hardware vendor. Switching to a random MAC.\n");
> 	dev->dev_addr[0] = 0x00;
> 	dev->dev_addr[1] = 0x00;
> 	dev->dev_addr[2] = 0x6c;
> 	get_random_bytes(&dev->dev_addr[3], 3);
> }

Sometimes it helps to update the BIOS and/or set the MAC address which
is printed on the board as MAC address in the BIOS.

Regards,
Carl-Daniel
