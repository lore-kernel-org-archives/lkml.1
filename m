Return-Path: <linux-kernel-owner+w=401wt.eu-S1762088AbYENILh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762088AbYENILh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761635AbYENIKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:10:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:43024 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760161AbYENIKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=TNwH4lqpEN+SwdKx2MWo8oZiAe3pGGkt9ilDwtYYGJV/Uvynh3a4+WGKjAwIGFT6ANMAQKalUp9sogTh+TKutL3JxX0ROpJDSrVDaKeuTCjbCsrXLymUJIwA1TasMIk5kIpbxv4dSr2LfftXcOwNN7iPgD+1Ht3rfb0HCasYKrA=
Message-ID: <482A9E83.6060703@gmail.com>
Date: Wed, 14 May 2008 10:10:43 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Sylvain Munaut <tnt@246tnt.com>
CC: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] fec_mpc52xx: MPC52xx_MESSAGES_DEFAULT: 2nd NETIF_MSG_IFDOWN
 => IFUP
References: <482A05E7.90204@gmail.com> <482A8DFD.3080805@246tnt.com>
In-Reply-To: <482A8DFD.3080805@246tnt.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sylvain Munaut wrote:
> Roel Kluin wrote:
>> in drivers/net/fec_mpc52xx.c:81 it reads:
>>
>> #define MPC52xx_MESSAGES_DEFAULT ( NETIF_MSG_DRV | NETIF_MSG_PROBE | \
>>                 NETIF_MSG_LINK | NETIF_MSG_IFDOWN | NETIF_MSG_IFDOWN )
>>
>> should this maybe be 
>>
>> NETIF_MSG_IFUP | NETIF_MSG_IFDOWN )
>>
>> ?
>>
>>   
> Yes but I remember seeing a patch for this already ... What kernel
> version / revision do you have ?
> 
> Sylvain

Indeed I already sent the patch, see http://lkml.org/lkml/2008/1/30/252 (my
emailaddress changed), but there was no response and the patch isn't included in
current Linus' git. maybe if you could add your ack?
---
duplicate NETIF_MSG_IFDOWN, 2nd should be NETIF_MSG_IFUP

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/fec_mpc52xx.c b/drivers/net/fec_mpc52xx.c
index 5f9c42e..329edd9 100644
--- a/drivers/net/fec_mpc52xx.c
+++ b/drivers/net/fec_mpc52xx.c
@@ -78,7 +78,7 @@ module_param_array_named(mac, mpc52xx_fec_mac_addr, byte, NULL, 0);
 MODULE_PARM_DESC(mac, "six hex digits, ie. 0x1,0x2,0xc0,0x01,0xba,0xbe");
 
 #define MPC52xx_MESSAGES_DEFAULT ( NETIF_MSG_DRV | NETIF_MSG_PROBE | \
-		NETIF_MSG_LINK | NETIF_MSG_IFDOWN | NETIF_MSG_IFDOWN )
+		NETIF_MSG_LINK | NETIF_MSG_IFDOWN | NETIF_MSG_IFUP)
 static int debug = -1;	/* the above default */
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "debugging messages level");
