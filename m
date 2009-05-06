Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbZEFMgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbZEFMgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbZEFMfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:35:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39906 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760041AbZEFMfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:35:07 -0400
Date: Wed, 6 May 2009 14:33:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH 1/4] pci/x86: don't assume pref memio are 64bit -v4
Message-ID: <20090506123346.GA19541@elte.hu>
References: <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes> <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes> <49EFCE15.3030605@kernel.org> <20090423132202.GB13984@jurassic.park.msu.ru> <49F08580.9050407@kernel.org> <20090423221936.GA24171@jurassic.park.msu.ru> <49F13690.3080902@kernel.org> <20090505115248.63d112f4@hobbes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505115248.63d112f4@hobbes>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jesse.barnes@intel.com> wrote:

> On Thu, 23 Apr 2009 20:48:32 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > 
> > we should not assign 64bit range to pci device that only take 32bit
> > pref
> > 
> > try to set IORESOURCE_MEM_64 in 64bit resource of
> > pci_device/pci_bridge and make the bus resource only have that bit
> > set when all device under that do support 64bit pref mem then use
> > that flag to allocate resource in wanted area
> > 
> > v2: fix b_res->flags and logic and passing result.
> > v3: split iomem to iomem32, iomem64, and iomem64 will take
> > IORESOURCE_MEM_64 V4: according to Ivan
> >     make it support x86 only, by PCIBIOS_MAX_MEM_32
> >     double check if the bridge does support pref mem64 with
> > write/read UPPER32
> > 
> > [Impact: do assign wrong range to device that doesn't support it]
> 
> Thanks a lot Yinghai & Ivan, I applied 1 & 2 (the other 2 e820 
> patches should go through Ingo), they're in my linux-next branch.

/me wakes up

Yinghai, mind resending those two, with Jesse's Ack included as 
well?

	Ingo
