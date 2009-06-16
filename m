Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbZFPRo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbZFPRo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbZFPRoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:44:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60297 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbZFPRoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:44:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
Date: Tue, 16 Jun 2009 19:43:38 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Scott Wood <scottwood@freescale.com>,
       Chris Pringle <chris.pringle@oxtel.com>, linux-kernel@vger.kernel.org
References: <4A37A503.3030209@oxtel.com> <4A37CF02.5080906@oxtel.com> <4A37D073.6020802@freescale.com>
In-Reply-To: <4A37D073.6020802@freescale.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906161943.38764.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18E9as+/a/3GzdD1RYMPZfXdTbgGsXOQw2gNDw
 djt35U8P7R0Fb6hUUsei/xlBSlNYqVRAMY5a9Zf1lti+W4hZiY
 x5/953kDUNz6xEjBJkPaS2wNblXxCmt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 June 2009, Scott Wood wrote:
> Chris Pringle wrote:
> > Ah right - that would explain what we're seeing then... Doh. Thought I 
> > might have been onto something then. Is there any way to force a cache 
> > flush? That'd at least prove it was a caching issue if it resolved the 
> > problem.
> 
> You could enable CONFIG_NOT_COHERENT_CACHE.

If the whole system is noncoherent, that is the right solution. If the
device is the only one, you can also use dma_alloc_noncoherent() and
flush explicitly with dma_cache_sync().

	Arnd <><
