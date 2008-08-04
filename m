Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYHDOfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYHDOfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYHDOfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:35:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbYHDOfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:35:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Date: Mon, 4 Aug 2008 16:35:11 +0200
User-Agent: KMail/1.9.9
Cc: Greg Ungerer <gerg@snapgear.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <4892A719.5090302@snapgear.com> <Pine.LNX.4.64.0808032205120.23329@anakin>
In-Reply-To: <Pine.LNX.4.64.0808032205120.23329@anakin>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808041635.11854.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18dBsPbTO9KgFC3x0wlR7vQFTBy78b8VJOJ0Bu
 IxO9QcNQctd5TeCp+1MLFYcpMqJamm177PPyGJmw1YUUUnckNv
 5wtUHPcHhD4jMSEoYQCBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 August 2008, Geert Uytterhoeven wrote:
> There seem to be 3 classes of m68knommu header files:
>   1. Plain files (some of them may be (nearly) identical copies of the
>      m68k variants,

For reference, I found the files auxvec.h, device.h, emergency-restart.h,
futex.h, ioctl.h, irq_regs.h, kdebug.h, mutex.h and topology.h to be
entirely identical, so you may remove the m68knommu variants with your
approach.

>   2. Files that just include the m68k variant,
>   3. Files that include the m68k variant and do something more (pci.h and
>      setup.h).
>
> Since I don't think we want to do the m68k/m68knommu merge right now
> (Sorry Arnd, I'll keep your script in mind anyway!), the simplest way is to:
>  - Remove all files from class 2, and add to the Makefile:

Does this work with the exported headers? I guess it should if you
always use the m68k exports for m68knommu as well, but if that's
possible is is a question you haven't answered yet.

Right now, you would remove the following exported headers from m68knommu:
auxvec.h, errno.h, fcntl.h, ioctl.h, ioctls.h, ipcbuf.h, mman.h, msgbuf.h,
poll.h, posix_types.h, resource.h, sembuf.h, shmbuf.h, socket.h, stat.h,
statfs.h, termbits.h.

If you don't want to use the m68k exports on m68knomu, you'd also have
to duplicate all these.

	Arnd <><
