Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbZFOOD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbZFOOD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZFOODu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:03:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49527 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZFOODt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:03:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] asm-generic: add EMAXERRNO
Date: Mon, 15 Jun 2009 16:02:42 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: liqin.chen@sunplusct.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
References: <OF48364F7F.ED6F93C7-ON482575D6.0042A7E0-482575D6.0043654D@sunplusct.com> <200906151530.10299.arnd@arndb.de> <20090615133151.GI19977@parisc-linux.org>
In-Reply-To: <20090615133151.GI19977@parisc-linux.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906151602.42873.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX192il/HMKKcmIbTlAWPb9zNy+L5SXMSBKezRLa
 SNluaTdgig9OjHQfO/B3jiu/4bQOFSJK9ZSLQATsCBJXWWTU6D
 okwQ0AaARFwD2z6+OHVHQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 June 2009, Matthew Wilcox wrote:
> On Mon, Jun 15, 2009 at 03:30:09PM +0200, Arnd Bergmann wrote:
> > Some architectures want to flag error returns from a syscall based on
> > the return value. The range from zero to -511 is for errors that
> > we can return to user space, so add a #define for this to
> > include/asm-generic/errno.h.
> 
> I thought we could return anything up to -4095.

Sort of, yes. Internally to the kernel, we use anything up to 4095,
that's e.g. IS_ERR_VALUE checks for.

Error numbers from 512 to 4095 are internal and should never be seen
by the user.

In reality, it probably does not matter at all because we know what
error numbers we use. Now that you pointed me to include/linux/err.h,
that already defines MAX_ERRNO.

Liqin, I think I'd prefer to just drop my patch again, and you can
use MAX_ERRNO, which is defined in err.h.

	Arnd <><
