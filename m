Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbYBLPIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbYBLPIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759741AbYBLPHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:07:55 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45482 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759709AbYBLPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:07:52 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH] kbuild: fix make V=1
Date: Tue, 12 Feb 2008 10:07:49 -0500
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080212085605.GB26865@uranus.ravnborg.org> <20080212092504.GI24008@flower.upol.cz>
In-Reply-To: <20080212092504.GI24008@flower.upol.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1892631.eMpA3zuJZm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802121007.50638.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1892631.eMpA3zuJZm
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 12 February 2008, Oleg Verych wrote:
> On Tue, Feb 12, 2008 at 09:56:05AM +0100, Sam Ravnborg wrote:
> > On Tue, Feb 12, 2008 at 12:38:24AM +0100, Oleg Verych wrote:
> > > * Date: Mon, 11 Feb 2008 17:47:09 +0100
> > > []
> > >
> > > > Mike spotted another missing thing from his initial
> > > > patch so I folded it into the fix and pushed out
> > > > a new kbuild.git tree.
> > > >
> > > > See updated patch below.
> > >
> > > Sam, do you agree my fix was more reliable (yea, not only efficient:)?
> >
> > You more or less just reverted the original patch - so it was obviously
> > more reliable than introducing new stuff as the fix did.
> > But we are at -r1 so I prefer to get the inteded behaviour
> > and not the minmal fix.
>
> Processing below changes arguments, not semantics of generated shell
> code. And IMHO this is more reliable way of doing things. If one really
> wants silence without commonly accepted ">/dev/null 2>&1" practice, then
> choose portable "-n" argument for `echo`.
>
> - quiet_chk_filechk =3D echo '  CHK     $@'
> -silent_chk_filechk =3D :
> - quiet_upd_filechk =3D echo '  UPD     $@'
> -silent_upd_filechk =3D :
> +quiet_chk_filechk =3D '  CHK     $@'
> +quiet_upd_filechk =3D '  UPD     $@'
> +
>  define filechk
>  	$(Q)set -e;				\
> -	$($(quiet)chk_filechk);			\
> +	echo $($(quiet)chk_filechk);		\
>  	mkdir -p $(dir $@);			\
>  	$(filechk_$(1)) < $< > $@.tmp;		\
>  	if [ -r $@ ] && cmp -s $@ $@.tmp; then	\
>  		rm -f $@.tmp;			\
>  	else					\
> -		$($(quiet)upd_filechk);		\
> +		echo $($(quiet)upd_filechk);	\
>  		mv -f $@.tmp $@;		\
>  	fi
>  endef

i dont see how yours is more efficient when it always runs echo.  nor does =
it=20
give the same behavior ... your propposed change will echo blank lines in t=
he=20
silent mode which is incorrect.  it also does not seem to follow the standa=
rd=20
convention of other kconfig commands that have quiet/silent prefixes ... su=
ch=20
commands do not define arguments to an unknown program/function, nor do the=
y=20
add arbitrary redirection which gets leads to confusion as to final=20
expansion, they define the entire command.

what Sam posted (and what was merged) makes sense to me.
=2Dmike

--nextPart1892631.eMpA3zuJZm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR7G2RkFjO5/oN/WBAQJ8xw//QyyHyAWRSb9S8jQbxY2DpleqTyY9O9wV
fgvU4rx6CNmFsStBgfUdixIS+kJfuF0LHPmNEVQL5R3J3AtJr85udFabHT9vlU0i
4nzAheotZFfR8S6HDPbkknz7hOyEzJKDSahYC+GAqMfFMUvjUOK4JhD9R2x8RNbM
M7zS1G83tR/hG6bSHE9Es2Ttd1XK3gcFUPHFFZJy1LptDF8cXvbSNvWBfVg9smxN
ReWHCX6RWYaXNV3Yle2xMFFhcGQjTEJrNALqL1LGgCnrIAjrgnlU2lJHTFF1PvDM
J3tXdDx1iO3kdunsLYIj/86PBbjyl/nDlFPRTGjQdJdrvhveTwjFEhfSH/PzKwny
ikfUUF0Xr4Bs3L0dxeQFv8T6cEN6yM3iNogRLu+Yv/c3QL1PjqHSmHf3JLgeIBQ6
DqZnKALC24aQg4AmsRa4ye0pjtAVqzg+S+l34BrW9aPYIePBjAldm55EGveJOBAb
1zxny29EsaWlGMjfKj1np0SM4ZStICkYp0RN26CPQo6K61CPdre4ygoSRWh4XwQ8
SVNEzYC4JhGFTK5EELuBNjIcFlxHskzPcowzq+MR6nvrCug1+jf3RdIBsWPsWoAb
jqsfIRpqQBrP6VpfZHh9Tlh/PW0GLMS1q4e3QdLZXvHPk/HdzO8M65LggSXq7y8C
JkkxjyrRQoY=
=7OKr
-----END PGP SIGNATURE-----

--nextPart1892631.eMpA3zuJZm--
