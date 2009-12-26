Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbZLZQke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbZLZQke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 11:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZLZQkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 11:40:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51017 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZLZQkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 11:40:32 -0500
Date: Sat, 26 Dec 2009 17:40:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Hounschell <markh@compro.net>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
Message-ID: <20091226164029.GA10256@basil.fritz.box>
References: <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org> <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain> <20091223170832.GH20539@basil.fritz.box> <20091225132116.6c9089f2@infradead.org> <20091225203304.GA22306@basil.fritz.box> <20091226103835.68479100@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091226103835.68479100@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Does pmqos work with apci=off etc.? 
> 
> yes
> 
> > I didn't think it shut down
> > the classic "HLT" idle, does it? 
> 
> it does if you specify a latency of 0; it will then go into the
> spin-only state until you give up your latency requirement

I looked at it this evening, but it seems like pm_qos is not
interrupt safe (e.g. calls blocking notifiers) and floppy currently does 
enable/disable_hlt from interrupts and bottom halves.  

Would need some more infrastructure work or restructuring 
of the floppy driver.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
