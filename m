Return-Path: <linux-kernel-owner+w=401wt.eu-S936954AbYD1QzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936954AbYD1QzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934912AbYD1Qyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:54:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49482 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935358AbYD1Qyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:54:51 -0400
Date: Mon, 28 Apr 2008 18:53:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michael Buesch <mb@bu3sch.de>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, vojtech@suse.cz,
       muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH RFC] x86: Fix 64-bit DMA masks on VIA
Message-ID: <20080428165352.GD18210@elte.hu>
References: <200804232055.13102.mb@bu3sch.de> <87mynjgyg9.fsf@basil.nowhere.org> <200804241606.00883.mb@bu3sch.de> <20080424153240.33b5300c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424153240.33b5300c@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > > This untested patch is supposed to fix DMAing on some VIA 
> > > > boards. Currently the DMA subsystem returns an error, if the 
> > > > driver does tell that it supports a 64bit DMA mask. So the 
> > > > driver probing would fail in that case.
> > > 
> > > The driver is broken then. It is supposed to retry with a small 
> > > mask on an error. Please fix the driver.
> > 
> > I already added a workaround to the driver. Why do we need to 
> > workaround this in _every_ driver? (Note that _every_ driver 
> > supporting a 64bit mask is affected). Why not fix it in the DMA 
> > layer?
> 
> Some hardware wants to know it can get a given DMA mask or failure. I 
> agree however that a "pci_prefer_64bit_dma(pdev)" function would be a 
> good patch for someone to submit tot he PCI layer code.

yes, and i suspect Michael is correct in suggesting that the majority of 
drivers would use that interface and would let the PCI layer handle the 
probing/fallback details. (Jesse Cc:-ed)

	Ingo
