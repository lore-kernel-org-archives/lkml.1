Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZBHUI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZBHUI5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 15:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZBHUIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 15:08:45 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:34221 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbZBHUIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 15:08:44 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: David Miller <davem@davemloft.net>
Subject: Re: 3c509 resume from hibernation broken somewhere between 2.6.25 and 2.6.28
Date: Sun, 8 Feb 2009 21:08:35 +0100
User-Agent: KMail/1.9.10
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200902061422.14746.linux@rainbow-software.org> <20090206.220426.21894163.davem@davemloft.net>
In-Reply-To: <20090206.220426.21894163.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902082108.37180.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 February 2009 07:04:26 David Miller wrote:
> From: Ondrej Zary <linux@rainbow-software.org>
> Date: Fri, 6 Feb 2009 14:22:13 +0100
>
> > Hello,
> > last year, I posted a patch which fixed hibernation on 3c509 cards. That
> > was back in 2.6.24. It worked fine in 2.6.25. But then I stopped using
> > hibernation (as it did not work with my new IT8212 RAID controller).
> >
> > Now I fixed it and noticed that 3c509 does not wake up properly anymore
> > (in 2.6.28) - neither in PnP nor in ISA modes. ifconfig down/up makes the
> > card work again in PnP mode. However, in ISA mode, ifconfig up ends with
> > "No such device" error.
> >
> > Comparing the 3c509 driver between 2.6.25 and 2.6.28, there's only some
> > statistics-related change. So the cause of the problem must be somewhere
> > else.
> >
> > This patch makes the resume work in PnP mode, but it's still not enough
> > for ISA mode.
>
> Patch applied, thank you.
>
> Let us know if you figure out how to get the ISA case working
> too :-)

Found that when the driver is compiled as module, ISA resume works fine. But 
when the driver is compiled in the kernel, it does not work. I'm unable to 
find why.

When resuming, el3_isa_resume() is called first. It then calls 
el3_isa_id_sequence(). This function fails when the driver is compiled-in 
because id_read_eeprom(7) returns 0xFFFF - as if the card is not present 
there. I'm out of ideas.

-- 
Ondrej Zary
