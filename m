Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYH3TmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYH3TmP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYH3TmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:42:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbYH3Tl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:41:59 -0400
Date: Sat, 30 Aug 2008 12:41:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808301226h1e7a9bb6g721ecdb0f93c5220@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808301238390.3290@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808292157.24179.rjw@sisk.pl>  <alpine.LFD.1.10.0808291434110.3300@nehalem.linux-foundation.org>  <200808300030.32905.rjw@sisk.pl>  <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
  <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>  <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808301150150.3290@nehalem.linux-foundation.org>
 <86802c440808301226h1e7a9bb6g721ecdb0f93c5220@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Aug 2008, Yinghai Lu wrote:
> 
> AMD CPU/NB (quad core aka fam 10h later) has MSR to state MMCONFIG, and
>  the ATI bridge BAR that have same address for MMCONFIG not even have
> chance to decode that, because NB intercept that already.

Ok, so it's similar to the local APIC in that respect (and presumably IO 
APIC too, I haven't checked).

But that still just implies that the BAR probably means something else 
totally, and the fact that it happens to have the same value as the MCFG 
is just random luck.

> it seems ATI chipset doesn't have public version of doc...like reg
> info and BIOS/Kernel porting guide.

Yeah, I'm not finding anything either. The 690G databook that Rafael 
pointed to does mention the config registers in passing, but it's really 
just about electricals (pin setup etc). No BIOS writers guide indeed..

			Linus
