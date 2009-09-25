Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbZIYIXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbZIYIXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZIYIXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:23:49 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:44986 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbZIYIXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:23:47 -0400
Date: Fri, 25 Sep 2009 10:23:47 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
Message-ID: <20090925082346.GB4436@localdomain>
Reply-To: Louis.Rilling@kerlabs.com
References: <20090924165548.GA16586@us.ibm.com> <20090924170308.GH16989@us.ibm.com> <200909242343.59903.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-5618-1253866984-0001-2"
Content-Disposition: inline
In-Reply-To: <200909242343.59903.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-5618-1253866984-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2009 at 11:43:59PM +0200, Arnd Bergmann wrote:
> On Thursday 24 September 2009, Sukadev Bhattiprolu wrote:
> > +asmlinkage long
> > +sys_clone2(struct clone_struct __user *ucs, pid_t __user *pids)
> > +{
> > +       int rc;
> > +       struct clone_struct kcs;
> > +       unsigned long clone_flags;
> > +       int __user *parent_tid_ptr;
> > +       int __user *child_tid_ptr;
> > +       unsigned long __user child_stack_base;
> > +       struct pt_regs *regs;
> > +
> > +       rc =3D copy_from_user(&ucs, &kcs, sizeof(kcs));
> > +       if (rc)
> > +               return -EFAULT;
> > +
> > +       /*
> > +        * TODO: Convert clone_flags to 64-bit
> > +        */
> > +       clone_flags =3D (unsigned long)kcs.flags;
> > +       child_stack_base =3D (unsigned long)kcs.child_stack;
> > +       parent_tid_ptr =3D &ucs.parent_tid;
> > +       child_tid_ptr =3D  &ucs.child_tid;
> > +       regs =3D task_pt_regs(current);
> > +
> > +       if (!child_stack_base)
> > +               child_stack_base =3D user_stack_pointer(regs);
> > +
> > +       return do_fork_with_pids(clone_flags, child_stack_base, regs, 0,
> > +                       parent_tid_ptr, child_tid_ptr, kcs.nr_pids, pid=
s);
> > +}
> > +
>=20
> The function looks ok, but you have put it into arch/x86/kernel/process_3=
2.c,
> which is specific to x86-32. Since the code in this form is generic, why
> not just put it into kernel/fork.c? You should probably enclose it within
> #ifdef CONFIG_HAVE_ARCH_TRACEHOOK to make sure that user_stack_pointer()
> is implemented, but then it would be immediately usable by the nine archi=
tectures
> implementing that. The other architectures can then decide between adding
> their private version of sys_clone2 with an open-coded user_stack_pointer
> implementation or alternatively implement the tracehooks.

It will very likely break ia64, which defines CONFIG_HAVE_ARCH_TRACEHOOK and
already has sys_clone2().

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-5618-1253866984-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkq8fhIACgkQVKcRuvQ9Q1TwGgCePF1WjiSY+0qsgFrIQ9X6nvdp
NhgAoM3jCsDyooi1N2ShV8wqcmVclXet
=kWwC
-----END PGP SIGNATURE-----

--=_bohort-5618-1253866984-0001-2--
