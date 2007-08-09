Return-Path: <linux-kernel-owner+w=401wt.eu-S936651AbXHIBwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936651AbXHIBwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 21:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762591AbXHIBwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 21:52:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54699 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760963AbXHIBwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 21:52:04 -0400
Date: Thu, 9 Aug 2007 11:51:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH 4/7] Moved the io struct up to the generic lg.h
Message-Id: <20070809115156.ef5fdc6c.sfr@canb.auug.org.au>
In-Reply-To: <20070809003343.664528532@goodmis.org>
References: <20070809003211.373543702@goodmis.org>
	<20070809003343.664528532@goodmis.org>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Aug_2007_11_51_56_+1000_ydFXW4+YlZArSwR/"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Aug_2007_11_51_56_+1000_ydFXW4+YlZArSwR/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 08 Aug 2007 20:32:15 -0400 Steven Rostedt <rostedt@goodmis.org>
wrote:
>
> diff --git a/drivers/lguest/i386/lg.h b/drivers/lguest/i386/lg.h
> index 64f0abe..c5ea14c 100644
> --- a/drivers/lguest/i386/lg.h
> +++ b/drivers/lguest/i386/lg.h
> @@ -20,6 +20,8 @@
>  #include <linux/err.h>
>  #include <asm/semaphore.h>
>  #include "irq_vectors.h"
> +/* some files include this, some include the parent */
> +#include "../lg.h"

Surely everything should just include the parent which allows for easier
consolidation over time. (as you are doing here)

> --- a/drivers/lguest/lg.h
> +++ b/drivers/lguest/lg.h
> @@ -1,3 +1,19 @@
> +#ifndef _LGUEST_LG_GENERIC
> +#define _LGUEST_LG_GENERIC

Maybe _LGUEST_LG_H?  and the arch ones could use _LGUEST_I386_LG_H etc.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__9_Aug_2007_11_51_56_+1000_ydFXW4+YlZArSwR/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGunNATgG2atn1QN8RAlwdAJ98BwpBobUTR/kC+hw4rkxGHJm63gCfR6MZ
0bJEgxR+9e9+ea7NUGK3isQ=
=0GQf
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Aug_2007_11_51_56_+1000_ydFXW4+YlZArSwR/--
