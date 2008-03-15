Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbYCOBY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbYCOBY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 21:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYCOBYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 21:24:18 -0400
Received: from v320-147-lb.its.uwo.ca ([129.100.74.147]:26174 "EHLO uwo.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751008AbYCOBYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 21:24:16 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2008 21:24:16 EDT
MIME-version: 1.0
From: Tyson Whitehead <twhitehe@uwo.ca>
Reply-to: twhitehe@uwo.ca
To: Bob Tracy <rct@frus.com>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
Date: Fri, 14 Mar 2008 21:18:19 -0400
User-Agent: KMail/1.9.7
Cc: Rene Herman <rene.herman@keyaccess.nl>, Michael Cree <mcree@orcon.net.nz>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
References: <20080314131344.62A59DBA2@gherkin.frus.com>
In-reply-to: <20080314131344.62A59DBA2@gherkin.frus.com>
Content-type: multipart/signed; boundary=nextPart2542964.ZgGiLW4jjC;
 protocol="application/pgp-signature"; micalg=pgp-sha1
Content-transfer-encoding: 7bit
Message-id: <200803142118.31974.twhitehe@uwo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2542964.ZgGiLW4jjC
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri March 14 2008, Bob Tracy wrote:
> A quick followup...  Since we're in agreement this isn't a regression,
> I've updated my working source tree to 2.6.25-rc5.  Built the new
> kernel with the patch to omit es1888_init(), and as near as I can tell,
> that function does nothing useful on the Miata platform.  At the very
> least, not having it makes no difference to any of the ALSA drivers I've
> tried: snd-sb8 still works great, and snd-es18xx is still broken in the
> same way originally described at the beginning of this long thread.
>
> I'll try a build with the old OSS "sb" driver, and if that works ok, we
> may be able to do away with es1888_init() on the Miata.  Tyson -- I
> think you have a Miata if I'm remembering correctly: can you confirm
> these observations?

I actually ran into some problems with my Alpha, and I haven't managed to g=
et=20
get it full operational again yet.  I replaced the CPU fan, installed the n=
ew=20
aboot, and left it trying to recover the filesystems.  It was an unhappy=20
story all around -- damn that CMD646 chipset, I was under the impression th=
at=20
driver had acquired some recent fixups.  Anyway, if this succeeds, I'll try=
=20
and compile up a new kernel with the patch when I get a chance.

With regard to the sound driver, the es18xx does endless looping on the fir=
st=20
second or so of sound on my box (a PWS500au) unless I apply my patch, which=
=20
just enables the alternative interupt detection code in the driver.  Even=20
then, though, I believe it still only works in 8bit mode.

The sb8 driver also works for me.  For this reason, I basically decided to=
=20
forget about my es18xx patch.  It doesn't get me anything the sb8 driver=20
doesn't give me, and it forces me to keep compiling my own kernels.

Cheers!  -Tyson

PS:  The Debian 2.6.24 kernel actually panicked on me (instead of infinitel=
y=20
looping on the first second of sound) when I tried the stock es18xx driver.

=2D-=20
 Tyson Whitehead  (-twhitehe at uwo.ca -- MC-)
 Computer Engineer                          Dept. of Applied Mathematics,
 Graduate Student- Applied Mathematics      University of Western Ontario,
 GnuPG Key ID# 0xF7666BFF                   London, Ontario, Canada

--nextPart2542964.ZgGiLW4jjC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBH2yPnp7ZNUfdma/8RAhURAJ9H1CSLXfNwdTd8Wi4anYTMRq30VACeNCPy
033KxyqAy11R6wHW5yCPTRM=
=LRpj
-----END PGP SIGNATURE-----

--nextPart2542964.ZgGiLW4jjC--
