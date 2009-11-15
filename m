Return-Path: <linux-kernel-owner+w=401wt.eu-S1751767AbZKOGTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbZKOGTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 01:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZKOGTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 01:19:20 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:60517 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZKOGTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 01:19:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wj0SkU1yFLtaRw8QfeG6WUkD+6Y+6kXih9b54WhsrtbxipD2Jk6usVM/dXIDaxiI4A
         aTQumOOeEdnoHJ676nLRQZMOjQ88WaPWtMv0IDrcEHSrAlroBnRDxSdoc+ZwwnhBuddx
         PgbvEqwQSgGtDBUC7qvszlPj+lkh/0XsEBlJw=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0911082103000.8143@ask.diku.dk>
References: <cover.1257602781.git.andre.goddard@gmail.com> 
	<7d5883637aa976b54e944998f635d47a41618a75.1257602781.git.andre.goddard@gmail.com> 
	<20091108184722.GA1647@mit.edu> <Pine.LNX.4.64.0911082103000.8143@ask.diku.dk>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 15 Nov 2009 04:19:04 -0200
Message-ID: <b8bf37780911142219qf46108eo1427891ce0c2800a@mail.gmail.com>
Subject: Re: [PATCH v4 12/12] tree-wide: convert open calls to remove spaces 
	to skip_spaces() lib function
To: Julia Lawall <julia@diku.dk>
Cc: linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[stripped very long cc: line]

On Sun, Nov 8, 2009 at 6:23 PM, Julia Lawall <julia@diku.dk> wrote:
>> > Also, while at it, if we see (*str && isspace(*str)), we can be sure to
>> > remove the first condition (*str) as the second one (isspace(*str)) also
>> > evaluates to 0 whenever *str == 0, making it redundant. In other words,
>> > "a char equals zero is never a space".
>
> I tried the following semantic patch (http://coccinelle.lip6.fr), and got
> the results below.
>
> @@
> expression str;
> @@
>
> ( // ignore skip_spaces cases
>  while (*str &&  isspace(*str)) { \(str++;\|++str;\) }
> |
> - *str &&
>  isspace(*str)
> )
>
> I haven't checked the results in any way, however.
>
> julia
>

Hi, Julia!

    Your patch looks good, but it conflicted at the following files
when I tried to apply it:

> diff -u -p a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
> diff -u -p a/drivers/video/display/display-sysfs.c b/drivers/video/display/display-sysfs.c

    That's because I had changed them as well.
    The other ones you spotted I haven't seen originally:

> diff -u -p a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> diff -u -p a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
> diff -u -p a/drivers/video/output.c b/drivers/video/output.c

    Do you mind sending another patch or do you want me folding these in?

Thank you,
André
