Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbXJDVcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbXJDVcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759447AbXJDVcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:32:35 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58501 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759081AbXJDVce (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:32:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH -v2] Add sysfs control to modify a user's cpu share
In-Reply-To: Your message of "Thu, 04 Oct 2007 10:54:51 +0200."
             <20071004085451.GA8108@osiris.boeblingen.de.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <1190725693.13716.10.camel@Homer.simpson.net> <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu> <20071003171029.GA5423@linux.vnet.ibm.com> <20071004075750.GD9176@elte.hu>
            <20071004085451.GA8108@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191533537_6948P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Oct 2007 17:32:17 -0400
Message-ID: <5596.1191533537@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191533537_6948P
Content-Type: text/plain; charset=us-ascii

On Thu, 04 Oct 2007 10:54:51 +0200, Heiko Carstens said:
> >   echo 2048 > /sys/kernel/uids/500/cpu_share
> > 
> > this should just work too, regardless of there not being any UID 500 
> > tasks yet. Likewise, once configured, the /sys/kernel/uids/* directories 
> > (with the settings in them) should probably not go away either.
> 
> Shouldn't that be done via uevents? E.g. UID x gets added to the sysfs tree,
> generates a uevent and a script then figures out the cpu_share and sets it.

That would tend to be a tad racy - a site may want to set limits in the
hypothetical /sys/kernel/uids/NNN before the program has a chance to fork-bomb
or otherwise make it difficult to set a limitfrom within another userspace
process.  It's similar to why you want a process to be launched with all its
ulimit's set, rather than set them after the fork/exec happens...


--==_Exmh_1191533537_6948P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHBVvhcC3lWbTT17ARAl6ZAJ43TQi2fLjkf7E4l6TJgh/Z33PYNACdEuj6
b+ArWtYvxCdcGFBDWzt4DJU=
=WSX3
-----END PGP SIGNATURE-----

--==_Exmh_1191533537_6948P--
