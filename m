Return-Path: <linux-kernel-owner+w=401wt.eu-S1765214AbXJTBTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765214AbXJTBTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761378AbXJTBSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:18:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:25774 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760940AbXJTBSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:message-id;
        b=dGLsKkRrh1J22TVHcMy9WXNE5yCVMRTF69rndqovnBu3mLqqOGoQp8x7uHrRbQ8cxshanvqJDw59I6mN3c1zr3HEQpluc4ikEeecPxSG4SaqphFlHH5ONZq+UxMkIWmi2lbgMvH7StOBpUFqZ//YkBowr+QhCJG/TZNIvylEW1U=
From: Paolo Giarrusso <p.giarrusso@gmail.com>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Date: Sat, 20 Oct 2007 02:52:30 +0200
User-Agent: KMail/1.9.7
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org
References: <200710111754.46854.rob@landley.net>
In-Reply-To: <200710111754.46854.rob@landley.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1923931.iimlfsJiGH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710200252.37919.p.giarrusso@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1923931.iimlfsJiGH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On venerd=C3=AC 12 ottobre 2007, Rob Landley wrote:
> [Second try, without clicking "compress" on the file attachment because
> then sourceforge's spam filter bounces it.]
>
> ---
>
> The User Mode Linux build still breaks for me:
> > In file included from include/asm/arch/tlb.h:18,
> >                  from include/asm/tlb.h:4,
> >                  from arch/um/kernel/smp.c:8:
> > include/asm-generic/tlb.h: In function =E2=80=98tlb_flush_mmu=E2=80=99:
> > include/asm-generic/tlb.h:76: error: implicit declaration of function
> > =E2=80=98release_pages=E2=80=99 include/asm-generic/tlb.h: In function =
=E2=80=98tlb_remove_page=E2=80=99:
> > include/asm-generic/tlb.h:105: error: implicit declaration of function
> > =E2=80=98page_cache_release=E2=80=99 make[1]: *** [arch/um/kernel/smp.o=
] Error 1
> > make: *** [arch/um/kernel] Error 2
>
> I submitted the following patch to fix it to the UML list after 2.6.23-rc=
3:
> http://sourceforge.net/mailarchive/forum.php?thread_name=3D200708212148.0=
5392
>.rob%40landley.net&forum_name=3Duser-mode-linux-devel
>
> On september 4, I confirmed that I still needed it to build -rc5:
> http://sourceforge.net/mailarchive/message.php?msg_name=3D200709040737.54=
516.
>rob%40landley.net
>
> Guess what?  I still need this patch to build the final 2.6.23, months
> later.
>
> I know it may not be the right fix, but the build breaks for me without
> this patch. The .config that breaks is attached.  ARCH=3Dum.

Guess most people are not using SMP right now, and that the error disappear=
s=20
without that setting - I'm being away for a long while, has SKAS+SMP suppor=
t=20
been merged?

However, a quick look at my sources tells otherwise, and git-describe says=
=20
that's a v2.6.23-rc6-239-gc2f8289 tree.

So I've no idea...

> ----------  Forwarded Message  ----------
>
> Subject: [uml-devel] UML doesn't build in 2.6.23-rc3.
> Date: Tuesday 21 August 2007
> From: Rob Landley <rob@landley.net>
> To: uml-devel <user-mode-linux-devel@lists.sourceforge.net>
>
> I fixed it for me with the following patch, just in case anybody else had
> this problem:
>
> --- linux-2.6.23-rc3/arch/um/kernel/smp.c	2007-08-12 23:25:24.000000000
> -0500 +++ linux-2.6.23-new/arch/um/kernel/smp.c	2007-08-21
> 21:39:00.000000000 -0500 @@ -5,6 +5,7 @@
>
>  #include "linux/percpu.h"
>  #include "asm/pgalloc.h"
> +#include "linux/pagemap.h"
>  #include "asm/tlb.h"
>
>  /* For some reason, mmu_gathers are referenced when CONFIG_SMP is off. */



=2D-=20
"Doh!" (cit.), I've made another mistake!
Paolo Giarrusso, aka Blaisorblade

--nextPart1923931.iimlfsJiGH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHGVFVqH9OHC+5NscRApw7AJ4pAmlrd5TMKVJltdapJPEPJMTxFACfZdRQ
33YnW2NpyjJDEVB0X30eQDg=
=N3iT
-----END PGP SIGNATURE-----

--nextPart1923931.iimlfsJiGH--
