Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZK2LhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZK2LhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 06:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZK2LhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 06:37:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:13764 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZK2LhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 06:37:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q/JplzYEYK/skbKXsqzBZJji9E8zcMcgx9ByO5ZBxzo1l8uYunPiwd+T7BUqCgPsD5
         Ewy5ElITKiw7oz4uBuTnkF53/98IXpfmXr8MjhKmX+bfHGEJL24ZJ7ibSY30vBCka/QR
         S3kVk31JEmeUSdpoCCmpUGlxo/9u6kg2/dEpU=
Date: Sun, 29 Nov 2009 12:36:59 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Philippe De Muyter <phdm@macqel.be>
Cc: grundler@parisc-linux.org, kyle@mcmartin.ca, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: tulip : kernel BUG in tulip_up/tulip_resume
Message-ID: <20091129113659.GA2971@ami.dom.local>
References: <20091108223305.GA21072@frolo.macqel>
 <20091129001710.GA4055@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091129001710.GA4055@ami.dom.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 01:17:10AM +0100, Jarek Poplawski wrote:
> Philippe De Muyter wrote, On 11/08/2009 11:33 PM:
> > Does someone know what could be wrong and have a fix or should I look myself ?
> 
> Don't know, guess only...

...And maybe a second guess btw. (to try together or separate).

Jarek P.
---

diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
index 6b2330e..fd32601 100644
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -1749,9 +1749,9 @@ static int tulip_suspend (struct pci_dev *pdev, pm_message_t state)
 	if (!netif_running(dev))
 		goto save_state;
 
+	netif_device_detach(dev);
 	tulip_down(dev);
 
-	netif_device_detach(dev);
 	free_irq(dev->irq, dev);
 
 save_state:
