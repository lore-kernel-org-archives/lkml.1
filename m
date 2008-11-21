Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYKUMxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYKUMxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYKUMxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:53:25 -0500
Received: from userg502.nifty.com ([202.248.238.82]:23419 "EHLO
	userg502.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbYKUMxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:53:24 -0500
DomainKey-Signature: a=rsa-sha1; s=userg502; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=qvFmU65Ctd2mED3d4zYZgx3NoMim8punckmZ+zLsy1DHZFB7Mc0eYoxbCGoRXM/N2
	DII/BXN8KsaofjERfPzVA==
X-Nifty-SrcIP: [219.116.16.197]
Date: Fri, 21 Nov 2008 21:48:12 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Cord Walter <cord.walter@gmx.de>
Cc: netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: axnet_cs / pcnet_cs: moving PCMCIA_DEVICE_PROD_ID for Netgear
 FA411
Message-Id: <20081121214812.b03d7166.komurojun-mbn@nifty.com>
In-Reply-To: <4925F6F1.9010305@gmx.de>
References: <4925F6F1.9010305@gmx.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 00:46:57 +0100
Cord Walter <cord.walter@gmx.de> wrote:

> after noticing that my Netgear FA411 (PCMCIA-NIC) [1] stopped working with
> the release of the 2.6.25 kernel (sidux-version),

You are right. My patch has a bug.
The patch below fixes this problem.

By the way,
(1) Does your FA411 work properly with the pcnet_cs driver before?
(2) Please post the full-dmesg (axnet_cs).


--- linux-2.6.28-rc6/drivers/net/pcmcia/pcnet_cs.c.orig	2008-11-21 21:39:08.000000000 +0900
+++ linux-2.6.28-rc6/drivers/net/pcmcia/pcnet_cs.c	2008-11-21 21:39:24.000000000 +0900
@@ -587,7 +587,7 @@ static int pcnet_config(struct pcmcia_de
     }
 
     if ((link->conf.ConfigBase == 0x03c0)
-	&& (link->manf_id == 0x149) && (link->card_id = 0xc1ab)) {
+	&& (link->manf_id == 0x149) && (link->card_id == 0xc1ab)) {
 	printk(KERN_INFO "pcnet_cs: this is an AX88190 card!\n");
 	printk(KERN_INFO "pcnet_cs: use axnet_cs instead.\n");
 	goto failed;


Best Regards
Komuro


> Hi,
> 
> after noticing that my Netgear FA411 (PCMCIA-NIC) [1] stopped working with
> the release of the 2.6.25 kernel (sidux-version), I checked the
> respective driver sources and noticed that the pcnet_cs driver bailed
> out with "use axnet_cs instead" for the Netgear FA411, but axnet_cs
> doesn't claim this ID.
> 
> I compiled a kernel with the PCMCIA-ID for the netgear card moved to
> axnet_cs from pcnet_cs which worked. I then contacted sidux-kernel
> maintainer Stefan Lippers-Hollmann who turned the info into this patch
> and integrated it into the kernel:
> 
> <http://svn.berlios.de/svnroot/repos/fullstory/linux-sidux-2.6/trunk/debian/patches/features/2.6.27.4_PCMCIA_move-PCMCIA-ID-for-Netgear-FA411-from-pcnet_cs-to-axnet_cs.patch>
> 
> This works for me and AFAIK there were no reports of any breakage for
> other devices on sidux-support.
> 
> This looks like a trivial patch, but since I have very limited
> experience with kernel modifications  I might be woefully wrong there.
> But if there are no side effects of this patch, is it possible to get it
> into the official kernel?
> 
> I can provide more detailed information on the affected hardware if
> necessary.
> 
> -cord
> 
> 
> [1]
> Socket 1 Device 0:      [axnet_cs]              (bus ID: 1.0)
>         Configuration:  state: on
>         Product Name:   NETGEAR FA411 Fast Ethernet
>         Identification: manf_id: 0x0149 card_id: 0x0411
>                         function: 6 (network)
>                         prod_id(1): "NETGEAR" (0x9aa79dc3)
>                         prod_id(2): "FA411" (0x40fad875)
>                         prod_id(3): "Fast Ethernet" (0xb4be14e3)
>                         prod_id(4): --- (---)
> -- 
> Cord Walter
> email: cord.walter@gmx.de
> 
> Weil es niemanden etwas angeht, dass ich nichts zu verbergen habe:
> http://www.gnupg.org/
> http://www.truecrypt.org/
> ...und überhaupt: http://www.FreiheitstattAngst.de
> 
> 
> 


-- 
Komuro <komurojun-mbn@nifty.com>
