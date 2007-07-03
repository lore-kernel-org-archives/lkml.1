Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbXGCGH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbXGCGH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXGCGHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 02:07:48 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:54209 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbXGCGHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 02:07:48 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Ondrej Zary <linux@rainbow-software.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] [resend] IRTOUCHSYSTEMS support for usbtouchscreen
Date: Tue, 3 Jul 2007 08:07:46 +0200
User-Agent: KMail/1.9.7
Cc: daniel.ritz@gmx.ch, linux-kernel@vger.kernel.org
References: <200707022319.57322.linux@rainbow-software.org>
In-Reply-To: <200707022319.57322.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707030807.46630.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 2. Juli 2007 schrieb Ondrej Zary:
> + * IRTOUCH Part
> + */
> +#ifdef CONFIG_TOUCHSCREEN_USB_IRTOUCH
> +static int irtouch_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
> +{
> +       dev->x = (pkt[3] << 8) | pkt[2];
> +       dev->y = (pkt[5] << 8) | pkt[4];
> +       dev->touch = (pkt[1] & 0x03) ? 1 : 0;
> +
> +       return 1;
> +}
> +#endif
> +

Your description says the higher order byte comes first.
And could you use le16_to_cpu() rsp. be16_to_cpu() to read the values?
It is easier to read.

	Regards
		Oliver
