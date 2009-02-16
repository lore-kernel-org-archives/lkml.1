Return-Path: <linux-kernel-owner+w=401wt.eu-S1751706AbZBPROV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbZBPROV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 12:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZBPROI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 12:14:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:57764 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZBPROG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:14:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=xWIaAbBhzVBGtahvf9JYpRZlIJjMNcGvS5PNOYNXwNlE9EPwsQYoP8zcI8YlATUQU/
         XZyKSDK4z0mGd5WcN5AulrWDT58aU+06fgOhjxdMtQWeRQ1pcQGJKVB1QDC1nDCbIdnE
         0RvX3O4muucmWh7iLLwzOzaIx/pxtuWsuTIJ0=
MIME-Version: 1.0
Date: Mon, 16 Feb 2009 18:14:04 +0100
Message-ID: <b0438a630902160914x9df1277x31cc8cf88a72a31d@mail.gmail.com>
Subject: ixp4xx_hss with 2x4 HDLC: Receiving data OK, but problem in 
	netif_receive_skb
From: =?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?= <gotzoncabanes@gmail.com>
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
       ma.alvarez@ziv.es
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi to all.

I have finally been able to complete a successfull bidirectional
transmission using my modifications to Krzysztof Halasa's ixp4xx_hss
driver supporting four HDLC channels for each HSS.

My last problem is that I am not able to send the received data to the
network interface.

Inside hss_hdlc_poll, once the data is received, it is send to the
network system using netif_receive_skb. This function, however is
returning NET_RX_DROP for me. I have analyse this function, and I am
not quite sure of the problem... Taking a look to net/core/dev.c, it
reaches the following line:

"ret = pt_prev->func(skb, skb->dev, pt_prev, orig_dev);"

I suppose this line should return NET_RX_SUCCESS instead of
NET_RX_DROP, but I am not sure which function (func is a function
pointer I suppose) are we calling.

Is my analysis correct?

Thanks to all

Miguel Ángel Álvarez
