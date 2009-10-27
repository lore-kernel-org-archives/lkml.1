Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZJ0HoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZJ0HoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZJ0HoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:44:01 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:47635 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbZJ0HoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Z1wrMv9zIOP+VYSToxCQPSlC5oBYcBY7UZCxu0xjYjAjBhTLgOWMhSdzrL7TVLse84
         GZ4pUMXGY+SGx+h6PLOShgXkyIFXga+IIUmbgLm/Cvb4Jrets8/TMeJvwkLczFjF4rOm
         u+rllLx9mN/LlqHV32yUXZCS5yxtWXg1WJM9g=
MIME-Version: 1.0
In-Reply-To: <20091026225930.GA18723@localhost>
References: <20091026225930.GA18723@localhost>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 27 Oct 2009 15:43:44 +0800
Message-ID: <f17812d70910270043q328ab091mb1d76760e674450d@mail.gmail.com>
Subject: Re: [PATCH] 2.6.32-rc5 bug in Palm Tungsten C keyboard
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       marek.vasut@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 6:59 AM, Ondrej Zajicek <santiago@crfreenet.org> wrote:
> Palm Tungsten C keyboard structure has swapped
> rows/cols gpio structures and does not work.
> This patch fixes it.
>
> Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>

This fix looks obvious to me. Applied to 'fix'.

>
> diff -uprN linux-2.6.32-rc5-old/arch/arm/mach-pxa/palmtc.c linux-2.6.32-rc5/arch/arm/mach-pxa/palmtc.c
> --- linux-2.6.32-rc5-old/arch/arm/mach-pxa/palmtc.c     2009-10-16 02:41:50.000000000 +0200
> +++ linux-2.6.32-rc5/arch/arm/mach-pxa/palmtc.c 2009-10-26 20:56:44.000000000 +0100
> @@ -292,10 +292,10 @@ const static unsigned int palmtc_keypad_
>
>  static struct matrix_keypad_platform_data palmtc_keypad_platform_data = {
>        .keymap_data    = &palmtc_keymap_data,
> -       .col_gpios      = palmtc_keypad_row_gpios,
> -       .num_col_gpios  = 12,
> -       .row_gpios      = palmtc_keypad_col_gpios,
> -       .num_row_gpios  = 4,
> +       .row_gpios      = palmtc_keypad_row_gpios,
> +       .num_row_gpios  = ARRAY_SIZE(palmtc_keypad_row_gpios),
> +       .col_gpios      = palmtc_keypad_col_gpios,
> +       .num_col_gpios  = ARRAY_SIZE(palmtc_keypad_col_gpios),
>        .active_low     = 1,
>
>        .debounce_ms            = 20,
>
>
> --
> Elen sila lumenn' omentielvo
>
> Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
> OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
> "To err is human -- to blame it on a computer is even more so."
>
