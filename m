Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZA2OmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZA2OmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZA2Olv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:41:51 -0500
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:42807 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZA2Olu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:41:50 -0500
Date: Thu, 29 Jan 2009 15:41:32 +0100
From: Frank Mehnert <Frank.Mehnert@Sun.COM>
Subject: Re: PFs on pages pinned with get_user_pages()
In-reply-to: <1233238854.4495.93.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Message-id: <200901291541.32618.frank.mehnert@sun.com>
Organization: Sun Microsystems
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart1853270.k5jLsgMOGj
Content-transfer-encoding: 7BIT
References: <200901290905.10966.frank.mehnert@sun.com>
 <200901291502.48312.frank.mehnert@sun.com> <1233238854.4495.93.camel@laptop>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1853270.k5jLsgMOGj
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 29 January 2009, Peter Zijlstra wrote:
> On Thu, 2009-01-29 at 15:02 +0100, Frank Mehnert wrote:
> > I'm one of the VirtualBox developers. We are trying to fix the annoying
> > kerneloops warning 'BUG: sleeping function called from invalid context'
> > reported by the Fedora folks. This warning occurs when do_swap_page()
> > calls lock_page() and in_atomic() returns true.
> >
> > This warning appears when we touch into memory which is pinned with
> > get_user_pages(). In VT-x/AMD-V mode we are executing some code in the
> > context of the Linux kernel. To prevent scheduling of the current CPU
> > core we disable the interripts. preempt_disable() would be probably the
> > better choice but this would oops as well if CONFIG_PREEMPT is enabled.
>
> but to get there, you'd have to have called handle_mm_fault() which
> requires the mmap_sem, which should also give that might_sleep()
> warning.

The stacktrace is

  __might_sleep()
  lock_page()
  handle_mm_fault()
  do_page_fault()
  error_code

So yes, handle_mm_fault() is called. But I assume that down_read_trylock()
succeeded before we were forced to call down_read().

> That aside, is there any reason you have to avoid scheduling? Otherwise
> I would just allow so and be done with it.

The reason is that our code expects that to ensure syncing of the CPU
state with the saved state. I fear it is quite difficult to change that...

Kind regards,

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/

--nextPart1853270.k5jLsgMOGj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmBwBwACgkQ6z8pigLf3Ec/rgCfVFGd/Unt65FgXuYhult/nac6
1/EAni3ZBU8MFjmokdlwyUDdWoMslNI3
=M0SH
-----END PGP SIGNATURE-----

--nextPart1853270.k5jLsgMOGj--
