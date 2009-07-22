Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZGVNpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZGVNpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbZGVNpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:45:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63898 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZGVNo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:44:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Do cpu-endian MMIO accessors exist?
Date: Wed, 22 Jul 2009 15:44:40 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       lethal@linux-sh.org, linux-sh@vger.kernel.org
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi> <200907221035.50025.arnd@arndb.de> <20090722094309.10b25290@lxorguk.ukuu.org.uk>
In-Reply-To: <20090722094309.10b25290@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907221544.41054.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18hqZVwioH0uQ25mEjZnBiUB/pomJXVPmtFIRH
 TGhYef3HVPvHImCgcPQM7D1LeobtM77V9eC486JxxA9y+7LRk3
 U5f7U00UXaBcD2itJq5Zw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Alan Cox wrote:
> 
> > in this case. Also, ioread32 should actually multiplex between
> > readl() and inl() based on the address token, as the code in
> > lib/iomap.c does. It's probably easy enough to enable
> > CONFIG_GENERIC_IOMAP on sh, and remove the ioread*/iowrite*
> > macros from arch/sh/include/asm/io.h.
> 
> If your platform is purely MMIO based then ioread32 and readl can become
> the same thing, which is much more efficient. Even if you have port based
> devices that are mapped as MMIO surely its more efficient to do the
> relevant address tweaking in the iomap not in the read ?

I did check that the architecture in question (sh) cannot do this,
because it actually implements board specific PIO functions in
arch/sh/boards/mach-*/io.c.

For architectures that don't need such hacks, I fully agree.

	Arnd <><
