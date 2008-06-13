Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbYFMO3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbYFMO3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYFMO3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:29:13 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:28747 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYFMO3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:29:12 -0400
X-BigFish: VPS-29(z34a4nz1432R98dR7efV1805Mzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K2EO81-01-2LV-01
Date: Fri, 13 Jun 2008 16:28:43 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>
Subject: Re: [patch 3/6] x86: use cpuinfo to check for interrupt pending
	message msr
Message-ID: <20080613142843.GF7763@alberich.amd.com>
References: <20080610171639.551369443@linutronix.de> <20080610171712.304283554@linutronix.de> <20080613065524.GE7763@alberich.amd.com> <alpine.LFD.1.10.0806131436510.5735@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806131436510.5735@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Jun 2008 14:28:45.0632 (UTC) FILETIME=[C981FC00:01C8CD61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 02:38:30PM +0200, Thomas Gleixner wrote:
> On Fri, 13 Jun 2008, Andreas Herrmann wrote:
> > > +	/* Family 0x0f models < rev F do not have this MSR */
> > > +	if (c->x86 == 0x0f && c->x86_model < 0x40)
> > > +		return 0;
> > 
> > Just some minor nitpicking.
> > Older AMD family 0xf CPUs have this Interrupt Pending Message
> > Register. But they do not support C1E and thus bits 27 and 28 of this
> > MSR are reserved.
> 
> So the check can be simplified to always check the MSR for all 
> family >= 0x0f CPUs ?

First of all I thought of changing the comment.

But now that you ask:
Documentation for older K8 CPUs says that reserved bits in that MSR
are "Read as Zero". But otherwise it also says "Software must not
depend on the state of a reserved field ..."

Maybe I am a little paranoid but I would keep the model check.


Andreas


