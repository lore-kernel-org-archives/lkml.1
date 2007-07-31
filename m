Return-Path: <linux-kernel-owner+w=401wt.eu-S940457AbXGaBwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940457AbXGaBwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbXGaBwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:52:47 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:56351 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004AbXGaBwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:52:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uQ+AwIjr7oRQA1YOTjXX/0F5nu9hTwh7pSDlXtoGJQyuVrTFOIU0X6cjnvo6i8p3+S/ijYVvLl4nYIqv0bCaZCjIlHRQ1qAeLrEYJnFcBEBcPoJh6bhZ8rjPD+FqdrVW+IWxF6Vr+oimH8BPfDZ6DCeG7OP9jl1hJs1y8V4eedY=
Message-ID: <3ae72650707301852p7289cc42of3e2a0ec2c62a5e1@mail.gmail.com>
Date: Tue, 31 Jul 2007 03:52:45 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Carl-Daniel Hailfinger" <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: forcedeth ?
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Sasa Ostrouska" <casaxa@gmail.com>, "Avuton Olrich" <avuton@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46AE9221.70302@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>
	 <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com>
	 <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com>
	 <46AE6029.60308@googlemail.com> <46AE6372.20808@googlemail.com>
	 <46AE9221.70302@gmx.net>
X-Google-Sender-Auth: bfb39f24efdd5b74
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net> wrote:
> On 31.07.2007 00:17, Gabriel C wrote:
> > Sasa Ostrouska wrote:
> >
> >> Gabriel, hmm, shouldnt udev be able to autoconfigure that ? But I need
> >> to check that, thx for the tip.
> >
> > Yes udev does this based on the MAC address but AFAIK forcedeth is 'special' for some reason
> > ( which I can really remember now and gets on each boot a new MAC address or alike )
>
> Ah yes, that's a workaround for certain buggy boards to make sure you're
> not left without networking even if the MAC address stored on the board
> is bogus.
>
> Basically, forcedeth checks if the MAC address supplied by your
> mainboard is bogus and autogenerates a random MAC address from a private
> range (prefix 00:00:6c) as workaround. However, it will complain loudly
> if it has to do that.
>
> Quoting from forcedeth.c:
> > if (!is_valid_ether_addr(dev->perm_addr)) {
> >       /*
> >        * Bad mac address. At least one bios sets the mac address
> >        * to 01:23:45:67:89:ab
> >        */
> >       printk(KERN_ERR "%s: Invalid Mac address detected: %02x:%02x:%02x:%02x:%02x:%02x\n",
> >               pci_name(pci_dev),
> >               dev->dev_addr[0], dev->dev_addr[1], dev->dev_addr[2],
> >               dev->dev_addr[3], dev->dev_addr[4], dev->dev_addr[5]);
> >       printk(KERN_ERR "Please complain to your hardware vendor. Switching to a random MAC.\n");
> >       dev->dev_addr[0] = 0x00;
> >       dev->dev_addr[1] = 0x00;
> >       dev->dev_addr[2] = 0x6c;
> >       get_random_bytes(&dev->dev_addr[3], 3);
> > }
>
> Sometimes it helps to update the BIOS and/or set the MAC address which
> is printed on the board as MAC address in the BIOS.

In any case, it would be nice if the network core could add something like:
  MAC_ORIGIN=device
  MAC_ORIGIN=user
  MAC_ORIGIN=random
or whatever makes sense here, to the uevent environment. So userspace
can handle according to that, like falling back using the
bus-slot-number to lookup the persistent name, or whatever is
appropriate.

Thanks,
Kay
