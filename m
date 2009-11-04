Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZKDDYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZKDDYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 22:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZKDDYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 22:24:51 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:54312 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbZKDDYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 22:24:51 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Hal Finney <hal.finney@gmail.com>, tpmdd-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com
Subject: Re: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable multiple times
In-Reply-To: Your message of "Tue, 03 Nov 2009 15:41:58 MST."
             <20091103224157.GA20963@obsidianresearch.com>
From: Valdis.Kletnieks@vt.edu
References: <20091103003511.GL7768@obsidianresearch.com> <da7b3ce30911030931u1ccbff69ted4206606475c83@mail.gmail.com> <6926.1257272068@turing-police.cc.vt.edu>
            <20091103224157.GA20963@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257305069_3003P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Nov 2009 22:24:29 -0500
Message-ID: <13189.1257305069@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.98 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4AF0F3EE.0161,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257305069_3003P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 Nov 2009 15:41:58 MST, Jason Gunthorpe said:
> On Tue, Nov 03, 2009 at 01:14:28PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 03 Nov 2009 09:31:55 PST, Hal Finney said:
> > > What if you don't want it accessible by user mode apps, you only want
> > > your middleware (ie tcs daemon, tcsd) to open it? Will this still
> > > allow that to be enforced, so nobody can interfere with tcsd's
> > > exclusive access to the device?
> > 
> > Couldn't tcsd just open the device with O_EXCL? Or am I missing something
> > subtle here?
> 
> O_EXCL isn't a locking flag...

Sorry, getting over the flu, my brain isn't totally online yet. I was
thinking of TIOCEXCL which is (a) an ioctl() and (b) apparently tty-specific.

A number of other things under drivers/ implement "only one open" semantics,
but those are hard-coded into the driver. But for the TPM, it's unclear if
exclusive or non-exclusive is the right model. Maybe the right answer is to
default to multiple opens, but have an ioctl() that turns on exclusive mode.
If you have a 'tcsd' daemon, it will need to get launched early enough
to do the open/ioctl before somebody else gets running anyhow, so it's
not adding to any raciness.  Yeah, it's a hack. And there's still a small
DoS issue - if the system is supposed to allow multiple opens, an abusive
process can ioctl() it and break it.

--==_Exmh_1257305069_3003P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8PPtcC3lWbTT17ARAhMCAJ9j4mNEAr6oPhEbaeElvN/1bgPpoQCglEOW
ZI1LJR5CLT4nfo8nsFNm+Pg=
=+L76
-----END PGP SIGNATURE-----

--==_Exmh_1257305069_3003P--

