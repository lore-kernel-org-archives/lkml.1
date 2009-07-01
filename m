Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbZGATnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbZGATnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZGATne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:43:34 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2236 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbZGATnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:43:33 -0400
Subject: Re: [PATCH] fix round_up/down
From: Joe Perches <joe@perches.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
In-Reply-To: <4A4BBA12.8070507@kernel.org>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
	 <4A484A8A.9020704@zytor.com>
	 <19016.41349.636663.515540@pilspetsen.it.uu.se>
	 <20090629112155.GJ5480@parisc-linux.org>
	 <19016.44061.600652.676183@pilspetsen.it.uu.se>
	 <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org>
	 <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com>
	 <4A4966EF.6010809@kernel.org>
	 <alpine.LFD.2.01.0906291820060.3605@localhost.localdomain>
	 <4A496D4B.3040608@kernel.org>
	 <19017.53428.834539.389495@pilspetsen.it.uu.se>
	 <4A4A25B1.5010102@zytor.com> <4A4A6888.30001@kernel.org>
	 <4A4A6B1C.7030405@zytor.com> <4A4A701F.3050700@kernel.org>
	 <4A4A81C9.9070008@zytor.com> <4A4A88A2.7010509@kernel.org>
	 <alpine.LFD.2.01.0906301456170.3605@localhost.localdomain>
	 <4A4A921F.7080100@kernel.org>
	 <alpine.LFD.2.01.0906301559390.3605@localhost.localdomain>
	 <alpine.LFD.2.01.0906301603280.3605@localhost.localdomain>
	 <4A4A9C2F.80808@kernel.org> <4A4A9D8E.5080500@zytor.com>
	 <4A4BB9C2.8020304@kernel.org>  <4A4BBA12.8070507@kernel.org>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 12:39:35 -0700
Message-Id: <1246477175.28915.52.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 12:33 -0700, Yinghai Lu wrote:
> --- linux-2.6.orig/include/linux/kernel.h
> +++ linux-2.6/include/linux/kernel.h
[]
>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> +#define rounddown(x, y) (((x) / (y)) * (y))
[]
> +#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
> +#define round_down(x,y) ((x) & ~__round_mask(x,y))

Isn't this just asking for trouble?

How about a better name?
Maybe masked_roundup, or roundup_ala_zorro...

