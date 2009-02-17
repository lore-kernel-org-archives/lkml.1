Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZBQAXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZBQAXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 19:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZBQAWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 19:22:51 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:41952 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZBQAWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 19:22:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EDtTaKCpE/MqvamBR6kRJL7PBGco1smPs/HJqNwGJfk7NFJ90NnZsLyP1dodY1BIGJ
         qYMZSf+JjsqcvmosPfTr6x9n+sbH/KIdRr32w3HOHtRso+0+p9VzMaSU+aQWjfGZlSTQ
         nG6S2uETKeqEtozJtxjf3aC2EjkrUxmUUYToE=
MIME-Version: 1.0
In-Reply-To: <4999F6C8.3050001@sysnux.pf>
References: <4999F6C8.3050001@sysnux.pf>
Date: Mon, 16 Feb 2009 21:22:47 -0300
Message-ID: <82ecf08e0902161622s7180cb0bpaaccc60884bf9688@mail.gmail.com>
Subject: Re: ttyUSB sendbreak problem
From: Thiago Galesi <thiagogalesi@gmail.com>
To: Jean-Denis Girard <jd.girard@sysnux.pf>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And in this case BREAK is which character?? 0x00?

Anyway, take a look at the stty options and man termios (even though
they may do what your IOCTL is doing)

Also explain what's happening exactly: what does "but
> fails using USB to serial adapters" mean.




On Mon, Feb 16, 2009 at 8:29 PM, Jean-Denis Girard <jd.girard@sysnux.pf> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi list,
>
> I'm writing a program which communicates via modem with an embedded
> device (electrical network monitoring). The frames are terminated by a
> BREAK.
>
> My program works fine when I use a Cyclades 8Yo multiports card, but
> fails using USB to serial adapters (tried with pl2303 and FTDI
> converters). I suspect that the BREAK are not passed correctly, but I
> don't have equipment to check.
>
> I've tried with:
>  tcsendbreak(modem,0);
>  ioctl(modem, TCSBRK,0);
>  ioctl(modem, TCSBRKP, 0);
>
> - From pl2303 debug mode, I see that pl2303_break_ctl is called:
>  drivers/usb/serial/pl2303.c: pl2303_break_ctl - port 0
>  drivers/usb/serial/pl2303.c: pl2303_break_ctl - turning break on
>  drivers/usb/serial/pl2303.c: pl2303_write_bulk_callback - port 0
>  drivers/usb/serial/pl2303.c: pl2303_send - port 0
>  drivers/usb/serial/pl2303.c: pl2303_break_ctl - port 0
>  drivers/usb/serial/pl2303.c: pl2303_break_ctl - turning break off
>
> I found a few references of similar problems in the past, but it was for
> older kernels (I'm using 2.6.28.4), so the question remains: should it
> work or is there a known problem sending BREAK using ttyUSB?
>
>
> Thanks,
> - --
> Jean-Denis Girard
>
> SysNux                  Systèmes  Linux  en Polynésie française
> http://www.sysnux.pf/   Tél: +689 50 10 40 / GSM: +689 79 75 27
> -----BEGIN PGP SIGNATURE-----
>
> iEYEARECAAYFAkmZ9sgACgkQuu7Rv+oOo/iFuQCeJSaxikghrQhjS68WKU0Hc//7
> wZQAn2XMnmunfW2avO/uPFQDrw+s9INO
> =AB0j
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
-
Thiago Galesi
