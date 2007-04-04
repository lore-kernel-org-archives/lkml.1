Return-Path: <linux-kernel-owner+w=401wt.eu-S1030369AbXDDDZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030369AbXDDDZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 23:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030370AbXDDDZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 23:25:33 -0400
Received: from h80ad278e.async.vt.edu ([128.173.39.142]:52544 "EHLO
	h80ad278e.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030369AbXDDDZc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 23:25:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: Your message of "Tue, 03 Apr 2007 19:20:04 PDT."
             <20070403192004.986b44ec.randy.dunlap@oracle.com>
From: Valdis.Kletnieks@vt.edu
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <24083.1175650554@turing-police.cc.vt.edu>
            <20070403192004.986b44ec.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175654767_4927P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Apr 2007 22:46:07 -0400
Message-ID: <4963.1175654767@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175654767_4927P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 Apr 2007 19:20:04 PDT, Randy Dunlap said:
> On Tue, 03 Apr 2007 21:35:54 -0400 Valdis.Kletnieks@vt.edu wrote:
> > I do a '/ACPI_SLEEP' inside that, and I get this output:
> > 
> > x Symbol: ACPI_SLEEP [=n]                                                 x
> >   x   Depends on: !X86_NUMAQ && !X86_VISWS && !IA64_HP_SIM && (IA64 || X86)

> > Only problem is that drivers/acpi/Kconfig:49 says:
> > 
> > config ACPI_SLEEP
> >         bool "Sleep States"
> >         depends on X86 && (!SMP || SUSPEND_SMP)
> >         depends on PM
> >         default y
> > 
> > Can somebody explain why I'm seeing the different Depends on in the two places?
> 
> Due to the top of drivers/acpi/Kconfig:
> 
> menu "ACPI (Advanced Configuration and Power Interface) Support"
> 	depends on !X86_NUMAQ
> 	depends on !X86_VISWS
> 	depends on !IA64_HP_SIM
> 	depends on IA64 || X86
> 	depends on PM

Ah. Further investigation shows that the "&& (!SMP || SUSPEND_SMP)" part
failed to show up because the line was too long - running 'make menuconfig'
in an 140-col or so xterm made them show up.

Anybody ambitious enough to add a "line too long" indicator of some sort? :)


--==_Exmh_1175654767_4927P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGExFvcC3lWbTT17ARAhxxAKCNfLFLwSGku4p+0xK8ZEMYvAZxYACgzmYt
dQO8fj+HbrDspP8KK+u1V3c=
=LvRc
-----END PGP SIGNATURE-----

--==_Exmh_1175654767_4927P--
