Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127Ab0AHGzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab0AHGzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 01:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400Ab0AHGzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 01:55:44 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:48299 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab0AHGzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 01:55:43 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: mmotm 2010-01-06-14-34 uploaded (squashfs+lib/decomp)
In-Reply-To: Your message of "Thu, 07 Jan 2010 08:04:02 PST."
             <20100107080402.2f41d6f9.randy.dunlap@oracle.com>
From: Valdis.Kletnieks@vt.edu
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org> <12343.1262836096@localhost> <12823.1262836907@localhost>
            <20100107080402.2f41d6f9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262933694_3893P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 08 Jan 2010 01:54:54 -0500
Message-ID: <24025.1262933694@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4B46D6C1.016E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262933694_3893P
Content-Type: text/plain; charset=us-ascii

On Thu, 07 Jan 2010 08:04:02 PST, Randy Dunlap said:
> On Wed, 06 Jan 2010 23:01:47 -0500 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Wed, 06 Jan 2010 22:48:16 EST, Valdis.Kletnieks@vt.edu said:
> > 
> > > Building with CONFIG_SQUASHFS=m, CONFIG_SQUASHFS_LZMA=y ,
> > > and CONFIG_DECOMPRESS_LZMA=n fails:
> > 
> > > Looks like a missing select/depends for DECOMPRESS_LZMA.  Somebody else can
> > > decide which it should be...
> > 
> > Digging further:
> >   
> >   x Symbol: DECOMPRESS_LZMA [=n]                                            x  
> >   x   Selected by: RD_LZMA [=n] && BLK_DEV_INITRD [=y] || SQUASHFS_LZMA [=y x  
> > 
> > How the heck did this happen?  Looks like a SELECT *is* there but it's
> > not firing??!?
> 
> I saw this build error in linux-next and sent a patch for it -- it's below.
> However, it doesn't appear to be exactly the same config as yours.

Yeah, that patch is how you ended up cc'ed - it was already in the linux-next
patch in Andrew's -mmotm tarball.  It looked like you addressed one corner case
of the problem, and I tripped over another.  But now I'm trying to get my
brain wrapped around how I was able to get SQUASHFS_LZMA=y, and it had a
select for DECOMPRESS_LZMA, but that *still* was 'n' anyhow? How did we end
up with both && and || in that 'Selected by:' line?  Is that saying that
RD_LZMA needs to be on too?

Adding some plausible-sounding kbuild-related entries from MAINTAINERS to
the cc: list, maybe they can explain it...

--==_Exmh_1262933694_3893P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLRta+cC3lWbTT17ARAmaXAJ4rN/u2xva5uEKI1pYzUfENxoI0EACgh8l4
7bhZAxgOYBEzANxioSSsiQ8=
=Z+QY
-----END PGP SIGNATURE-----

--==_Exmh_1262933694_3893P--

