Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbXEZMtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbXEZMtg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 08:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXEZMt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 08:49:28 -0400
Received: from daemonizer.de ([87.230.16.230]:37781 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbXEZMt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 08:49:28 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: nigel@nigel.suspend2.net
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Date: Sat, 26 May 2007 14:49:09 +0200
User-Agent: KMail/1.9.7
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200705261128.57332.maxi@daemonizer.de> <1180173233.9773.79.camel@nigel.suspend2.net>
In-Reply-To: <1180173233.9773.79.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1306973.GGmrPTvFQb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705261449.12823.maxi@daemonizer.de>
X-Spam-Score: -4.0 (----)
X-Spam-Report: No, hits=-4.0 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.4 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1306973.GGmrPTvFQb
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 26 May 2007, Nigel Cunningham wrote:
> Hi.
>
> On Sat, 2007-05-26 at 11:28 +0200, Maximilian Engelhardt wrote:
> > Hello,
> >
> > When I try software suspend on my laptop it always returns to my running
> > system after some time.
> > This is what's logged by the kernel:
> >
> > swsusp: Basic memory bitmaps created
> > Stopping tasks ...
> > Stopping kernel threads timed out after 20 seconds (1 tasks refusing to
> > freeze):
> >  cryptd
> > Restarting tasks ... done.
> > swsusp: Basic memory bitmaps freed
> >
> > I have no idea what's the problem, but if you tell me what I should do I
> > can create debugging information and/or test patches.
>
> Could you try this patch, please? It should help.
>
> Herbert, is this right? If cryptd is going to be used for block devs,
> the task should probably be PF_NOFREEZE (or whatever it is today)
> instead.
>
> Regards,
>
> Nigel
>
>  crypto/cryptd.c         |    1 +
>  include/linux/freezer.h |    3 +++
>  kernel/power/process.c  |    2 +-
>  3 files changed, 5 insertions(+), 1 deletion(-)
> diff -ruNp 991-fix-cryptd.patch-old/crypto/cryptd.c
> 991-fix-cryptd.patch-new/crypto/cryptd.c ---
> 991-fix-cryptd.patch-old/crypto/cryptd.c	2007-05-19 18:16:47.000000000
> +1000 +++ 991-fix-cryptd.patch-new/crypto/cryptd.c	2007-05-26
> 19:45:42.000000000 +1000 @@ -341,6 +341,7 @@ static int cryptd_thread(void
> *data)
>
>  		mutex_unlock(&state->mutex);
>
> +		try_to_freeze();
>  		schedule();
>  	} while (!stop);

I tried your patch, but when I apply it my kernel doesn't compile any more.=
 I=20
get these warnings/errors:

[...]
  CC      crypto/cryptd.o
crypto/cryptd.c: In function =E2=80=98cryptd_thread=E2=80=99:
crypto/cryptd.c:344: warning: implicit declaration of function =E2=80=98try=
_to_freeze=E2=80=99
[...]
  LD      init/built-in.o
  LD      .tmp_vmlinux1
crypto/built-in.o: In function `cryptd_thread':
cryptd.c:(.text+0xd7f5): undefined reference to `try_to_freeze'
make: *** [.tmp_vmlinux1] Error 1

Maxi

--nextPart1306973.GGmrPTvFQb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWCzIOimwv528XGERAshOAKDJivItxKFgEFWpMFZXkB+jLVyy2gCg4CXj
ebz/ajBSlRzj3CvVJCnoWM4=
=Lu+q
-----END PGP SIGNATURE-----

--nextPart1306973.GGmrPTvFQb--
