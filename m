Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZDBNGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZDBNGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 09:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZDBNG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 09:06:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:57760 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZDBNG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 09:06:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
Date: Thu, 2 Apr 2009 15:06:12 +0200
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Will Newton <will.newton@gmail.com>,
       Geert Uytterhoeven <geert.uytterhoeven@gmail.com>,
       michal.simek@petalogix.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
       Chen Liqin <liqin.chen@sunplusct.com>
References: <49D071A8.4010703@petalogix.com> <49D3DABA.2050001@zytor.com> <20090401213219.7B324FC3AB@magilla.sf.frob.com>
In-Reply-To: <20090401213219.7B324FC3AB@magilla.sf.frob.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904021506.13942.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/z8EzcR7WeqpfYsTA5XHW5lsMi6553oZhDBzq
 FKo8peYkCaD5Rqn2uBHFGzMLevmNdWXDXZFGAkLobweQ/bpjQQ
 MQKuCBbWmPILvyKWnYQvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009, Roland McGrath wrote:
> > Actually, gcc does have the _LP64 and __SIZEOF_POINTER__ macros (as well 
> > as __CHAR_BIT__), although I don't know how far back it does have that. 
> >      If it has been with us for long enough it might be possible to 
> > switch over to using panarch macros.

For user space, we also need to consider non-gcc compilers that could have
a different set of macros. As long as we don't start relying on any new
ones besides those we already use (__x86_64__, __s390x__, __powerpc64__,
__mips64, __arch64__), we at least don't break anything accidentally.

> Worst case the oldest compilers had <limits.h> and 
> "#if ULONG_MAX == 0xffffffffUL", though I wouldn't like
> myself to be using a setup where <limits.h> got pulled in.

That would of course work with non-gcc, but we are really not allowed
to pull in <limits.h> from places like <types.h> where it would be needed
then.

	Arnd <><
