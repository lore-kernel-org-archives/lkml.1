Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZKCJBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZKCJBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZKCJBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:01:41 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:43596 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZKCJBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:01:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PfFExRSk6T3O8CK9DDMNbqykMoaX00ekRBOTJLajPXNzm6G7yzlGN60/cMaFUI1nGi
         ZsouMDbBSOxfwep/qZa/y5ZqgXg/iU1Me+lhy4f06XrvHGACpRpyN3QFg1uOhDb8Q9Lt
         TDYkY9BdCN/5esokbu0n0+R5rEL49XI5nghAY=
MIME-Version: 1.0
In-Reply-To: <1256940813-11610-1-git-send-email-gregkh@suse.de>
References: <20091030220949.GD11297@kroah.com>
	 <1256940813-11610-1-git-send-email-gregkh@suse.de>
Date: Tue, 3 Nov 2009 10:01:42 +0100
X-Google-Sender-Auth: 8e30d61b83b940d2
Message-ID: <10f740e80911030101ka895b11ie3e02a39762f5e97@mail.gmail.com>
Subject: Re: [PATCH 1/1] tty: Mark generic_serial users as BROKEN
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, stable <stable@kernel.org>,
       linux-m68k <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 23:13, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> From: Alan Cox <alan@linux.intel.com>
>
> There isn't much else I can do with these. I can find no hardware for any
> of them and no users. The code is broken.

Can you please also mention in the changelog what exactly is broken?

BTW, in response to your patch I received (private) email from people
who actually
have m68k MVME boards in active use. So marking it broken may be
called a regression...

Thanks!

> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Cc: stable <stable@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  arch/m68k/Kconfig    |    6 +++---
>  drivers/char/Kconfig |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
> index 29dd848..ecdc19a 100644
> --- a/arch/m68k/Kconfig
> +++ b/arch/m68k/Kconfig
> @@ -561,7 +561,7 @@ config HPAPCI
>
>  config MVME147_SCC
>        bool "SCC support for MVME147 serial ports"
> -       depends on MVME147
> +       depends on MVME147 && BROKEN
>        help
>          This is the driver for the serial ports on the Motorola MVME147
>          boards.  Everyone using one of these boards should say Y here.
> @@ -576,14 +576,14 @@ config SERIAL167
>
>  config MVME162_SCC
>        bool "SCC support for MVME162 serial ports"
> -       depends on MVME16x
> +       depends on MVME16x && BROKEN
>        help
>          This is the driver for the serial ports on the Motorola MVME162 and
>          172 boards.  Everyone using one of these boards should say Y here.
>
>  config BVME6000_SCC
>        bool "SCC support for BVME6000 serial ports"
> -       depends on BVME6000
> +       depends on BVME6000 && BROKEN
>        help
>          This is the driver for the serial ports on the BVME4000 and BVME6000
>          boards from BVM Ltd.  Everyone using one of these boards should say
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 08a6f50..6aad99e 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -323,7 +323,7 @@ config SPECIALIX
>
>  config SX
>        tristate "Specialix SX (and SI) card support"
> -       depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
> +       depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA) && BROKEN
>        help
>          This is a driver for the SX and SI multiport serial cards.
>          Please read the file <file:Documentation/serial/sx.txt> for details.
> @@ -334,7 +334,7 @@ config SX
>
>  config RIO
>        tristate "Specialix RIO system support"
> -       depends on SERIAL_NONSTANDARD
> +       depends on SERIAL_NONSTANDARD && BROKEN
>        help
>          This is a driver for the Specialix RIO, a smart serial card which
>          drives an outboard box that can support up to 128 ports.  Product
> @@ -395,7 +395,7 @@ config NOZOMI
>
>  config A2232
>        tristate "Commodore A2232 serial support (EXPERIMENTAL)"
> -       depends on EXPERIMENTAL && ZORRO && BROKEN_ON_SMP
> +       depends on EXPERIMENTAL && ZORRO && BROKEN
>        ---help---
>          This option supports the 2232 7-port serial card shipped with the
>          Amiga 2000 and other Zorro-bus machines, dating from 1989.  At

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
