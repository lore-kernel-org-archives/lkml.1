Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZK2ARP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZK2ARP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 19:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbZK2ARO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 19:17:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:41044 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZK2ARN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 19:17:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=NC7aoirJ4f7Cn1oYgjI4QHvkmfyPFhTckUrGgGV6diufRTEwDgPnTcIKo/DFdv2u7a
         g9akyiM6m1v+cQxmpu7ckObVvIusYCSX2EjvfSiKCdIVEq9yFITQIunDGAUYGmlOER0T
         fYKwGwZ7rgRWvEe0CDy+os1FgD6j5/RuLjhII=
Date: Sun, 29 Nov 2009 01:17:10 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Philippe De Muyter <phdm@macqel.be>
Cc: grundler@parisc-linux.org, kyle@mcmartin.ca, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: tulip : kernel BUG in tulip_up/tulip_resume
Message-ID: <20091129001710.GA4055@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108223305.GA21072@frolo.macqel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote, On 11/08/2009 11:33 PM:

> Hello,
> 
> I have just installed 2.6.31 (from opensuse 11.2) one a tulip-equipped
> computer and I get the following error message from the kernel :
> 
> [ 2495.526390] ------------[ cut here ]------------
> [ 2495.526390] kernel BUG at /usr/src/packages/BUILD/kernel-default-2.6.31.5/linux-2.6.31/include/linux/netdevice.h:439!
> [ 2495.526390] invalid opcode: 0000 [#1] SMP 
...
> This comes from a BUG_ON in napi_enable in netdevice.h.
> 
> napi_enable itself is called by tulip_up as such :
> 
> #ifdef CONFIG_TULIP_NAPI
> 	napi_enable(&tp->napi);
> #endif
> 
> At first reading, a matching napi_disable is called in tulip_down.
> 
> Does someone know what could be wrong and have a fix or should I look myself ?

Don't know, guess only...

Jarek P.
---

 drivers/net/tulip/tulip_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
index 0df983b..6b1456c 100644
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -1787,11 +1787,11 @@ static int tulip_resume(struct pci_dev *pdev)
 		return retval;
 	}
 
-	netif_device_attach(dev);
-
 	if (netif_running(dev))
 		tulip_up(dev);
 
+	netif_device_attach(dev);
+
 	return 0;
 }
 
