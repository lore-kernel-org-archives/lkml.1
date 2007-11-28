Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbXK1TZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbXK1TZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbXK1TZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:25:38 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:48018 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbXK1TZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:25:36 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Nov 2007 11:25:30 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: 2.6.24-rc3-mm2 - Build Failure on powerpc timerfd() undeclared
In-Reply-To: <20071128104345.9474025e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711281123360.14548@alien.or.mcafeemobile.com>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
 <474D61CF.6080400@linux.vnet.ibm.com> <200711281432.09178.arnd@arndb.de>
 <20071128104345.9474025e.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-290824188-1196277930=:14548"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-290824188-1196277930=:14548
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 28 Nov 2007, Andrew Morton wrote:

> On Wed, 28 Nov 2007 14:32:07 +0100 Arnd Bergmann <arnd@arndb.de> wrote:
>=20
> > On Wednesday 28 November 2007, Kamalesh Babulal wrote:
> > > Kernel build fails, with build error
> > >=20
> > > =C2=A0 CC =C2=A0 =C2=A0 =C2=A0arch/powerpc/platforms/cell/spu_callbac=
ks.o
> > > In file included from arch/powerpc/platforms/cell/spu_callbacks.c:49:
> > > include/asm/systbl.h:312: error: =E2=80=98sys_timerfd=E2=80=99 undecl=
ared here (not in a function)
> > > make[2]: *** [arch/powerpc/platforms/cell/spu_callbacks.o] Error 1
> > > make[1]: *** [arch/powerpc/platforms/cell] Error 2
> > > make: *** [arch/powerpc/platforms] Error 2
> > >=20
> >=20
> > I guess all architectures except x86 are currently broken because they
> > reference the old sys_timerfd function.
>=20
> None of them were broken in my testing and I'm unsure why powerpc broke
> here.
>=20
> > This patch should add the missing
> > bits to powerpc.
> >=20
>=20
> Because the patches in -mm left the stubs in place in sys_ni.c and powerp=
c
> _should_ have (incorrectly) picked those up.

My fault. I forgot to update sys_ni.c with the new functions (and with the
sys_timerfd->sys_timerfd_create name change).
Do you want a patch Andrew?



- Davide

--1795850513-290824188-1196277930=:14548--
