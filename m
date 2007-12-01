Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbXLANZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbXLANZE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 08:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXLANYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 08:24:55 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48172 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752559AbXLANYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 08:24:54 -0500
Date: Sat, 1 Dec 2007 13:20:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
Message-ID: <20071201132047.2bf3c40c@the-village.bc.nu>
In-Reply-To: <20071201003333.GR29463@stusta.de>
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
	<20071201003333.GR29463@stusta.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 01:33:33 +0100
Adrian Bunk <bunk@kernel.org> wrote:

> On Thu, Nov 29, 2007 at 04:19:51PM -0800, H. Peter Anvin wrote:
> > When the conversion factor between jiffies and milli- or microseconds
> > is not a single multiply or divide, as for the case of HZ == 300, we
> > currently do a multiply followed by a divide.  The intervening
> > result, however, is subject to overflows, especially since the
> > fraction is not simplified (for HZ == 300, we multiply by 300 and
> > divide by 1000).
> >...
> >  kernel/Makefile     |    8 +++
> >  kernel/time.c       |   29 +++++++++---
> >  kernel/timeconst.bc |  123 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 152 insertions(+), 8 deletions(-)
> >  create mode 100644 kernel/timeconst.bc
> >...
> 
> I have read the hep text, but are the advantages of HZ == 300 really 
> visible or was this more theoretical?

Its visibile for people doing PAL media processing and TV sync work.

Longer term we have high precision timers and tickless so for now we can
jut do the HZ == 300 math in steps to avoid the overflow. Slower but in
time it won't matter.

Alan
