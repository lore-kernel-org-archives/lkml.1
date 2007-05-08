Return-Path: <linux-kernel-owner+w=401wt.eu-S934963AbXEHJyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934963AbXEHJyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934956AbXEHJyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:54:33 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:50462 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934957AbXEHJyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:54:31 -0400
Date: Tue, 8 May 2007 11:54:21 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Esben Nielsen <nielsen.esben@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Message-ID: <20070508095421.GA10456@linuxtv.org>
References: <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com> <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire> <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org> <Pine.LNX.4.64.0705071159530.14011@frodo.shire> <alpine.LFD.0.98.0705070921390.3802@woody.linux-foundation.org> <20070507183931.GB3472@linuxtv.org> <Pine.LNX.4.64.0705080931460.10409@frodo.shire>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705080931460.10409@frodo.shire>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.108.65
Subject: Re: [patch] CFS scheduler, -v8
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007, Esben Nielsen wrote:
> 
> This is contrary to C99 standeard annex H2.2 
> (http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf):
> 
> "An implementation that defines signed integer types as also being modulo 
> need
> not detect integer overflow, in which case, only integer divide-by-zero need
> be detected."
> 
> So if it doesn't properly defines wrapping it has to detect integer 
> overflow, right?

No. Annex H (informative!) only talks about LIA-1 conformance.

C99 isn't LIA-1 conformant. H2.2 describes what an implementation
might do to make signed integers LIA-1 compatible, which is
what gcc does with -fwarpv or -ftrapv.

At least that's how I understand it, the C99 standard
seems to have been written with the "it was hard to
write, so it should be hard to read" mindset. :-/

I still don't know _why_ signed integer overflow behaviour
isn't defined in C. It just goes against everyones expectation
and thus causes bugs.


Johannes
