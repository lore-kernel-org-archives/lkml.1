Return-Path: <linux-kernel-owner+w=401wt.eu-S1765013AbYHHW1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765013AbYHHW1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761627AbYHHW1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:27:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:1486 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764718AbYHHW07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:26:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=P2o/zklXNDEYBGbw2Wfzh0d44L6yktyZqcTu1CxJ2qOTwgqROD/71bYWJLCj0XSUMv
         RwCHjivvLqTeoyfT+2h1jUiLwmaGSYAdF14MZHHF6o8xE7Kyox6euCMqnoVg4/V2dpEE
         IwSJngA0j7sDf0jgzIa/y5f0mllz0AmVONNEk=
Message-ID: <489D1CA3.80504@gmail.com>
Date: Sat, 09 Aug 2008 00:27:15 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: yanivr@broadcom.com, eilong@broadcom.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] bnx2x: precedence confusion !x & y
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

! has a higher precedence than &

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/bnx2x_main.c b/drivers/net/bnx2x_main.c
index af251a5..272a4bd 100644
--- a/drivers/net/bnx2x_main.c
+++ b/drivers/net/bnx2x_main.c
@@ -7202,7 +7202,7 @@ static void __devinit bnx2x_link_settings_requested(struct bnx2x *bp)
 	bp->link_params.req_flow_ctrl = (bp->port.link_config &
 					 PORT_FEATURE_FLOW_CONTROL_MASK);
 	if ((bp->link_params.req_flow_ctrl == FLOW_CTRL_AUTO) &&
-	    (!bp->port.supported & SUPPORTED_Autoneg))
+	    !(bp->port.supported & SUPPORTED_Autoneg))
 		bp->link_params.req_flow_ctrl = FLOW_CTRL_NONE;
 
 	BNX2X_DEV_INFO("req_line_speed %d  req_duplex %d  req_flow_ctrl 0x%x"
