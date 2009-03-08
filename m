Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbZCHLFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbZCHLFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 07:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZCHLEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 07:04:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40028 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZCHLEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 07:04:51 -0400
Date: Sun, 8 Mar 2009 12:04:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: try to detect host_bridge pci_cfg_space
Message-ID: <20090308110437.GA27811@elte.hu>
References: <49B1C50E.5010209@kernel.org> <49B1C69F.70904@zytor.com> <49B1C81B.5010904@zytor.com> <49B1C8C1.4090304@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B1C8C1.4090304@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> H. Peter Anvin wrote:
> > H. Peter Anvin wrote:
> >> Yinghai Lu wrote:
> >>> Impact: get correct pci_cfg_size for host_bridge
> >>>
> >>> more host bridges support 4k cfg, so check them directly
> >>> instead of quirks.
> >>>
> >>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> >> I'm utterly confused by this.  This is basically saying we should try
> >> to probe for an extended device space for every host bridge. 
> >> Logically speaking, this is valid: if there is a valid path by which
> >> we can probe for byte 256 then it should succeed.
> >>
> >> HOWEVER, the same argument applies for *every single device*.  So if
> >> this does indeed work, why should we limit it to host bridges?
> >>
> > 
> > Looking at the code (as opposed to just the patch) made it a bit
> > clearer.  The argument you're making here is that only host bridges are
> > known to have extended address space without also having a PCI-X
> > extension header, right?
> 
>  
> Yes.

This too should go into the v2 patch description. 

I'd also suggest to flip around the subject line from x86/pci to 
pci/x86 - it's more of a PCI patch than a pure x86 patch. The 
same problem could affect other platforms too i suspect.

	Ingo
