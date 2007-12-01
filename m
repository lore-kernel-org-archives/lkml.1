Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbXLAAdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbXLAAdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 19:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbXLAAdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 19:33:41 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54817 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756533AbXLAAdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 19:33:40 -0500
Date: Sat, 1 Dec 2007 01:33:33 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
Message-ID: <20071201003333.GR29463@stusta.de>
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 04:19:51PM -0800, H. Peter Anvin wrote:
> When the conversion factor between jiffies and milli- or microseconds
> is not a single multiply or divide, as for the case of HZ == 300, we
> currently do a multiply followed by a divide.  The intervening
> result, however, is subject to overflows, especially since the
> fraction is not simplified (for HZ == 300, we multiply by 300 and
> divide by 1000).
>...
>  kernel/Makefile     |    8 +++
>  kernel/time.c       |   29 +++++++++---
>  kernel/timeconst.bc |  123 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 152 insertions(+), 8 deletions(-)
>  create mode 100644 kernel/timeconst.bc
>...

I have read the hep text, but are the advantages of HZ == 300 really 
visible or was this more theoretical?

In the latter case, we might remove the HZ == 300 choice instead.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

