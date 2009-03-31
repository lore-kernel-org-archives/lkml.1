Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbZCaA0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbZCaA0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZCaA0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:26:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbZCaA0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:26:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: Removing __kernel_old_uid_t, git_t, dev_t
Date: Tue, 31 Mar 2009 02:26:26 +0200
User-Agent: KMail/1.9.9
Cc: geert.uytterhoeven@gmail.com, michal.simek@petalogix.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
References: <200903301558.10598.arnd@arndb.de> <200903301717.57184.arnd@arndb.de> <20090330.141156.62568451.davem@davemloft.net>
In-Reply-To: <20090330.141156.62568451.davem@davemloft.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903310226.27480.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+w+0CzJ1jYH7XKgvViozu2PUGEhGQVnOGEDA7
 sN9kmgv/byBy8uSogAp5AkvNJaAOYZziOAiOh4JGdxIVLEJ9/3
 ihpqUu/aKp1LYUWioJFWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009, David Miller wrote:
> There is no reason to use anything larger than a 32-bit DMA address
> type on sparc64, and using 32-bit saves lots of space in many
> data structures so I am unlikely to ever change this. :-)

Ok, fair enough. So I'll change my asm-generic/types.h to use

#ifndef dma_addr_t
#ifdef CONFIG_PHYS_ADDR_T_64BIT
typedef u64 dma_addr_t;
#else
typedef u32 dma_addr_t;
#endif /* CONFIG_PHYS_ADDR_T_64BIT */
#endif /* dma_addr_t */

If you eventually want to use the the generic version, you
just need to add

#define dma_addr_t dma_addr_t

before the #include. Or you just ignore the asm-generic version
and don't have to do anything.

	Arnd <><
