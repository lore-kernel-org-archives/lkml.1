Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZJYTx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZJYTx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 15:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZJYTxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 15:53:55 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:57092 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbZJYTxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 15:53:54 -0400
From: Oliver Neukum <oliver@neukum.org>
To: bart.hartgers@gmail.com
Subject: Re: [PATCH 2/7] ark3116: (3rd try) Make existing functions 16450-aware and add close and release functions.
Date: Sun, 25 Oct 2009 20:56:03 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091025175057.270011110@gmail.com> <20091025175318.709056986@gmail.com>
In-Reply-To: <20091025175318.709056986@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Disposition: inline
Message-Id: <200910252056.03993.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n9PJsB16029120

Am Sonntag, 25. Oktober 2009 18:50:59 schrieb bart.hartgers@gmail.com:> +static void ark3116_close(struct usb_serial_port *port)> +{> +       struct usb_serial *serial = port->serial;>  > -       /* TEST ARK3116_SND(154, 0xFE, 0x40, 0xFFFF, 0x0006); */> +       /* disable DMA */> +       ark3116_write_reg(serial, UART_FCR, 0);>  > -       kfree(buf);> +       /* deactivate interrupts */> +       ark3116_write_reg(serial, UART_IER, 0);>  > -       return;> +       if (serial->dev) {> +               /* shutdown any bulk reads that might be going on */> +               if (serial->num_bulk_out)> +                       usb_kill_urb(port->write_urb);> +               if (serial->num_bulk_in)> +                       usb_kill_urb(port->read_urb);> +               if (serial->num_interrupt_in)> +                       usb_kill_urb(port->interrupt_in_urb);> +       }>  }
Why are the killings done on condition of serial-> != NULL but the registersare set unconditionally?
	Regards		Oliver
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
