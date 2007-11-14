Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbXKNOZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbXKNOZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbXKNOZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:25:26 -0500
Received: from moci.net4u.de ([217.7.64.195]:48748 "EHLO moci.net4u.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbXKNOZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:25:25 -0500
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 09:25:25 EST
From: Ernst Herzberg <earny@net4u.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] pcmcia serial_cs no interrupts
Date: Wed, 14 Nov 2007 15:05:22 +0100
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200711131755.25246.list-lkml@net4u.de> <20071113175201.72995c65@the-village.bc.nu>
In-Reply-To: <20071113175201.72995c65@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711141505.22705.earny@net4u.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 13. November 2007 18:52:01 schrieb Alan Cox:
> On Tue, 13 Nov 2007 17:55:25 +0100
>
> Ernst Herzberg <list-lkml@net4u.de> wrote:
> > This pcmcia-card (UMTS Modem) only works if it shares his interrupt with
> > another device, eg an usb mice. Moving the mice increases the connection
> > speed, unplugging hangs the connection.
>
> Thats consistent with the card not generating interrupts, or the
> interrupts being misrouted. The serial driver polls the interrupt pending
> bits on the chip so the actual serial chip is clearly expecting
> interrupts to go somewhere. Given this seems to be card not laptop
> specific it looks like there is magic intiialisation gloop required by
> this chipset that we don't have.
>
> > At the moment this card is my only way to reach the internet, but here in
> > the hospital i have a lot time to test patches;)
>
> You may want to boot with irqpoll that may help a bit.
>
> Some info at:
>
> A helpful start would be to know if the setserial command (applied to
> whatever tty your system calls the card) helps as given in:
>
> https://bugs.launchpad.net/ubuntu/+source/pcmciautils/+bug/99479

Thanks. So far i have checked:

2.6.15.X does not work. Same problen there: no shared irq, no umts (only to 
make shure..). Never will try an older kernel than 2.6.24 from now on;-)

The setserial command itself does not change anything. But the combination of 
irqpoll and "setserial /dev/modem baud_base 460800 spd_warp low_latency"
allows the card to function on a lonesome interrupt even with usable speed.

But the card itself does not generate any interrupt at all during that 
time. /proc/interrupts counts up two on a physical insert of the card, one 
with a "pccardctl insert 0" or a physical remove, a "pccardctl eject 0" 
counts zero.

