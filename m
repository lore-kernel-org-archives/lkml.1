Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZDPRjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZDPRjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbZDPRjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:39:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486AbZDPRjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:39:21 -0400
Date: Thu, 16 Apr 2009 19:38:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v3
Message-ID: <20090416173805.GC16618@elte.hu>
References: <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <49E76A92.7040203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E76A92.7040203@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Yinghai Lu wrote:
> > 
> > that need to do done much earlier, and much simple, just need to make that range to be reserved in e820.
> > and later e820_setup_gap even don't need to be aligned again.
> > 
> 
> As long as that doesn't cause the PCI layer to move devices 
> already assigned in this range out of it.  What we want is really 
> a "weak reserve".  On the other hand, that may very well be the 
> semantics of the existing reserved space, too (I honestly haven't 
> looked lately.)

We have reserve_region_with_split(), which 'wraps around' existing 
resources non-intrusively by creating split-up resources - 
preventing their forced reallocation (and preventing their possible 
breakage - a number of BARs dont like dynamic reallocations at all).

	Ingo
