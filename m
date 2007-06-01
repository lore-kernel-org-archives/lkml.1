Return-Path: <linux-kernel-owner+w=401wt.eu-S1762815AbXFASml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762815AbXFASml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761915AbXFASmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:42:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44497 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761815AbXFASmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:42:32 -0400
Date: Fri, 1 Jun 2007 11:43:42 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dependent CPU core speed reporting not updated with CPUFREQ_SHARED_TYPE_HW?
Message-ID: <20070601184342.GA13751@tree.beaverton.ibm.com>
References: <460C5D24.608@us.ibm.com> <653FFBB4508B9042B5D43DC9E18836F52DF4D8@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F52DF4D8@scsmsx415.amr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 29, 2007 at 06:06:22PM -0700, Pallipadi, Venkatesh wrote:
> thought of
> making affected CPUs show the dependency in case of hw coord, but
> retaining the percpu
> control. But, it seemed complicated change for something that is
> cosmetic.

Actually, it's not so cosmetic any more.  Our newest servers have a
power meter that measures power consumption, and I'm writing a program
to measure the power cost of various cpufreq transitions in order to
enforce a power cap.  Due to the under-reporting in affected_cpus, the
app thinks that (taking your example above) CPUs 0 and 2 can be
controlled independently.  Thus, a p-state transition of (x, x) ->
(x, x-1) yields no energy saving at all, while (x, x-1) -> (x-1, x-1)
does.  My program considers the effects of a single CPU's transition
independently of which CPU it is and without considering what
frequencies the other CPUs are operating at, which means that it will
conclude that the cost of increasing speed (or the reward for decreasing
it) is half of what it is ... sort of.  It's mildly broken as a result,
though amusingly enough it still seems to work ok.  I suspect that it
might flail around trying to hit a cap a bit more than it would if
affected_cpus were more accurate.

--D

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGYGjea6vRYYgWQuURAjC0AKCwOqKYqrWFTYb4ECe9TGYwpt/9owCghm35
qXrxjzFqJiZYxZ50auZt740=
=mOaP
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
