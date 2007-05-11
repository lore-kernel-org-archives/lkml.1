Return-Path: <linux-kernel-owner+w=401wt.eu-S1761378AbXEKOpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761378AbXEKOpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 10:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXEKOpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 10:45:44 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41684 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbXEKOpo (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 10:45:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: virtualization@lists.osdl.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Hubertus Franke <frankeh@watson.ibm.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [patch 1/6] Guest page hinting: core + volatile page cache.
In-Reply-To: Your message of "Fri, 11 May 2007 15:58:28 +0200."
             <20070511135925.513572897@de.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <20070511135827.393181482@de.ibm.com>
            <20070511135925.513572897@de.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178894722_3561P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 11 May 2007 10:45:23 -0400
Message-ID: <5056.1178894723@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178894722_3561P
Content-Type: text/plain; charset=us-ascii

On Fri, 11 May 2007 15:58:28 +0200, Martin Schwidefsky said:

> The guest page hinting patchset introduces code that passes guest
> page usage information to the host system that virtualizes the
> memory of its guests. There are three different page states:

Possibly hiding in the patchset someplace where I don't see it, but IBM's
VM hypervisor supported reflecting page faults back to a multitasking guest,
giving a signal that the guest supervisor could use.  The guest would then
look up which process owned that virtual page, and could elect to flag that
process as in page-wait and schedule another process to run while the hypervisor
was doing the I/O to bring the page in.  The guest would then get another
interrupt when the page became available, which it could use to flag the
suspended process as eligible for scheduling again.

Not sure how that would fit into all this though - it looks like the
"discard fault" does something similar, but only for pages marked volatile.
Would it be useful/helpful to also deliver a similar signal for stable pages?

--==_Exmh_1178894722_3561P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGRIGCcC3lWbTT17ARAuXpAKC7e3qFghXxkxTjGCVCOv8qFgPu9gCeN7+P
PCU5D+jRQTaPWNGBK3kJsKo=
=wU0V
-----END PGP SIGNATURE-----

--==_Exmh_1178894722_3561P--
