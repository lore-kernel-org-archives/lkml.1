Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbZHCNDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbZHCNDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZHCNDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:03:44 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:36913 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbZHCNDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:03:42 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alex Riesen <raa.lkml@gmail.com>
Subject: Re: Oops in CDC ACM after an Openmoko phone (neo1973) changes its usb interface from ACM to Ethernet
Date: Mon, 3 Aug 2009 15:04:19 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       Oliver Neukum <oliver@neukum.name>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <81b0412b0908021339s739c07edvd4d5eb4c21cfa167@mail.gmail.com> <81b0412b0908021409h73fc2fcfo64c4ba9ee1f0d552@mail.gmail.com> <81b0412b0908030217o1e687c2ewf0191687a78d6166@mail.gmail.com>
In-Reply-To: <81b0412b0908030217o1e687c2ewf0191687a78d6166@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200908031504.20506.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n73D3s7T008997

Am Montag, 3. August 2009 11:17:05 schrieb Alex Riesen:> 466Â Â Â Â Â Â Â Â Â Â Â Â Â ep = (usb_pipein(acm->rx_endpoint) ? acm->dev->ep_in :> acm->dev->ep_out)> 467Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â [usb_pipeendpoint(acm->rx_endpoint)];> 468Â Â Â Â Â Â Â Â Â Â Â Â Â if (usb_endpoint_xfer_int(&ep->desc))>> So it looks like ep is NULL (usb_endpoint_xfer_int accesses> desc.bmAttributes, which is 3 bytes off the beginning of struct> usb_host_endpoint (desc being the first field in usb_host_endpoint).
This tells you that the device has been disconnected. The questionis not why this function fails, but why it is called even though thedevice has been disconnected.
	Regards		Oliver
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
