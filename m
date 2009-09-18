Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZIRLPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZIRLPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbZIRLPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:15:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60444 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbZIRLPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:15:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Caveh Jalali <ecaveh@gmail.com>
Subject: Re: [patch] Makefile: can't build modules outside the kernel tree if it was built using O=
Date: Fri, 18 Sep 2009 11:28:55 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com> <200909171345.30988.arnd@arndb.de> <830a8fa70909171449s597931a2t51f37be6378ddef7@mail.gmail.com>
In-Reply-To: <830a8fa70909171449s597931a2t51f37be6378ddef7@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909181128.56303.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/muf08agcQ4B7IUDaEWmFp8P0KhnsnEcbuhWn
 3fsFb/lQR/b8rmP4qM+/ZGtnqtICijisgEPh6NcMqD8hKOt2VT
 O2O5HqBv0TFqt9h+8WRhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 September 2009, Caveh Jalali wrote:
> sadly, some 3rd party src packages don't quite do the right thing with
> their kernel include paths and still depend on the include2/asm symlink
> to find the platform header files.
> 
> i see your point about include2 being somewhat redundant/legacy, however,
> as long as we are creating it, we should have it point to the intended
> location instead of being a dead link!

I guess we could just as well put something in there to notify such
programs of how to use the kernel Makefiles. External packages should
not try to guess the layout of the kernel source tree, they can only
get it wrong anyway.

There are apparently also user space packages trying to access 
/lib/modules/${krel}/build/arch/${arch}/include/, which is even
more wrong.

I'm thinking about adding something in <linux/kernel.h> to warn
about this when using the kernel headers without either '-D__KERNEL__'
or 'make headers_install'. Is there any valid case that this would
break? It should probably give a warning that includes a http URL
holding a description of what to do.

	Arnd <><

