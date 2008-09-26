Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYIZNkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYIZNkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYIZNkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:40:01 -0400
Received: from defg500.nifty.com ([202.248.238.127]:41647 "EHLO
	defg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYIZNkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:40:00 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 09:40:00 EDT
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=q8H41l17VGhVCf2Sy89xpr6uYMT1Kq5cQL1t3hMvMQ8c9BMigVsIgkjofotUTI9m9
	B16qsKQqmBDWpPFGj4x9w==
X-Nifty-SrcIP: [219.116.16.57]
Date: Fri, 26 Sep 2008 22:29:20 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: linux-kernel@vger.kernel.org
Cc: tammy000@gmail.com
Subject: Re: [PATCH git latest] drivers/net: fixing a datarace related to
 update_stats()
Message-Id: <20080926222920.f251696e.komurojun-mbn@nifty.com>
In-Reply-To: <20080923001534.13031535@lxorguk.ukuu.org.uk>
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
	<20080922215617.GA13057@comet.dominikbrodowski.net>
	<20080922231227.2625dd09@lxorguk.ukuu.org.uk>
	<20080922222655.GA3792@isilmar.linta.de>
	<20080923001534.13031535@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

You need two braces...

- 	if ((inw(ioaddr+EL3_STATUS) & 0xe000) == 0x2000)
+ 	if ((inw(ioaddr+EL3_STATUS) & 0xe000) == 0x2000) {
+    	    spin_lock_irqsave(&lp->lock, flags);
 	    update_stats(dev);
+    	    spin_unlock_irqrestore(&lp->lock, flags);
+	}
     }
