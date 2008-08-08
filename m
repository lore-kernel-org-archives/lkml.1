Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYHHJ1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYHHJ1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYHHJ12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:27:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:56063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYHHJ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:27:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/4] kernel-based checkpoint restart
Date: Fri, 8 Aug 2008 11:25:12 +0200
User-Agent: KMail/1.9.9
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <20080807224033.FFB3A2C1@kernel>
In-Reply-To: <20080807224033.FFB3A2C1@kernel>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081125.12706.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+bRsNBLXY6Mnp6GMzXR8bDFvP6tDv4DwY/XIp
 WpCQo1hixepWV6NmjBaPfMr03QKjF4AeXAgAA+RDZ4G9qUmAAC
 ixhb/0jw0IzFIk44ZtXMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008, Dave Hansen wrote:
> These patches are from Oren Laaden.  I've refactored them
> a bit to make them a wee bit more reviewable.  I think this
> separates out the per-arch bits pretty well.  It should also
> be at least build-bisetable.

Cool stuff

> ============================== ckpt.c ================================
> 
> #define _GNU_SOURCE        /* or _BSD_SOURCE or _SVID_SOURCE */
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <errno.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <asm/unistd_32.h>
> #include <sys/syscall.h>

Note that asm/unistd_32.h is not portable, you should use asm/unistd.h
in the example.

>         pid_t pid = getpid();
>         int ret;
>
>         ret = syscall(__NR_checkpoint, pid, STDOUT_FILENO, 0);

Interface-wise, I would consider checkpointing yourself signficantly
different from checkpointing some other thread. If checkpointing
yourself is the common case, it probably makes sense to allow passing
of pid=0 for this.

	Arnd <><
