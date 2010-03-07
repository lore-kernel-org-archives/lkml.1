Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab0CGJTr convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Sun, 7 Mar 2010 04:19:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40280 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab0CGJTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 04:19:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YyYDIQDuNrWuBC9ve75oja7J6f/5jRFwI0ObUv5WdJ/unz/EIwAx/q2NsDqM1Yqo8Y
         E2QCSBFQmQ6LR9abShdb4zhsyG7QRH/km5m0bZ3eexhsPLYp4DNwG+bhY44GJbdv9Dvn
         tBJPa2wWIReGdV2+O85DTP9Q+9iPLr1PAp4ag=
MIME-Version: 1.0
In-Reply-To: <201003022001.o22K16vJ011337@hera.kernel.org>
References: <201003022001.o22K16vJ011337@hera.kernel.org>
Date: Sun, 7 Mar 2010 10:19:40 +0100
X-Google-Sender-Auth: eee37586e99ea5f3
Message-ID: <10f740e81003070119s3eb433d9r4f1cc79e59d56316@mail.gmail.com>
Subject: Re: drivers/net/mac8390.c: Remove useless memcpy casting
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 21:01, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb: =C2=A0 =C2=A0 http://git.kernel.org/linus/5c7fffd0e3b57cb63f5=
0bbd710868f012d67654f
> Commit: =C2=A0 =C2=A0 5c7fffd0e3b57cb63f50bbd710868f012d67654f
> Parent: =C2=A0 =C2=A0 35076402a9936fa8a73b57a1f97fecbeceeec34a
> Author: =C2=A0 =C2=A0 Joe Perches <joe@perches.com>
> AuthorDate: Mon Jan 4 11:53:00 2010 +0000
> Committer: =C2=A0David S. Miller <davem@davemloft.net>
> CommitDate: Wed Jan 6 20:44:02 2010 -0800
>
> =C2=A0 =C2=A0drivers/net/mac8390.c: Remove useless memcpy casting
>
> =C2=A0 =C2=A0Signed-off-by: Joe Perches <joe@perches.com>
> =C2=A0 =C2=A0Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
> =C2=A0drivers/net/mac8390.c | =C2=A0 19 ++++++++++---------
> =C2=A01 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/mac8390.c b/drivers/net/mac8390.c
> index 6b6f375..517cee4 100644
> --- a/drivers/net/mac8390.c
> +++ b/drivers/net/mac8390.c
> @@ -237,14 +237,14 @@ static enum mac8390_access __init mac8390_testi=
o(volatile unsigned long membase)

As indicated by the prototype above, membase is not a pointer...

> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long outdata =3D 0xA5A0B5B0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long indata =3D =C2=A00x00000000;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Try writing 32 bits */
> - =C2=A0 =C2=A0 =C2=A0 memcpy((char *)membase, (char *)&outdata, 4);
> + =C2=A0 =C2=A0 =C2=A0 memcpy(membase, &outdata, 4);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Now compare them */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (memcmp((char *)&outdata, (char *)memba=
se, 4) =3D=3D 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ACCESS_=
32;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Write 16 bit output */
> - =C2=A0 =C2=A0 =C2=A0 word_memcpy_tocard((char *)membase, (char *)&o=
utdata, 4);
> + =C2=A0 =C2=A0 =C2=A0 word_memcpy_tocard(membase, &outdata, 4);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Now read it back */
> - =C2=A0 =C2=A0 =C2=A0 word_memcpy_fromcard((char *)&indata, (char *)=
membase, 4);
> + =C2=A0 =C2=A0 =C2=A0 word_memcpy_fromcard(&indata, membase, 4);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (outdata =3D=3D indata)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ACCESS_=
16;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ACCESS_UNKNOWN;

=2E.. hence you introduced 3 compiler warnings:

drivers/net/mac8390.c:249: warning: passing argument 1 of
'__builtin_memcpy' makes pointer from integer without a cast
drivers/net/mac8390.c:254: warning: passing argument 1 of
'word_memcpy_tocard' makes pointer from integer without a cast
drivers/net/mac8390.c:256: warning: passing argument 2 of
'word_memcpy_fromcard' makes pointer from integer without a cast

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
							    -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
