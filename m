Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbYKBKik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbYKBKik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 05:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYKBKib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 05:38:31 -0500
Received: from userg500.nifty.com ([202.248.238.80]:60364 "EHLO
	userg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYKBKia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 05:38:30 -0500
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=WYxISEHL8I/IauMYYl/P74M74FtULo4wUNkssRVl4bDrB6us4Bevef649lzYoijAE
	CGO1wjZuZX7zO6zWjRUTg==
X-Nifty-SrcIP: [219.116.17.201]
Date: Sun, 2 Nov 2008 19:33:24 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       torvalds@osdl.org, linux-pcmcia@lists.infradead.org
Subject: Re: [BUG REPORT!!!] [PATCH 19/49] pcmcia: remove remaining
 in-kernel pcmcia_get_configuration_info() users
Message-Id: <20081102193324.86f0d4a3.komurojun-mbn@nifty.com>
In-Reply-To: <20081102091756.GA25322@isilmar.linta.de>
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
	<20080922215617.GA13057@comet.dominikbrodowski.net>
	<20080922231227.2625dd09@lxorguk.ukuu.org.uk>
	<20080922222655.GA3792@isilmar.linta.de>
	<20081101110746.41733076.komurojun-mbn@nifty.com>
	<20081102174622.02500138.komurojun-mbn@nifty.com>
	<20081102091756.GA25322@isilmar.linta.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/pcmcia/ds.c

setup "io" and "irq" for pseudo multifunction devices.

Signed-off-by: Komuro <komurojun-mbn@nifty.com>

---


--- linux-2.6.28-rc2/drivers/pcmcia/ds.c.orig	2008-11-01 08:59:13.000000000 +0900
+++ linux-2.6.28-rc2/drivers/pcmcia/ds.c	2008-11-02 18:59:18.000000000 +0900
@@ -668,6 +668,8 @@ struct pcmcia_device * pcmcia_device_add
         list_for_each_entry(tmp_dev, &s->devices_list, socket_device_list)
                 if (p_dev->func == tmp_dev->func) {
 			p_dev->function_config = tmp_dev->function_config;
+			p_dev->io = tmp_dev->io;
+			p_dev->irq = tmp_dev->irq;
 			kref_get(&p_dev->function_config->ref);
 		}
 
