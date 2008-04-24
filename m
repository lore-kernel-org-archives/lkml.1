Return-Path: <linux-kernel-owner+w=401wt.eu-S1764992AbYDXPar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764992AbYDXPar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760634AbYDXPUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:20:30 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:60754 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762506AbYDXPU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:20:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH RFC] x86: Fix 64-bit DMA masks on VIA
Date: Thu, 24 Apr 2008 17:19:55 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, vojtech@suse.cz,
       muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com
References: <200804232055.13102.mb@bu3sch.de> <200804241606.00883.mb@bu3sch.de> <20080424153240.33b5300c@the-village.bc.nu>
In-Reply-To: <20080424153240.33b5300c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241719.55768.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2008 16:32:40 Alan Cox wrote:
> On Thu, 24 Apr 2008 16:06:00 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > On Thursday 24 April 2008 15:43:50 Andi Kleen wrote:
> > > Michael Buesch <mb@bu3sch.de> writes:
> > > 
> > > > This untested patch is supposed to fix DMAing on some VIA boards.
> > > > Currently the DMA subsystem returns an error, if the driver does
> > > > tell that it supports a 64bit DMA mask. So the driver probing
> > > > would fail in that case. 
> > > 
> > > The driver is broken then. It is supposed to retry with a small
> > > mask on an error. Please fix the driver.
> > 
> > I already added a workaround to the driver.
> > Why do we need to workaround this in _every_ driver? (Note that _every_
> > driver supporting a 64bit mask is affected). Why not fix it in the DMA layer?
> 
> Some hardware wants to know it can get a given DMA mask or failure. I
> agree however that a "pci_prefer_64bit_dma(pdev)" function would be a
> good patch for someone to submit tot he PCI layer code.

Yeah well. I see the issue. However, I think the actual probing should
be done in the DMA layer. We could pass dma_set_mask() the mask as a pointer
and modify the mask value to what is actually used. So the driver would
know what mask we felt back to. That was actually my first idea,
but I preferred to submit a more simple solution without an API change
to the list.

However, in the end I don't care too much, as our driver is fixed.
I just think that we will have more of these bugs in the future. Especially,
as this bug won't hit on the majority of platforms.

-- 
Greetings Michael.
