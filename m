Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZFIQsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZFIQsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZFIQr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:47:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZFIQrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:47:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 01/27] score: create Kconfig Kconfig.debug Makefile
Date: Tue, 9 Jun 2009 18:47:12 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OF2086513E.4B4F803C-ON482575D0.0022E294-482575D0.0023688F@sunplusct.com>
In-Reply-To: <OF2086513E.4B4F803C-ON482575D0.0022E294-482575D0.0023688F@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091847.13539.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18XoF8QzpgXrCAFLLkGtVa5jrIk0LVuD1k4lCN
 boR2tV5L743PUqdOvES+kfWVCGKhuMIsraypjVPeX63Qi8HjpX
 W1XUrzTwfoeijyPL/XFog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:

> +++ b/arch/score/Kconfig
> @@ -0,0 +1,243 @@
> +config SCORE
> +       bool
> +       default y
> +       select EMBEDDED

I don't think you should select EMBEDDED. The option is slightly
misnamed and just enables some other config options. If you need
any of those that are protected by EMBEDDED, then maybe select those
directly.

> +config NO_DMA
> +       bool
> +       default y

Are you planning to implement DMA support? We just had a lenghty
discussion about how to do it generically. While we did not find
a solution, you can probably easily take the
asm-generic/dma-mapping-linear.h I posted and adapt that to your
needs.

> +config SCORE_L1_CACHE_SHIFT
> +       int
> +       default "5"

Your arch/score/include/asm/cache.h contains

#define L1_CACHE_SHIFT         4

One of the two looks wrong ;-)

If you have different cache implementations, this value
should probably be the maximum of all CPUs that are configured
in the kernel.

> +config HZ
> +       int
> +       default 100

Have you looked into implementing NO_HZ? It is not required in any
way, but can probably reduce your power consumption, which may be
interesting for embedded systems.

> +config KEXEC
> +       bool "Kexec system call (EXPERIMENTAL)"
> +       depends on EXPERIMENTAL
> +       help

Do you actually support this? I did not look very closely,
but could not find anything about kexec in the other patches.
If not, just drop the config option.

	Arnd <><
