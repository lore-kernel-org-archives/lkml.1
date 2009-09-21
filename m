Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZIUIbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZIUIbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 04:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbZIUIbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 04:31:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbZIUIbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 04:31:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] remove duplicate asm/mman.h files
Date: Mon, 21 Sep 2009 10:31:25 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-10-generic; KDE/4.3.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, ebmunson@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       randy.dunlap@oracle.com, rth@twiddle.net, ink@jurassic.park.msu.ru,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
References: <cover.1251197514.git.ebmunson@us.ibm.com> <200909181848.42192.arnd@arndb.de> <alpine.DEB.1.00.0909181236190.27556@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0909181236190.27556@chino.kir.corp.google.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909211031.25369.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/AZvRcdcveqEc4gqiNxwRo/p5RQU/zyjnvcvx
 oXajnQPO2JbGPjrF2yAUvuOj7fJ9QHmvQwFyo7Sz1mdxx1ulyQ
 Z0hch62V9n0Oxv0ODc32Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 September 2009, David Rientjes wrote:
> On Fri, 18 Sep 2009, Arnd Bergmann wrote:
>
> > -#define MCL_CURRENT	1		/* lock all current mappings */
> > -#define MCL_FUTURE	2		/* lock all future mappings */
> > +#define MAP_GROWSUP	0x0200		/* register stack-like segment */
> >  
> >  #ifdef __KERNEL__
> >  #ifndef __ASSEMBLY__
> 
> ia64 doesn't use MAP_GROWSUP, so it's probably not necessary to carry it 
> along with your cleanup.

ia64 is the only architecture defining it, nobody uses it in the kernel.
If the ia64 maintainers want to remove it in a separate patch, that
would probably be a good idea.

I tried not to change the ABI in any way in my patch, and there is
a theoretical possibility that some user space program on ia64 currently
depends on that definition.

	Arnd <><
