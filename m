Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbXE0QCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbXE0QCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbXE0QCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:02:13 -0400
Received: from daemonizer.de ([87.230.16.230]:48766 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbXE0QCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:02:12 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Date: Sun, 27 May 2007 18:01:26 +0200
User-Agent: KMail/1.9.7
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200705261128.57332.maxi@daemonizer.de> <200705261449.12823.maxi@daemonizer.de> <1180215220.5493.36.camel@nigel.suspend2.net>
In-Reply-To: <1180215220.5493.36.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1215813.pXfgkSGXPM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705271801.30119.maxi@daemonizer.de>
X-Spam-Score: -4.0 (----)
X-Spam-Report: No, hits=-4.0 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.4 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1215813.pXfgkSGXPM
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 26 May 2007, Nigel Cunningham wrote:
> Hi.
>
> On Sat, 2007-05-26 at 14:49 +0200, Maximilian Engelhardt wrote:
> > On Saturday 26 May 2007, Nigel Cunningham wrote:
> > > Hi.
> > >
> > > On Sat, 2007-05-26 at 11:28 +0200, Maximilian Engelhardt wrote:
> > > > Hello,
> > > >
> > > > When I try software suspend on my laptop it always returns to my
> > > > running system after some time.
> > > > This is what's logged by the kernel:
> > > >
> > > > swsusp: Basic memory bitmaps created
> > > > Stopping tasks ...
> > > > Stopping kernel threads timed out after 20 seconds (1 tasks refusing
> > > > to freeze):
> > > >  cryptd
> > > > Restarting tasks ... done.
> > > > swsusp: Basic memory bitmaps freed
> > > >
> > > > I have no idea what's the problem, but if you tell me what I should
> > > > do I can create debugging information and/or test patches.
> > >
> > > Could you try this patch, please? It should help.
> > >
> > > Herbert, is this right? If cryptd is going to be used for block devs,
> > > the task should probably be PF_NOFREEZE (or whatever it is today)
> > > instead.
> > >
> > > Regards,
> > >
> > > Nigel
> > >
> > >  crypto/cryptd.c         |    1 +
> > >  include/linux/freezer.h |    3 +++
> > >  kernel/power/process.c  |    2 +-
> > >  3 files changed, 5 insertions(+), 1 deletion(-)
> > > diff -ruNp 991-fix-cryptd.patch-old/crypto/cryptd.c
> > > 991-fix-cryptd.patch-new/crypto/cryptd.c ---
> > > 991-fix-cryptd.patch-old/crypto/cryptd.c	2007-05-19 18:16:47.000000000
> > > +1000 +++ 991-fix-cryptd.patch-new/crypto/cryptd.c	2007-05-26
> > > 19:45:42.000000000 +1000 @@ -341,6 +341,7 @@ static int
> > > cryptd_thread(void *data)
> > >
> > >  		mutex_unlock(&state->mutex);
> > >
> > > +		try_to_freeze();
> > >  		schedule();
> > >  	} while (!stop);
> >
> > I tried your patch, but when I apply it my kernel doesn't compile any
> > more. I get these warnings/errors:
> >
> > [...]
> >   CC      crypto/cryptd.o
> > crypto/cryptd.c: In function =E2=80=98cryptd_thread=E2=80=99:
> > crypto/cryptd.c:344: warning: implicit declaration of function
> > =E2=80=98try_to_freeze=E2=80=99 [...]
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > crypto/built-in.o: In function `cryptd_thread':
> > cryptd.c:(.text+0xd7f5): undefined reference to `try_to_freeze'
> > make: *** [.tmp_vmlinux1] Error 1
>
> Ah. You'll need to add #include <linux/freezer.h> near that start of
> crypto/cryptd.c. Sorry for forgetting that.
>
> Nigel

I added the include line and now I could compile the kernel, but suspending=
=20
still doesn't work.

swsusp: Basic memory bitmaps created
Stopping tasks ...=20
Stopping kernel threads timed out after 20 seconds (1 tasks refusing to=20
freeze):
cryptd
Restarting tasks ... done.
swsusp: Basic memory bitmaps freed

Maxi

--nextPart1215813.pXfgkSGXPM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWataOimwv528XGERAgLLAJ9UCV6Ab8pTlxpn6KTCgTEEBedGyQCgmz7l
JfqZ8jDtrp1xs8+KQ2dMcBM=
=GXk5
-----END PGP SIGNATURE-----

--nextPart1215813.pXfgkSGXPM--
