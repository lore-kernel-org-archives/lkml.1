Return-Path: <linux-kernel-owner+w=401wt.eu-S1763355AbXE1VC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763355AbXE1VC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbXE1VCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:02:51 -0400
Received: from daemonizer.de ([87.230.16.230]:39849 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbXE1VCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:02:50 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Date: Mon, 28 May 2007 23:02:28 +0200
User-Agent: KMail/1.9.7
Cc: nigel@nigel.suspend2.net, Herbert Xu <herbert@gondor.apana.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200705261128.57332.maxi@daemonizer.de> <200705280959.37516.rjw@sisk.pl> <200705282021.30355.rjw@sisk.pl>
In-Reply-To: <200705282021.30355.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3799734.FFf1Euva34";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705282302.31227.maxi@daemonizer.de>
X-Spam-Score: -4.1 (----)
X-Spam-Report: No, hits=-4.1 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.3 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3799734.FFf1Euva34
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 28 May 2007, Rafael J. Wysocki wrote:
> On Monday, 28 May 2007 09:59, Rafael J. Wysocki wrote:
> > On Monday, 28 May 2007 02:21, Maximilian Engelhardt wrote:
> > > On Sunday 27 May 2007, Rafael J. Wysocki wrote:
> > > > On Sunday, 27 May 2007 22:41, Maximilian Engelhardt wrote:
> > > > > On Sunday 27 May 2007, Rafael J. Wysocki wrote:
> > > > > > On Sunday, 27 May 2007 18:01, Maximilian Engelhardt wrote:
> > > > > > > On Saturday 26 May 2007, Nigel Cunningham wrote:
> > > > > > > > Hi.
> > > > > > > >
> > > > > > > > On Sat, 2007-05-26 at 14:49 +0200, Maximilian Engelhardt=20
wrote:
> > > > > > > > > On Saturday 26 May 2007, Nigel Cunningham wrote:
> > > > > > > > > > Hi.
> > > > > > > > > >
> > > > > > > > > > On Sat, 2007-05-26 at 11:28 +0200, Maximilian Engelhard=
t=20
wrote:
> > > > > > > > > > > Hello,
> > > > > > > > > > >
> > > > > > > > > > > When I try software suspend on my laptop it always
> > > > > > > > > > > returns to my running system after some time.
> > > > > > > > > > > This is what's logged by the kernel:
> > > > > > > > > > >
> > > > > > > > > > > swsusp: Basic memory bitmaps created
> > > > > > > > > > > Stopping tasks ...
> > > > > > > > > > > Stopping kernel threads timed out after 20 seconds (1
> > > > > > > > > > > tasks refusing to freeze):
> > > > > > > > > > >  cryptd
> > > > > > > > > > > Restarting tasks ... done.
> > > > > > > > > > > swsusp: Basic memory bitmaps freed
> > > > > > > > > > >
> > > > > > > > > > > I have no idea what's the problem, but if you tell me
> > > > > > > > > > > what I should do I can create debugging information
> > > > > > > > > > > and/or test patches.
> > > > > > > > > >
> > > > > > > > > > Could you try this patch, please? It should help.
> > > > > > > > > >
> > > > > > > > > > Herbert, is this right? If cryptd is going to be used f=
or
> > > > > > > > > > block devs, the task should probably be PF_NOFREEZE (or
> > > > > > > > > > whatever it is today) instead.
> > > > > > > > > >
> > > > > > > > > > Regards,
> > > > > > > > > >
> > > > > > > > > > Nigel
> > > > > > > > > >
> > > > > > > > > >  crypto/cryptd.c         |    1 +
> > > > > > > > > >  include/linux/freezer.h |    3 +++
> > > > > > > > > >  kernel/power/process.c  |    2 +-
> > > > > > > > > >  3 files changed, 5 insertions(+), 1 deletion(-)
> > > > > > > > > > diff -ruNp 991-fix-cryptd.patch-old/crypto/cryptd.c
> > > > > > > > > > 991-fix-cryptd.patch-new/crypto/cryptd.c ---
> > > > > > > > > > 991-fix-cryptd.patch-old/crypto/cryptd.c	2007-05-19
> > > > > > > > > > 18:16:47.000000000 +1000 +++
> > > > > > > > > > 991-fix-cryptd.patch-new/crypto/cryptd.c	2007-05-26
> > > > > > > > > > 19:45:42.000000000 +1000 @@ -341,6 +341,7 @@ static int
> > > > > > > > > > cryptd_thread(void *data)
> > > > > > > > > >
> > > > > > > > > >  		mutex_unlock(&state->mutex);
> > > > > > > > > >
> > > > > > > > > > +		try_to_freeze();
> > > > > > > > > >  		schedule();
> > > > > > > > > >  	} while (!stop);
> > > > > > > > >
> > > > > > > > > I tried your patch, but when I apply it my kernel doesn't
> > > > > > > > > compile any more. I get these warnings/errors:
> > > > > > > > >
> > > > > > > > > [...]
> > > > > > > > >   CC      crypto/cryptd.o
> > > > > > > > > crypto/cryptd.c: In function =E2=80=98cryptd_thread=E2=80=
=99:
> > > > > > > > > crypto/cryptd.c:344: warning: implicit declaration of
> > > > > > > > > function =E2=80=98try_to_freeze=E2=80=99 [...]
> > > > > > > > >   LD      init/built-in.o
> > > > > > > > >   LD      .tmp_vmlinux1
> > > > > > > > > crypto/built-in.o: In function `cryptd_thread':
> > > > > > > > > cryptd.c:(.text+0xd7f5): undefined reference to
> > > > > > > > > `try_to_freeze' make: *** [.tmp_vmlinux1] Error 1
> > > > > > > >
> > > > > > > > Ah. You'll need to add #include <linux/freezer.h> near that
> > > > > > > > start of crypto/cryptd.c. Sorry for forgetting that.
> > > > > > > >
> > > > > > > > Nigel
> > > > > > >
> > > > > > > I added the include line and now I could compile the kernel,
> > > > > > > but suspending still doesn't work.
> > > > > > >
> > > > > > > swsusp: Basic memory bitmaps created
> > > > > > > Stopping tasks ...
> > > > > > > Stopping kernel threads timed out after 20 seconds (1 tasks
> > > > > > > refusing to freeze):
> > > > > > > cryptd
> > > > > > > Restarting tasks ... done.
> > > > > > > swsusp: Basic memory bitmaps freed
> > > > > >
> > > > > > OK, this means that cryptd doesn't execute the try_to_freeze()
> > > > > > for some reason.
> > > > > >
> > > > > > Please apply the appended patch on top of 2.6.22-rc3 and see if
> > > > > > that helps.
> > > > > >
> > > > > > Greetings,
> > > > > > Rafael
> > > > > >
> > > > > > ---
> > > > > >  crypto/cryptd.c |    1 +
> > > > > >  1 file changed, 1 insertion(+)
> > > > > >
> > > > > > Index: linux-2.6.22-rc3/crypto/cryptd.c
> > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > >=3D=3D --- linux-2.6.22-rc3.orig/crypto/cryptd.c
> > > > > > +++ linux-2.6.22-rc3/crypto/cryptd.c
> > > > > > @@ -316,6 +316,7 @@ static int cryptd_thread(void *data)
> > > > > >  	struct cryptd_state *state =3D data;
> > > > > >  	int stop;
> > > > > >
> > > > > > +	current->flags |=3D PF_NOFREEZE;
> > > > > >  	do {
> > > > > >  		struct crypto_async_request *req, *backlog;
> > > > >
> > > > > Even with this patch suspending doesn't work, dmesg shows the same
> > > > > error message.
> > > > > I also did build a kernel without cryptd and suspending does work
> > > > > there.
> > > >
> > > > Well, that's strange, because in that case the freezer shouldn't ev=
en
> > > > wait for cryptd.
> > > >
> > > > Can you please try the patch at http://lkml.org/lkml/2007/5/26/169 ?
> > >
> > > With this patch applied suspend does work fine.
> >
> > Hmm.  IMO the patch is too intrusive for 2.6.22, but OTOH it's going in=
to
> > the direction preferred by some prominent people. ;-)
> >
> > Let's try to combine the two threads and see what results from that.
>
> Well, it looks like we have to fix this one separately.
>
> Can you please tell me what to do to make cryptd run?

Well, there really isn't much I do. When I switched from 2.6.21 to 2.6.22-r=
c2=20
I did a 'make oldconfig' and I enabled CONFIG_CRYPTO_CRYPTD because I thoug=
ht=20
it would be a good idea. I don't need cryptd, =C2=A0I just enabled it. Now =
when I=20
boot this kernel it seems like cryptd is automatically started.

I also tried building a kernel where CONFIG_CRYPTO_CRYPTD is disabled and=20
there suspending does work fine.

Maxi

--nextPart3799734.FFf1Euva34
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGW0NnOimwv528XGERAjyEAJ9oLEX6+nU+hbBVITlxJi7gEVU09wCgw2O7
SxL82xlwXl19W/BwnqMEIjY=
=kcd3
-----END PGP SIGNATURE-----

--nextPart3799734.FFf1Euva34--
