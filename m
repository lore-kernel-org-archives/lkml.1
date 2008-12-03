Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYLCWIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYLCWIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbYLCWGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:06:34 -0500
Received: from waikiki.ops.eusc.inter.net ([84.23.254.155]:62316 "EHLO
	waikiki.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987AbYLCWGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:06:33 -0500
X-Trace: 4d7c636f72642e77616c74657240736e6166752e64657c3231332e3130322e3130
	362e3233347c314c377a72592d30303050434d2d52507c31323238333431393839
Message-ID: <493702E2.3020803@gmx.de>
Date: Wed, 03 Dec 2008 23:06:26 +0100
From: Cord Walter <cord.walter@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, komurojun-mbn@nifty.com,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 027/104] axnet_cs / pcnet_cs: moving PCMCIA_DEVICE_PROD_ID
 for Netgear FA411
References: <20081203193901.715896543@mini.kroah.org> <20081203195041.GB8950@kroah.com>
In-Reply-To: <20081203195041.GB8950@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently this patch from Kumoru fixes the problem too.

--- linux-2.6.28-rc6/drivers/net/pcmcia/pcnet_cs.c.orig	2008-11-21
21:39:08.000000000 +0900
+++ linux-2.6.28-rc6/drivers/net/pcmcia/pcnet_cs.c	2008-11-21
21:39:24.000000000 +0900
@@ -587,7 +587,7 @@ static int pcnet_config(struct pcmcia_de
      }

      if ((link->conf.ConfigBase == 0x03c0)
-	&& (link->manf_id == 0x149) && (link->card_id = 0xc1ab)) {
+	&& (link->manf_id == 0x149) && (link->card_id == 0xc1ab)) {
  	printk(KERN_INFO "pcnet_cs: this is an AX88190 card!\n");
  	printk(KERN_INFO "pcnet_cs: use axnet_cs instead.\n");
  	goto failed;

My Netgear FA411 card works with both solutions.

-cord


> Cord Walter <cord.walter@gmx.de> wrote:
> 
> OK. Thanks for your test.
> 
> Best Regards
> Komuro
> 
>> > -----BEGIN PGP SIGNED MESSAGE-----
>> > Hash: SHA1
>> > 
>> > Komuro schrieb:
>>>> > >> Does this help?
>>> > > 
>>> > > YES.
>>> > > 
>>> > > Could you test the path below at kernel-2.6.28-rc6
>>> > > without the path "axnet_cs / pcnet_cs: moving PCMCIA_DEVICE_PROD_ID
>>> > >  for Netgear FA411"?
>>> > > 
>>> > > 
>>> > > --- linux-2.6.28-rc6/drivers/net/pcmcia/pcnet_cs.c.orig	2008-11-21 21:39:08.000000000 +0900
>>> > > +++ linux-2.6.28-rc6/drivers/net/pcmcia/pcnet_cs.c	2008-11-21 21:39:24.000000000 +0900
>>> > > @@ -587,7 +587,7 @@ static int pcnet_config(struct pcmcia_de
>>> > >      }
>>> > >  
>>> > >      if ((link->conf.ConfigBase == 0x03c0)
>>> > > -	&& (link->manf_id == 0x149) && (link->card_id = 0xc1ab)) {
>>> > > +	&& (link->manf_id == 0x149) && (link->card_id == 0xc1ab)) {
>>> > >  	printk(KERN_INFO "pcnet_cs: this is an AX88190 card!\n");
>>> > >  	printk(KERN_INFO "pcnet_cs: use axnet_cs instead.\n");
>>> > >  	goto failed;
>>> > > 
>> > 
>> > I tried it after some problems compiling a -rc6 Kernel that was bootable
>> > on my notebook (The Notebook with the FA411 card is rather slow and
>> > takes 5.5 hours for a kernel compile & the faster machine I used
>> > produced an unbootable kernel on the first 2 tries...).
>> > 
>> > It works with the pcnet-cs driver and here is what lspcmcia -v and dmesg
>> > said:
>> > 
>> > lspcmcia -v:
>> > 
>> > Socket 0 Bridge:   	[yenta_cardbus] 	(bus ID: 0000:00:0f.0)
>> > 	Configuration:	state: on	ready: yes
>> > 			Voltage: 5.0V Vcc: 5.0V Vpp: 0.0V
>> > Socket 0 Device 0:	[pcnet_cs]		(bus ID: 0.0)
>> > 	Configuration:	state: on
>> > 	Product Name:   NETGEAR FA411 Fast Ethernet
>> > 	Identification:	manf_id: 0x0149	card_id: 0x0411
>> > 			function: 6 (network)
>> > 			prod_id(1): "NETGEAR" (0x9aa79dc3)
>> > 			prod_id(2): "FA411" (0x40fad875)
>> > 			prod_id(3): "Fast Ethernet" (0xb4be14e3)
>> > 			prod_id(4): --- (---)
>> > Socket 1 Bridge:   	[yenta_cardbus] 	(bus ID: 0000:00:0f.1)
>> > 	Configuration:	state: on	ready: yes
>> > 
>> > 
>> > dmesg:
>> > 
>> > pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
>> > pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
>> > excluding 0xa0000000-0xa00fffff
>> > pcmcia 0.0: pcmcia: registering new device pcmcia0.0
>> > eth0: NE2000 Compatible: io 0x300, irq 3, hw_addr 00:09:5b:08:98:93
>> > udev: renamed network interface eth0 to eth1
>> > 
>> > So, apparently the card can run with both drivers...
>> > 
>> > - -cord
>> > 


-- 
Cord Walter
email: cord.walter@gmx.de

Weil es niemanden etwas angeht, dass ich nichts zu verbergen habe:
http://www.gnupg.org/
http://www.truecrypt.org/

