Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZHEQLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZHEQLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZHEQLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:11:46 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57302 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbZHEQLp (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:11:45 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Zhang Rui <rui.zhang@intel.com>
Cc: Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS devices
In-Reply-To: Your message of "Wed, 05 Aug 2009 09:04:52 +0800."
             <1249434292.2670.388.camel@rzhang-dt>
From: Valdis.Kletnieks@vt.edu
References: <1249290657.2670.250.camel@rzhang-dt> <20090804132129.GH18974@elf.ucw.cz> <20090804151042.GA20276@kroah.com> <19631.1249406664@turing-police.cc.vt.edu> <20090804173627.GA23848@kroah.com>
            <1249434292.2670.388.camel@rzhang-dt>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1249488631_3824P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Aug 2009 12:10:31 -0400
Message-ID: <19291.1249488631@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1249488631_3824P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Aug 2009 09:04:52 +0800, Zhang Rui said:
> On Wed, 2009-08-05 at 01:36 +0800, Greg KH wrote:
> > On Tue, Aug 04, 2009 at 01:24:24PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > > On Tue, 04 Aug 2009 08:10:42 PDT, Greg KH said:
> > > > On Tue, Aug 04, 2009 at 03:21:29PM +0200, Pavel Machek wrote:
> > > > > On Mon 2009-08-03 17:10:57, Zhang Rui wrote:
> > > 
> > > > > > 	cat /sys/class/als/als0/mappings
> > > > > > 	???Illuminance	Adjustment
> > > > > > 	          0	       70
> > > > > > 	         10	       73
> > > > > > 	         80	       85
> > > > > > 	        300	      100
> > > > > > 	       1000	      150
> > > > > 
> > > > > There's one value per file for sysfs... You should definitely have th
e
> > > > > header. 
> > > > 
> > > > No, no "header", just don't do this, it's not allowed. Again,
> > > > one-value-per-sysfs-file is the rule, please do not violate it.
> > > 
> > > What's the intended sysfs solution here, then? Make 'mappings' a directory,
> > > and populate it with files called 0, 10, 80, 300, 1000, each with one number
> > > in them?
> > 
> > That's one acceptable solution.  Or how about files in this directory
> > called "mapping_0", "mapping_10", and so on, containing the adjustment
> > value?
> > 
> great. that's what I'm going to do.
> refreshed patch will be sent out later. :)

Hmm. whether to call the files mapping_0, mapping_10 etc or mapping/0, mapping/10
etc probably depends on how nailed-down the 0,10,80,300,100 is - are those
numbers carved in stone, or are we better off defining the API as "directory
mapping, and files for whatever values the hardware happens to cough up?"

Not a biggie either way, it's going to be a readdir()/filter/open()/close()
loop either way, just different details for the readdir() and entry filtering...

--==_Exmh_1249488631_3824P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKea73cC3lWbTT17ARAqdHAKCVOIEF8eJwxV0wcBMe1L7NoOtbrACeMDtl
KdpSKieO4Pl3G2P9l+a8sbw=
=ug77
-----END PGP SIGNATURE-----

--==_Exmh_1249488631_3824P--
