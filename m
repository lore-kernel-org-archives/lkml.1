Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZFEWqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZFEWqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZFEWqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:46:39 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43351 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZFEWqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:46:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=S7b+D0FluT+IAfglA471lBk0XZ7ySnUcjxjmUZUR9q5mqC/3DsmcL4TgpahOEOX1uc
         gmnBheyU52FXb4moxPQ5XySWhGFP2p89sXZGFFGtx/2c8PvlHq1MFRJ4d7IHeV9+UjEx
         jqwFSviZzYnQckAvzukuWxvESPp20ZmY+TbXU=
Message-ID: <4A29A047.2020600@gmail.com>
Date: Sat, 06 Jun 2009 04:16:31 +0530
From: Pranith Kumar <pranith.hacks@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Testing email client patch submission
References: <4A28BA43.5000005@gmail.com> <4A293318.10304@oracle.com>
In-Reply-To: <4A293318.10304@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
>> Documentation/email-clients.txt recommends against format=flowed.
>> It could be causing your problems.
>>
>>     

Thanks Randy, I changed my format type to not use flowed. Testing it now :)

Signed-off-by: D Pranith Kumar <bobby.prani@gmail.com>

diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
index ce04218..5e8bd94 100644
--- a/drivers/staging/otus/ioctl.c
+++ b/drivers/staging/otus/ioctl.c
@@ -2045,6 +2045,7 @@ int usbdrv_wpa_ioctl(struct net_device *dev,
struct athr_wlan_param *zdparm)
    struct zsKeyInfo keyInfo;
    struct usbdrv_private *macp = dev->ml_priv;
    u16_t vapId = 0;
+    int ii;

    /* zmw_get_wlan_dev(dev); */

@@ -2168,7 +2169,6 @@ int usbdrv_wpa_ioctl(struct net_device *dev,
struct athr_wlan_param *zdparm)
        /* DUMP key context */
        /* #ifdef WPA_DEBUG */
        if (keyInfo.keyLength > 0) {
-            int ii;
            printk(KERN_WARNING
                        "Otus: Key Context:\n");
            for (ii = 0; ii < keyInfo.keyLength; ) {
@@ -2266,7 +2266,6 @@ int usbdrv_wpa_ioctl(struct net_device *dev,
struct athr_wlan_param *zdparm)
        /* zfiWlanSetWpaIe(dev, zdparm->u.generic_elem.data,
        * zdparm->u.generic_elem.len);
        */
-        int ii;
        u8_t len = zdparm->u.generic_elem.len;
        u8_t *wpaie = (u8_t *)zdparm->u.generic_elem.data;

@@ -2401,7 +2400,7 @@ int usbdrv_ioctl(struct net_device *dev, struct
ifreq *ifr, int cmd)
    struct athr_wlan_param zdparm;
    struct usbdrv_private *macp = dev->ml_priv;

-    int err = 0;
+    int err = 0, val = 0;
    int changed = 0;

    /* regp = macp->regp; */
@@ -2445,7 +2444,7 @@ int usbdrv_ioctl(struct net_device *dev, struct
ifreq *ifr, int cmd)
            err = -EPERM;
            break;
        }
-        int val = *((int *) wrq->u.name);
+       val = *((int *) wrq->u.name);
        if ((val < 0) || (val > 2)) {
            err = -EINVAL;
            break;
diff --git a/drivers/staging/rt2860/common/ba_action.c
b/drivers/staging/rt2860/common/ba_action.c
index 591d1e2..befd8bd 100644
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -1512,7 +1512,7 @@ void
convert_reordering_packet_to_preAMSDU_or_802_3_packet(
    RTPKT_TO_OSPKT(pRxPkt)->dev = get_netdev_from_bssid(pAd,
FromWhichBSSID);
    RTPKT_TO_OSPKT(pRxPkt)->data = pRxBlk->pData;
    RTPKT_TO_OSPKT(pRxPkt)->len = pRxBlk->DataSize;
-    RTPKT_TO_OSPKT(pRxPkt)->tail = RTPKT_TO_OSPKT(pRxPkt)->data +
RTPKT_TO_OSPKT(pRxPkt)->len;
+    RTPKT_TO_OSPKT(pRxPkt)->tail = (UCHAR *)
(RTPKT_TO_OSPKT(pRxPkt)->data + RTPKT_TO_OSPKT(pRxPkt)->len);

    //
    // copy 802.3 header, if necessary
diff --git a/drivers/staging/rt2860/rt_linux.c
b/drivers/staging/rt2860/rt_linux.c
index f3c128c..36ffb97 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -607,7 +607,7 @@ PNDIS_PACKET ClonePacket(
        pClonedPkt->dev = pRxPkt->dev;
        pClonedPkt->data = pData;
        pClonedPkt->len = DataSize;
-        pClonedPkt->tail = pClonedPkt->data + pClonedPkt->len;
+       pClonedPkt->tail = (UCHAR *) (pClonedPkt->data + pClonedPkt->len);
        ASSERT(DataSize < 1530);
    }
    return pClonedPkt;
@@ -629,7 +629,7 @@ void  update_os_packet_info(
    pOSPkt->dev = get_netdev_from_bssid(pAd, FromWhichBSSID);
    pOSPkt->data = pRxBlk->pData;
    pOSPkt->len = pRxBlk->DataSize;
-    pOSPkt->tail = pOSPkt->data + pOSPkt->len;
+    pOSPkt->tail = (UCHAR *) (pOSPkt->data + pOSPkt->len);
}


@@ -649,7 +649,7 @@ void wlan_802_11_to_802_3_packet(
    pOSPkt->dev = get_netdev_from_bssid(pAd, FromWhichBSSID);
    pOSPkt->data = pRxBlk->pData;
    pOSPkt->len = pRxBlk->DataSize;
-    pOSPkt->tail = pOSPkt->data + pOSPkt->len;
+    pOSPkt->tail = (UCHAR *) (pOSPkt->data + pOSPkt->len);

    //
    // copy 802.3 header
diff --git a/drivers/staging/slicoss/slicoss.c
b/drivers/staging/slicoss/slicoss.c
index 6f5d0bf..43bdd9d 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1872,7 +1872,7 @@ static int slic_card_download(struct adapter
*adapter)
    __iomem struct slic_regs *slic_regs = adapter->slic_regs;
    u32 instruction;
    u32 baseaddress;
-    u32 failure;
+    /* u32 failure; */
    u32 i;
    u32 numsects = 0;
    u32 sectsize[3];
diff --git a/drivers/staging/sxg/sxg.c b/drivers/staging/sxg/sxg.c
index 076b3f7..30bbf76 100644
--- a/drivers/staging/sxg/sxg.c
+++ b/drivers/staging/sxg/sxg.c
@@ -2150,7 +2150,7 @@ void sxg_set_interrupt_aggregation(struct
adapter_t *adapter)
static int sxg_entry_open(struct net_device *dev)
{
    struct adapter_t *adapter = (struct adapter_t *) netdev_priv(dev);
-    int status;
+    int status = STATUS_FAILURE;
    static int turn;
    int sxg_initial_rcv_data_buffers = SXG_INITIAL_RCV_DATA_BUFFERS;
    int i;


