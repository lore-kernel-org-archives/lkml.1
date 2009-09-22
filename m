Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZIVMJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZIVMJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZIVMJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:09:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:55040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbZIVMJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:09:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: best practices:  which "uaccess.h" should one include?
Date: Tue, 22 Sep 2009 14:09:02 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-10-generic; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0909220226080.10448@localhost>
In-Reply-To: <alpine.LFD.2.00.0909220226080.10448@localhost>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909221409.02211.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18PDVsZbdFIJO1kF3rujT9UJldU/cZSJgVfrlU
 LdpYTtkS9uH0hz9QkqwiXrMBzPAU/bNEiIuBwTY4uti3U4ndP4
 o+nq358b8lhgMNR0lX7zw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Robert P. J. Day wrote:
>   philosophically, which is the "correct" uaccess.h header file to
> include in kernel code -- <linux/uaccess.h> or <asm/uaccess.h>?  the
> first explicitly includes the second so that's a safe choice but,
> generally, there's been a tendency to shift toward including the
> "linux" header files.  opinion?  there's quite a mixture under the
> drivers/ directory.

The preferred one is linux/uaccess.h, the same is true for many
headers that traditionally only existed in asm/.

There are some headers with explicit #warning or #error messages
when they are not included from linux/foo.h, e.g. spinlock_types.h,
bitops.h or rwsem.h.

Other headers include each other both ways, e.g. futex.h, which means
that you can use either one, though it might be good to move to
a common location if that doesn't cause too much churn.

	Arnd <><
