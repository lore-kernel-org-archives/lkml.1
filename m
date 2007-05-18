Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbXERSDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbXERSDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbXERSCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:02:53 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3672 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944AbXERSCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:02:51 -0400
Date: Fri, 18 May 2007 13:46:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Eugene Teo <eteo@redhat.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-wireless@vger.kernel.org, Florin Malita <fmalita@gmail.com>
Subject: Re: [2.6 patch] drivers/net/wireless/libertas/rx.c: fix use-after-free
Message-ID: <20070518174623.GA3492@tuxdriver.com>
References: <464DD957.9040803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464DD957.9040803@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First, please send all wireless patches to
linux-wireless@vger.kernel.org, and be sure to CC me as well...thanks!

On Sat, May 19, 2007 at 12:50:31AM +0800, Eugene Teo wrote:
> libertas_upload_rx_packet() calls netif_rx() before returning, and it always return 0.
> Also within libertas_upload_rx_packet(), it will initialize skb->protocol anyways.
> 
> Spotted by the Coverity checker.

A nearly identical patch was posted by Florin Malita <fmalita@gmail.com>
to netdev (also the wrong list) on Wednesday evening.

>  done:
>         LEAVE();
> 
> -       skb->protocol = __constant_htons(0x0019);       /* ETH_P_80211_RAW */
> -

Except for this part...is this intentional?

John
-- 
John W. Linville
linville@tuxdriver.com
