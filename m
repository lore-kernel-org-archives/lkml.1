Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbZDUKKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbZDUKKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbZDUKJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:09:53 -0400
Received: from dns.vivotek.com ([211.21.25.250]:32651 "EHLO edge.vivotek.tw"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755231AbZDUKJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:09:52 -0400
From: <jon.lin@vatics.com>
To: <jianjun@zeuux.org>, <davem@davemloft.net>
CC: <dada1@cosmosbay.com>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Date: Tue, 21 Apr 2009 18:09:46 +0800
Subject: RE: [PATCH 2.6.29.1 1/1] 8139too: fix HW initial flow
Thread-Topic: [PATCH 2.6.29.1 1/1] 8139too: fix HW initial flow
Thread-Index: AcnCZyHOUVlywQYBTzmWYZApFxJICwAAZlWg
Message-ID: <0E04AEADD178614A86F3017CC5FA693B4959924D17@MS.vivotek.tw>
References: <0E04AEADD178614A86F3017CC5FA693B4959924809@MS.vivotek.tw>
 <20090421.015235.23457775.davem@davemloft.net> <20090421094825.GA6752@ubuntu>
In-Reply-To: <20090421094825.GA6752@ubuntu>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
Content-Type: text/plain; charset="big5"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3LAAMqu026652

Dear Sirs,

I am so sorry for my clumsiness!
It is so embarrassed that I can't submit a valid patch...
Thank you all for your incredible patience.
I will try to use mail command in my Linux box to submit it again.
Sorry for these stupid failures.

Regards
  Jonathan


-----Original Message-----
From: Amos Kong [mailto:jianjun@zeuux.org]
Sent: Tuesday, April 21, 2009 5:48 PM
To: David Miller
Cc: Jon.Lin(ªL©v¼w); dada1@cosmosbay.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29.1 1/1] 8139too: fix HW initial flow

...
>> Unfortunately, this address is used by Linux kernel. So kernel panics.
>> This patch fix it by setting up DMA buffer address before RX enabled and everything is fine even under broadcast packets attack.
>>
>> Signed-off-by: Jonathan Lin <jon.lin@vatics.com>
>
>This patch does not apply, it was corrupted by your email client.
>
>I even think it has MS-DOS style newlines in it :-(

Another new patch :)


 While ifconfig eth0 up kernel calls open() of 8139 driver(8139too.c).
 In rtl8139_hw_start() of rtl8139_open(), 8139 driver enable RX before setting up the DMA
 buffer address. In this interval where RX was enabled and DMA buffer address is not yet set
 up, any incoming broadcast packet would be send to a strange physical address:
 0x003e8800 which is the default value of DMA buffer address.
 Unfortunately, this address is used by Linux kernel. So kernel panics.
 This patch fix it by setting up DMA buffer address before RX enabled and everything is fine
 even under broadcast packets attack.

Signed-off-by: Jonathan Lin <jon.lin@vatics.com>
Signed-off-by: Amos Kong <jianjun@zeuux.org>

---
 drivers/net/8139too.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
index 29df398..1fc4543 100644
--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -1383,6 +1383,11 @@ static void rtl8139_hw_start (struct net_device *dev)
        RTL_W32_F (MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr + 0)));
        RTL_W32_F (MAC0 + 4, le16_to_cpu (*(__le16 *) (dev->dev_addr + 4)));

+       tp->cur_rx = 0;
+
+       /* init Rx ring buffer DMA address */
+       RTL_W32_F (RxBuf, tp->rx_ring_dma);
+
        /* Must enable Tx/Rx before setting transfer thresholds! */
        RTL_W8 (ChipCmd, CmdRxEnb | CmdTxEnb);

@@ -1390,8 +1395,6 @@ static void rtl8139_hw_start (struct net_device *dev)
        RTL_W32 (RxConfig, tp->rx_config);
        RTL_W32 (TxConfig, rtl8139_tx_config);

-       tp->cur_rx = 0;
-
        rtl_check_media (dev, 1);

        if (tp->chipset >= CH_8139B) {
@@ -1406,9 +1409,6 @@ static void rtl8139_hw_start (struct net_device *dev)
        /* Lock Config[01234] and BMCR register writes */
        RTL_W8 (Cfg9346, Cfg9346_Lock);

-       /* init Rx ring buffer DMA address */
-       RTL_W32_F (RxBuf, tp->rx_ring_dma);
-
        /* init Tx buffer DMA addresses */
        for (i = 0; i < NUM_TX_DESC; i++)
                RTL_W32_F (TxAddr0 + (i * 4), tp->tx_bufs_dma + (tp->tx_buf[i] - tp->tx_bufs));
--
1.5.6.3


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
