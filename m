Return-Path: <linux-kernel-owner+w=401wt.eu-S1764126AbZDAPEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbZDAPEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765172AbZDAPEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:04:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:59085 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761841AbZDAPEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:04:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Newton <will.newton@gmail.com>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
Date: Wed, 1 Apr 2009 17:04:12 +0200
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>,
       michal.simek@petalogix.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
       Chen Liqin <liqin.chen@sunplusct.com>
References: <49D071A8.4010703@petalogix.com> <200904011611.53355.arnd@arndb.de> <87a5b0800904010739g3564eb1fhf32afcfee4936c4b@mail.gmail.com>
In-Reply-To: <87a5b0800904010739g3564eb1fhf32afcfee4936c4b@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904011704.13581.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/AXIsLsYXXFzwR4blGGc9uIMmTj8r3krDU4in
 RYI2xZs//H1sweEB7LQOJJ609g9iVelaq94UPW7N9h6nFWBpNp
 hRxUdvYcVphJmRuBcwX1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009, Will Newton wrote:
> > + * There seems to be no way of detecting this automatically from user
> > + * space, so 64 bit architectures should override this in their types.h.
> > + */
> > +#ifndef __BITS_PER_LONG
> > +#define __BITS_PER_LONG 32
> > +#endif
> 
> Why is this define required? It doesn't seem to be in any existing headers.

Unfortunately, there is no generic way to detect the word size yet,
but every architecture uses its own preprocessor macro (__x86_64__,
__s390x__, __ppc64__). We also can't use CONFIG_64BIT in an user-exported
interface header file, because the use space can also be compiled for
32 bits when the kernel uses 64 bits.

__BITS_PER_LONG is actually defined in parisc now, and was the result
of the last time we had this discussion. I'm still thinking about
making a separate <asm/bitsperlong.h> header, or a <asm/bits.h> that
also contains the respective __BIG_ENDIAN/__LITTLE_ENDIAN macros
which have the same problem. The advantage would be that other header
files (e.g. unistd.h) can known the word size without getting the
whole types.h name space.

	Arnd <><
