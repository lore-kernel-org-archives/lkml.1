Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYJIBws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYJIBws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 21:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYJIBwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 21:52:40 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54237 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYJIBwj (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 21:52:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: [PATCH] documentation: explain memory barriers
In-Reply-To: Your message of "Wed, 08 Oct 2008 18:12:23 PDT."
             <20081008181223.6954c7b2.randy.dunlap@oracle.com>
From: Valdis.Kletnieks@vt.edu
References: <20080911101616.GA24064@agk.fab.redhat.com> <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com> <20080923154905.50d4b0fa.akpm@linux-foundation.org> <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com> <20080923164623.ce82c1c2.akpm@linux-foundation.org> <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com> <20081001225404.4e973465.akpm@linux-foundation.org>
            <20081008181223.6954c7b2.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1223517002_7177P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Oct 2008 21:50:03 -0400
Message-ID: <8119.1223517003@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1223517002_7177P
Content-Type: text/plain; charset=us-ascii

On Wed, 08 Oct 2008 18:12:23 PDT, Randy Dunlap said:

> +
> +24: All memory barriers {e.g., barrier(), rmb(), wmb()} need a comment in the
> +    source code that explains the logic of what they are doing and why.

"what they are doing" will almost always be "flush value to RAM" or similar.
How about this instead:

+ 24: All memory barriers ({e.g., barrier(), rmb(), wmb()} need a comment in the
+    source code that explains the race condition being prevented, and states
+    the location of the other code or hardware feature that races with this.
+
+    An example comment:
+
+ 	/*
+ 	 * If we don't do a wmb() here, the RBFROBNIZ register on the XU293
+ 	 * card will get confused and wedge the hardware...
+ 	 */
+	wmb();

--==_Exmh_1223517002_7177P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI7WNKcC3lWbTT17ARAmSZAJ0WjZaaX5AM673q+D77OObA+asODACaAjYy
+wayFg1sG3ZUDtZ8tKVTbYU=
=RfTM
-----END PGP SIGNATURE-----

--==_Exmh_1223517002_7177P--
