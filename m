Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYGPIwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYGPIwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbYGPIvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:51:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYGPIvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:51:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [git pull] Please pull from powerpc.git merge branch
Date: Wed, 16 Jul 2008 10:51:11 +0200
User-Agent: KMail/1.9.9
Cc: Dave Jones <davej@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <1216172043.7740.136.camel@pasglop> <20080716042042.GA13212@redhat.com>
In-Reply-To: <20080716042042.GA13212@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161051.12545.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/sWSywR6GUpPxNIphBw51qhqNofGhugF+v55b
 oDd0gfOp1G/vruGh4BF4CPJ3cTf5jaSrhKBDGuYS05QTIiCkuU
 1Y1H6tLMagSNn8TJA5zgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2008, Dave Jones wrote:
> arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
> /builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/platforms/82xx/ep8248e.c:129: undefined reference to `alloc_mdio_bitbang'
> /builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/platforms/82xx/ep8248e.c:143: undefined reference to `mdiobus_register'

FS_ENET and EP8248E both select MDIO_BITBANG, but not PHYLIB or MII, which
looks broken to me.

Also, I think it would be useful to split out the bitbang
driver from ep8248e.c, so that you can build it as a loadable
module if you want to have PHYLIB loadable.

	Arnd <><
