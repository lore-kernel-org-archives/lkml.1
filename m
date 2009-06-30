Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbZF3Mt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbZF3Mt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZF3MtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 08:49:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZF3MtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 08:49:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in dma_sync_*_for_cpu
Date: Tue, 30 Jun 2009 14:48:54 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: Joerg Roedel <joerg.roedel@amd.com>, tom.leiming@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <200906301434.26815.arnd@arndb.de> <20090630134000.23674147@lxorguk.ukuu.org.uk>
In-Reply-To: <20090630134000.23674147@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906301448.55064.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19U8ngWxdWSrc1oPjcMaHk9Vm827Fp3l2QfqPN
 t6LMlZQoqi6J+u3WaAv1MaKLZgdwxTTYeHq0nljAOC7GEx+U9u
 d+vpCzrk8G++ipeT8vyiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 June 2009, Alan Cox wrote:
> > Ok. The Winchip also does not have an IOMMU or the need for SWIOTLB, so
> > I guess it would be ok to move the flush_write_buffers() out of the common
> > code into the x86 pci-nommu implementation. That one is also the only
> > place that calls flush_write_buffers() in dma_map_().
> 
> What about non x86 - this is asm-generic you are playing with and its the
> kind of change that causes evil really hard to track down and subtle
> corruptions and user data loss if you get it wrong.

Non-x86 is the real motivation for the patch, because the flush_write_buffers
call in this file is currently not implemented and causes build errors
on everything but x86, frv, ia64 and m32r, where the latter two implement
it as an empty macro.

The only users of the file right now are x86 and ia64, and ia64 only added
the empty flush_write_buffers() definition in order to use it.

	Arnd <><
