Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZGWRBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZGWRBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZGWRBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:01:05 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:40836 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbZGWRBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=DMP8B3gvUdMTHyuU4ms7qYnooJZUqJEDnydn2n+h/yc6IuophT5FreakxOS/+drmxi
         9L1o4fEnXZH9ON8iYxwBDydN8sI5ysNwzw8A6NHSA4ytEcmumhfhqEw3fb3Ip+J8KQk8
         /hbUTsWJ1wUBHdYhWiSkWOlWnP47z0/n+RQcw=
MIME-Version: 1.0
Date: Thu, 23 Jul 2009 22:25:30 +0530
Message-ID: <cee4bbc90907230955s558123dpe021fa1e7b384068@mail.gmail.com>
Subject: [query] skb alignment in tx path of driver
From: Kalpesh Rathod <kalpeshrathod@gmail.com>
To: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am writing n/w device driver for sdio wifi card. I am testing it on
embedded platform.
DMA controller on the platform is able to xfer data to sdio only if
source data buf address is 4 byte aligned.

The firmware on the card understands 802.3 frames with snap headers.
So, I convert it to the required format in my driver.
4 byte additional header is also attached to this frame and sent over sdio.
This all conversion effectively adds 12 byes to the frame received in
hard_xmit method.

Problem is, frame received in hard_xmit method is 2 byte aligned.
(skb->data is 2 byte aligned). As a result,
after addition of 12 bytes header, skb->data remains 2 byte aligned
instead of 4 byte aligned. And DMA controller refuses
to transfer it.

So, how can I request IP stack so that frame received in hard_xmit is
on 4 byte aligned boundry?

I believe setting NET_IP_ALIGN will only matter in rx path. is this correct?

Thanks in advance.

Regards,
Kalpesh
