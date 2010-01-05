Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186Ab0AEWac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0AEWac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286Ab0AEWab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:30:31 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:36784 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0AEWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:30:30 -0500
Date: Tue, 5 Jan 2010 16:29:42 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 1/4] Add add_local() and 
 add_local_return()
In-Reply-To: <8bd0f97a1001051417w288440b4h65b6b01d4ad36a72@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1001051620030.9108@router.home>
References: <20100105220417.400092933@quilx.com> <20100105220437.940473705@quilx.com> <8bd0f97a1001051417w288440b4h65b6b01d4ad36a72@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-175112064-1262730024=:9108"
Content-ID: <alpine.DEB.2.00.1001051624040.9108@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-175112064-1262730024=:9108
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1001051624041.9108@router.home>

On Tue, 5 Jan 2010, Mike Frysinger wrote:

> On Tue, Jan 5, 2010 at 17:04, Christoph Lameter wrote:
> > --- /dev/null =A0 1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6/include/asm-generic/add-local.h =A0 2010-01-05 15:36:02.0=
00000000 -0600
> > @@ -0,0 +1,13 @@
> > +#ifndef __ASM_GENERIC_ADD_LOCAL_H
> > +#define __ASM_GENERIC_ADD_LOCAL_H
>
> needs comment header (blurb/copyright/license)

A simple small include file? Really?

> > +#define add_return_local(ptr, v) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> > + =A0 =A0 =A0 ((__typeof__(*(ptr)))__add_return_local_generic((ptr), =
=A0 =A0 =A0 =A0 =A0\
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long)(v), sizeo=
f(*(ptr))))
> > +
> > +#define add_local(ptr, v) (void)__add_return_local_generic((ptr), =A0 =
=A0 =A0\
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long)(v), sizeo=
f(*(ptr)))
>
> the only difference here is the cast ... perhaps define an
> _add_local() macro to avoid the duplication

Right. This is a shortcut to define the add_local() operation without too
much effort. We should be using add / inc /dec there at some point.

> > --- /dev/null =A0 1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6/arch/alpha/include/asm/add-local.h =A0 =A0 =A0 =A02010-01=
-05 15:36:02.000000000 -0600
> > @@ -0,0 +1,2 @@
> > +#include <asm-generic/add-local.h>
> > +
>
> these arch stubs all have an extra new line

Thats bad?

> > +/*
> > + * Generic version of __add_return_local (disables interrupts). Takes =
an
> > + * unsigned long parameter, supporting various types of architectures.
> > + */
> > +static inline unsigned long __add_return_local_generic(volatile void *=
ptr,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long value, int size)
>
> size_t for size ?

No. It can be anything.

> > +extern unsigned long wrong_size_add_local(volatile void *ptr);
> > ...
> > + =A0 =A0 =A0 /*
> > + =A0 =A0 =A0 =A0* Sanity checking, compile-time.
> > + =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 if (size =3D=3D 8 && sizeof(unsigned long) !=3D 8)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wrong_size_add_local(ptr);
> > ...
> > + =A0 =A0 =A0 default:
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wrong_size_add_local(ptr);
> > + =A0 =A0 =A0 }
>
> should be BUILD_BUG_ON() ?

Does not work there.

---1463811839-175112064-1262730024=:9108--
