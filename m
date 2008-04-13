Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYDMRXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYDMRXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYDMRXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:23:13 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:26715 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751851AbYDMRXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:23:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PDIskKHl4bLI3jwnHa0oM4hhX1JLzim8rSkSljD/BXcpHRZZANbfPvpmFhT0QrtiCAZ5YCB5ae0T91jFyHr1+u8DG0l2lGKAHnV3voM3Clup4LmYreEjjz2blLsLZQCMNs/5RqsmXTOKCZSrU+l8gSqaOeYOqf1dp3Uhr8/O194=  ;
X-YMail-OSG: g.qxh1kVM1l3I3zgxUfcG6FdqcOO27rZIOsS81Ws4j3i6yluKikglqZeAnDzgR9dVxVsKjHcb2VawtcqZiobqEEabiEgjYTbxlD3kYQwQ4Zpkvfg99GkDFBGTPFRbg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] usb gadget: switch to put_char returning int
Date: Sun, 13 Apr 2008 10:21:42 -0700
User-Agent: KMail/1.9.6
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20080413180818.519e446c@core>
In-Reply-To: <20080413180818.519e446c@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804131021.42340.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 April 2008, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@redhat.com>

ACK.

> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/usb/gadget/serial.c linux-2.6.25-rc8-mm2/drivers/usb/gadget/serial.c
> --- linux.vanilla-2.6.25-rc8-mm2/drivers/usb/gadget/serial.c	2008-04-13 15:36:54.000000000 +0100
> +++ linux-2.6.25-rc8-mm2/drivers/usb/gadget/serial.c	2008-04-13 15:41:09.000000000 +0100
> @@ -170,7 +170,7 @@
>  static void gs_close(struct tty_struct *tty, struct file *file);
>  static int gs_write(struct tty_struct *tty,
>  	const unsigned char *buf, int count);
> -static void gs_put_char(struct tty_struct *tty, unsigned char ch);
> +static int gs_put_char(struct tty_struct *tty, unsigned char ch);
>  static void gs_flush_chars(struct tty_struct *tty);
>  static int gs_write_room(struct tty_struct *tty);
>  static int gs_chars_in_buffer(struct tty_struct *tty);
> @@ -883,14 +883,15 @@
>  /*
>   * gs_put_char
>   */
> -static void gs_put_char(struct tty_struct *tty, unsigned char ch)
> +static int gs_put_char(struct tty_struct *tty, unsigned char ch)
>  {
>  	unsigned long flags;
>  	struct gs_port *port = tty->driver_data;
> +	int ret = 0;
>  
>  	if (port == NULL) {
>  		pr_err("gs_put_char: NULL port pointer\n");
> -		return;
> +		return 0;
>  	}
>  
>  	gs_debug("gs_put_char: (%d,%p) char=0x%x, called from %p\n",
> @@ -910,10 +911,11 @@
>  		goto exit;
>  	}
>  
> -	gs_buf_put(port->port_write_buf, &ch, 1);
> +	ret = gs_buf_put(port->port_write_buf, &ch, 1);
>  
>  exit:
>  	spin_unlock_irqrestore(&port->port_lock, flags);
> +	return ret;
>  }
>  
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


