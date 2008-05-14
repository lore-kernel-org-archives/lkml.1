Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbYENEC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbYENEC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbYENECs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:02:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37865 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYENECr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:02:47 -0400
Date: Tue, 13 May 2008 21:02:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "=?UTF-8?B?Uy7Dh2HEn2xhcg==?= Onur" <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
Message-ID: <20080513210217.59a7ca65@infradead.org>
In-Reply-To: <482A05F3.7020408@firstfloor.org>
References: <20080513204206.GA17781@damson.getinternet.no>
	<873aol9b73.fsf@basil.nowhere.org>
	<19f34abd0805131409w2914fbedgb608c7b87c234e2e@mail.gmail.com>
	<482A05F3.7020408@firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 23:19:47 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> 
> Ok the CPU reports it doesn't support any C states in MWAIT. If that
> is correct then it would be correct to not use MWAIT idle and might
> actually save more power to not use it.

what does the current SVN powertop say on this cpu?

> 
> I don't know if that's true or not. Do you have a power meter perhaps?
> If yes can you measure if there's a difference between mwait=idle /
> default on your box when it is idle?
> 
> [cc Arjan he might now if that CPU is supposed to support C1 in MWAIT]

I wasn't aware that P4's supported mwait in this way; I thought it was
core and later.

> CPU reports it supports C1/C2/C3. Are you sure there is a difference
> on that box? The code should have kept using MWAIT because it checks
> C1. Please double check.

The check is .. dubious I suspect... because the cpuid bits are not
actually the prime source of information, the BIOS is.
If the bios says mwait is usable, we need to use it with the values IT
gives us.
