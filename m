Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXDIVlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXDIVlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbXDIVlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:41:12 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:40129 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbXDIVko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:40:44 -0400
Date: Mon, 9 Apr 2007 23:33:36 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, cramerj@intel.com, auke-jan.h.kok@intel.com,
       christopher.leech@intel.com
Subject: Re: [PATCH 2/2] NET: Multiqueue network device support implementation.
In-Reply-To: <20070409212841.31670.59366.stgit@gitlost.site>
Message-ID: <Pine.LNX.4.61.0704092332030.22295@yvahk01.tjqt.qr>
References: <20070409212723.31670.27976.stgit@gitlost.site>
 <20070409212841.31670.59366.stgit@gitlost.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Apr 9 2007 14:28, Peter P Waskiewicz Jr wrote:
>@@ -3345,6 +3358,7 @@ void free_netdev(struct net_device *dev)
> {
> #ifdef CONFIG_SYSFS
> 	/*  Compatibility with error handling in drivers */
>+	kfree((char *)dev->egress_subqueue);
> 	if (dev->reg_state == NETREG_UNINITIALIZED) {
> 		kfree((char *)dev - dev->padded);
> 		return;
>@@ -3356,6 +3370,7 @@ void free_netdev(struct net_device *dev)
> 	/* will free via device release */
> 	put_device(&dev->dev);
> #else
>+	kfree((char *)dev->egress_subqueue);
> 	kfree((char *)dev - dev->padded);
> #endif
> }

Ahem. Explain that cast.



Jan
-- 
