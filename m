Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZJ1Bio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZJ1Bio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 21:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbZJ1Bin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 21:38:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:33587 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686AbZJ1Bin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 21:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=Xdxk6QDLAsJMIcxcxqWqqtct8pOdVBGVrUlMHr9Ncj2bnSgPXcT97q6u3hYKt5DNr5
         vXQu0mrJAksNrPSCzYa1wN9VLJX8l/CVqHQyyAKSi36sWHhznp1wD7ycK37dy9nSkVgx
         tiADvw7CHVDsb535yBgWa5VIkyB7uoJqOYQBg=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] 2.6.32-rc5 bug in Palm Tungsten C keyboard
Date: Wed, 28 Oct 2009 02:37:40 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.30-2-amd64; KDE/4.3.2; x86_64; ; )
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
References: <20091026225930.GA18723@localhost> <f17812d70910270043q328ab091mb1d76760e674450d@mail.gmail.com>
In-Reply-To: <f17812d70910270043q328ab091mb1d76760e674450d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910280237.40268.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Út 27. října 2009 08:43:44 Eric Miao napsal(a):
> On Tue, Oct 27, 2009 at 6:59 AM, Ondrej Zajicek <santiago@crfreenet.org> 
wrote:
> > Palm Tungsten C keyboard structure has swapped
> > rows/cols gpio structures and does not work.
> > This patch fixes it.
> >
> > Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
> 
> This fix looks obvious to me. Applied to 'fix'.

Just wondering ... you checked the GPIO directions, right ? I mean, it works in 
both directions, it just works worse the other one. I can't really check now.

Also, it'll be possibly good to use the following emails for pxa patches:
Eric Miao <eric.y.miao@gmail.com>
Linux-ARM-Kernel <linux-arm-kernel@lists.infradead.org>
Marek Vasut <marek.vasut@gmail.com>

Those should be enough.

Cheers!
> 
> > diff -uprN linux-2.6.32-rc5-old/arch/arm/mach-pxa/palmtc.c
> > linux-2.6.32-rc5/arch/arm/mach-pxa/palmtc.c ---
> > linux-2.6.32-rc5-old/arch/arm/mach-pxa/palmtc.c     2009-10-16
> > 02:41:50.000000000 +0200 +++ linux-2.6.32-rc5/arch/arm/mach-pxa/palmtc.c
> > 2009-10-26 20:56:44.000000000 +0100 @@ -292,10 +292,10 @@ const static
> > unsigned int palmtc_keypad_
> >
> >  static struct matrix_keypad_platform_data palmtc_keypad_platform_data =
> > { .keymap_data    = &palmtc_keymap_data,
> > -       .col_gpios      = palmtc_keypad_row_gpios,
> > -       .num_col_gpios  = 12,
> > -       .row_gpios      = palmtc_keypad_col_gpios,
> > -       .num_row_gpios  = 4,
> > +       .row_gpios      = palmtc_keypad_row_gpios,
> > +       .num_row_gpios  = ARRAY_SIZE(palmtc_keypad_row_gpios),
> > +       .col_gpios      = palmtc_keypad_col_gpios,
> > +       .num_col_gpios  = ARRAY_SIZE(palmtc_keypad_col_gpios),
> >        .active_low     = 1,
> >
> >        .debounce_ms            = 20,
> >
> >
> > --
> > Elen sila lumenn' omentielvo
> >
> > Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
> > OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
> > "To err is human -- to blame it on a computer is even more so."
> 
