Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZF3Ni7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZF3Ni7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 09:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZF3Niw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 09:38:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53295 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZF3Niv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 09:38:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in dma_sync_*_for_cpu
Date: Tue, 30 Jun 2009 15:38:43 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: Joerg Roedel <joerg.roedel@amd.com>, tom.leiming@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <200906301448.55064.arnd@arndb.de> <20090630140945.0784e174@lxorguk.ukuu.org.uk>
In-Reply-To: <20090630140945.0784e174@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906301538.44684.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/uZSVU1f+ENkli2D7dT9Qb9DvDUpPIjeITLmq
 rdfady19+8J19vTv16/n9EvElruxIQQUHBdqwhtxmc03/7N671
 DxEWVvXRn73yfVgPElnH2fQ5CNr1922
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 June 2009, Alan Cox wrote:
> > > What about non x86 - this is asm-generic you are playing with and its the
> > > kind of change that causes evil really hard to track down and subtle
> > > corruptions and user data loss if you get it wrong.
> > 
> > Non-x86 is the real motivation for the patch, because the flush_write_buffers
> > call in this file is currently not implemented and causes build errors
> > on everything but x86, frv, ia64 and m32r, where the latter two implement
> > it as an empty macro.
> 
> Ok so the FRV would grow a similar no iommu patch to the x86.

Well, not even that. dma-mapping-common.h only makes sense on architectures
that have multiple dma-mapping implementations (parisc, mips, arm, powerpc,
sparc, ia64 and x86, possibly alpha). All others including frv only need a
nommu case anyway and would not use dma-mapping-common.h but could be
changed to use something like the dma-mapping-linear.h I worked on recently.

	Arnd <><
