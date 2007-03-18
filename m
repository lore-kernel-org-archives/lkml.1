Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbXCRUox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbXCRUox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933242AbXCRUov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:44:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50606 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232AbXCRUou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:44:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 18 Mar 2007 13:42:42 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Arnd Bergmann <arnd@arndb.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 5/13] signal/timer/event fds v6 - signalfd compat code
 ...
In-Reply-To: <200703172247.51602.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0703181340020.5482@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.9367.1174004538.5>
 <200703172247.51602.arnd@arndb.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-2115032942-1174250562=:5482"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-2115032942-1174250562=:5482
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 17 Mar 2007, Arnd Bergmann wrote:

> On Friday 16 March 2007 01:22:15 Davide Libenzi wrote:
> > +asmlinkage long compat_sys_signalfd(int ufd,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0const compat_sigset_t __user *sigmask,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0compat_size_t sigsetsize)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0compat_sigset_t ss32;
> > +=A0=A0=A0=A0=A0=A0=A0sigset_t tmp;
> > +=A0=A0=A0=A0=A0=A0=A0sigset_t __user *ksigmask;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (sigsetsize !=3D sizeof(compat_sigset_t))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> > +=A0=A0=A0=A0=A0=A0=A0if (copy_from_user(&ss32, sigmask, sizeof(ss32)))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EFAULT;
> > +=A0=A0=A0=A0=A0=A0=A0sigset_from_compat(&tmp, &ss32);
> > +=A0=A0=A0=A0=A0=A0=A0ksigmask =3D compat_alloc_user_space(sizeof(sigse=
t_t));
> > +=A0=A0=A0=A0=A0=A0=A0if (copy_to_user(ksigmask, &tmp, sizeof(sigset_t)=
))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EFAULT;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0return sys_signalfd(ufd, ksigmask, sizeof(sigset_=
t));
> > +}
>=20
> Doing the compat_alloc_user_space() magic obviously makes the 32 bit
> emulation code less efficient. How about having a
>=20
> long do_signalfd(int ufd, const sigset_t *sigmask, size_t sigsetsize);
>=20
> that is called directly by both sys_signalfd and compat_sys_signalfd?
> Same obviously applies also to do_timerfd.

Hmm,  copy_*_user (one or two moves) and compat_alloc_user_space are=20
pretty fast...



- Davide


--1795850513-2115032942-1174250562=:5482--
