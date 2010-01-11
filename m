Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555Ab0AKIZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0AKIZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187Ab0AKIZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:25:05 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:53754 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0AKIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:25:05 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Steven Xu <linuxkernel.xxz@gmail.com>, linux-usb@vger.kernel.org
Subject: Re: A QUESTION ABOUT USB DRIVER
Date: Mon, 11 Jan 2010 09:25:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1fd295ee1001102114p1b74336q16bb35d973b40c1c@mail.gmail.com>
In-Reply-To: <1fd295ee1001102114p1b74336q16bb35d973b40c1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001110925.53711.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 11. Januar 2010 06:14:31 schrieb Steven Xu:
> output: usb 1-1: device descriptor read/64, error -71
> 
> 
> in drivers/usb/core/hub.c  line 2250
> when a udisk inserted run to here
>                         for (j = 0; j < 3; ++j) {
>                                 buf->bMaxPacketSize0 = 0;
> 
>                                 r = usb_control_msg(udev, usb_rcvaddr0pipe(),
>                                         USB_REQ_GET_DESCRIPTOR, USB_DIR_IN,
>                                         USB_DT_DEVICE << 8, 0,
>                                         buf, GET_DESCRIPTOR_BUFSIZE,
>                                         (i ? USB_CTRL_GET_TIMEOUT : 1000));
>  return r=-74,
> 
> WHAT IS THE POSSIBEL REASON FOR THIS?
> THANKS!

This is -EPROTO. It means that a low level error on the wire happened,
for example a device sent a malformed package. This is a very unspecific
error.

	HTH
		Oliver
