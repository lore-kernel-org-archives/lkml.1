Return-Path: <linux-kernel-owner+w=401wt.eu-S1763134AbXFRWh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763134AbXFRWh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933407AbXFRWhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:37:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34775 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933320AbXFRWhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:37:06 -0400
Date: Mon, 18 Jun 2007 15:38:20 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070618223819.GD9751@tree.beaverton.ibm.com>
References: <20070605183300.GD12782@tree.beaverton.ibm.com> <20070605184015.GF17143@linux-os.sc.intel.com> <20070605200954.GE12782@tree.beaverton.ibm.com> <20070605211451.GG17143@linux-os.sc.intel.com> <20070605235707.GB16074@tree.beaverton.ibm.com> <20070606013759.GI17143@linux-os.sc.intel.com> <20070606185829.GA26062@tree.beaverton.ibm.com> <20070606193514.GN17143@linux-os.sc.intel.com> <20070606231642.GH13751@tree.beaverton.ibm.com> <20070608005726.GO17143@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5p8PegU4iirBW1oA"
Content-Disposition: inline
In-Reply-To: <20070608005726.GO17143@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--5p8PegU4iirBW1oA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 07, 2007 at 05:57:26PM -0700, Siddha, Suresh B wrote:

> As you have the failing system, you need to do more detective work and
> help me out. Can you try this debug patch and send across the dmesg after the
> bug happens and also can you try different compiler to see if something
> changes..

Hrm, I just updated to -rc5.  Interrupts being handled by the IOAPIC
don't suffer from this problem, but MSI interrupts are still affected.
I added a few printks to the kernel to figure out what IRQ affinity
masks were being passed around and saw this:

[  256.298773] Breaking affinity for irq 4341
[  256.298774] irq=4341 affinity=2 mask=d
<call to set_affinity>
[  256.298787] irq=4341 affinity=d
<ethernet on irq 4341 stops working>

I'll keep digging, but at least it appears that the problem has been
shrunk down to something the MSI code.

--D

--5p8PegU4iirBW1oA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGdwlba6vRYYgWQuURAkbpAJ9KOnUROoGbl4js1TEEVClVNSLQgwCbBrEr
kDK3xkjY0TK99GeQrD3JNUs=
=urQw
-----END PGP SIGNATURE-----

--5p8PegU4iirBW1oA--
