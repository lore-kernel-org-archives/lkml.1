Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbXF2TvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbXF2TvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 15:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbXF2Tuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 15:50:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44589 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752323AbXF2Tuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 15:50:54 -0400
Date: Fri, 29 Jun 2007 21:51:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linville@tuxdriver.com, Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: drivers/net/wireless/libertas/rx.c: use-after-free
Message-ID: <20070629195116.GG6087@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following use-after-free of "skb" in 
drivers/net/wireless/libertas/rx.c introduced by
commit 9012b28a407511fb355f6d2176a12d4653489672 (WTF did this commit
with the title "libertas: make debug configurable" add the 
"skb->protocol = __constant_htons(0x0019);" line?):

<--  snip  -->

...
static int process_rxed_802_11_packet(wlan_private * priv, struct sk_buff *skb)
{
...
        libertas_upload_rx_packet(priv, skb);

        ret = 0;

done:
        skb->protocol = __constant_htons(0x0019);       /* ETH_P_80211_RAW */
...

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

