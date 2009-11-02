Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZKBE6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZKBE6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 23:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZKBE6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 23:58:46 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:43322 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbZKBE6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 23:58:46 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: Your message of "Sun, 01 Nov 2009 16:35:05 EST."
             <alpine.OSX.1.10.0911011623070.55174@caridad.local>
From: Valdis.Kletnieks@vt.edu
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <yw1xhbte0wx0.fsf@unicorn.mansr.com>
            <alpine.OSX.1.10.0911011623070.55174@caridad.local>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257137919_10149P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 01 Nov 2009 23:58:39 -0500
Message-ID: <63587.1257137919@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.98 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4AEE6701.0009,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257137919_10149P
Content-Type: text/plain; charset=us-ascii

On Sun, 01 Nov 2009 16:35:05 EST, "Ryan C. Gordon" said:

> I glued two full Ubuntu installs together as a proof of concept, but I 
> think if Ubuntu did this as a distribution-wide policy, then people would 
> probably choose a different distribution.

Hmm.. so let's see - people compiling stuff for themselves won't use this
feature.  And if a distro uses it, users would probably go to a different
distro.

That's a bad sign right there...

> Then again, I hope Ubuntu uses FatELF on a handful of binaries, and 
> removes the /lib64 and /lib32 directories.

Actually, they can't nuke the /lib{32,64} directories unless *all* binaries
are using FatELF - as long as there's any binaries doing things The Old Way,
you need to keep the supporting binaries around.

> > There is also the issue of speed to launch these things.  It *has* to
> > be slower than executing a native file directly.

> In that there will be one extra read of 128 bytes, yes, but I'm not sure 
> that's a measurable performance hit. For regular ELF files, the overhead 
> is approximately one extra branch instruction. Considering that most files 
> won't be FatELF, that seems like an acceptable cost.

Don't forget you take that hit once for each shared library involved.  Plus
I'm not sure if there's hidden gotchas lurking in there (is there code that
assumes that if executable code is mmap'ed, it's only done so in one arch?
Or will a FatELF glibc.so screw up somebody's refcounts if it's mapped
in both 32 and 64 bit modes?

--==_Exmh_1257137919_10149P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK7mb/cC3lWbTT17ARAsCPAKC/3qQ2cEXJxFCC/c8V051QRH13xQCZAfVx
KwwRNMyurESmnRcD+bjcJJQ=
=hViS
-----END PGP SIGNATURE-----

--==_Exmh_1257137919_10149P--

