Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZIYCm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZIYCm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 22:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZIYCm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 22:42:27 -0400
Received: from c-71-63-93-204.hsd1.va.comcast.net ([71.63.93.204]:55701 "EHLO
	c-71-63-93-204.hsd1.va.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696AbZIYCm1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 22:42:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Roland Dreier <rdreier@cisco.com>
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimer: Remove overly verbose "switch to high res mode" message
In-Reply-To: Your message of "Thu, 24 Sep 2009 14:15:14 PDT."
             <adaws3oyrh9.fsf@cisco.com>
From: Valdis.Kletnieks@vt.edu
References: <adavdj92sso.fsf@cisco.com> <adar5tx2s9d.fsf@cisco.com> <20090924093800.GA23158@elte.hu> <ada1vlw126s.fsf_-_@cisco.com> <1253826764.1806.24.camel@Joe-Laptop.home>
            <adaws3oyrh9.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1253846529_9303P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Sep 2009 22:42:09 -0400
Message-ID: <16460.1253846529@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1253846529_9303P
Content-Type: text/plain; charset=us-ascii

On Thu, 24 Sep 2009 14:15:14 PDT, Roland Dreier said:
> 
>  > > -	printk(KERN_DEBUG "Switched to high resolution mode on CPU %d\n",
>  > > -	       smp_processor_id());
>  > 
>  > Perhaps pr_debug instead?
>  > It gets compiled to nothing unless DEBUG is defined.
> 
> Dunno... is that kernel log message ever useful now?

There's 3 cases to consider:

1) Kernel built with CONFIG_HIGH_RES_TIMERS=n.  We get no message then.

2) We have high-res timers and it succeeded. We probably don't care if that's
the usual case, so lose the message in that case, just like we probably
don't need a message that we managed to fork off init.

3) We attempted to switch to high-res mode, and it *failed*. We already throw
the appropriate KERN_WARNING for that a few lines up.

And since we issue a message in the one case we *care* about, we can
determine that the *lack* of that KERN_WARNING means the switch went OK.

Thus, we don't need the message, as it doesn't *tell* us anything we didn't
already know.

--==_Exmh_1253846529_9303P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKvC4BcC3lWbTT17ARAhR3AKDSRjyi1YgWz8UaDY6Lxyac0G8ZxgCgqWX+
eIQuVrGmU6lnTUHDiM4Y74k=
=La/R
-----END PGP SIGNATURE-----

--==_Exmh_1253846529_9303P--
