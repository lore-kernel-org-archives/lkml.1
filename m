Return-Path: <linux-kernel-owner+w=401wt.eu-S966022AbYD1REs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966022AbYD1REs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933780AbYD1REh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:04:37 -0400
Received: from outbound-mail-118.bluehost.com ([69.89.22.18]:54047 "HELO
	outbound-mail-118.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965129AbYD1REg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:04:36 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC] x86: Fix 64-bit DMA masks on VIA
Date: Mon, 28 Apr 2008 10:04:07 -0700
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Michael Buesch <mb@bu3sch.de>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, vojtech@suse.cz,
       muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com
References: <200804232055.13102.mb@bu3sch.de> <20080424153240.33b5300c@the-village.bc.nu> <20080428165352.GD18210@elte.hu>
In-Reply-To: <20080428165352.GD18210@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281004.07989.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 28, 2008 9:53 am Ingo Molnar wrote:
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > > > This untested patch is supposed to fix DMAing on some VIA
> > > > > boards. Currently the DMA subsystem returns an error, if the
> > > > > driver does tell that it supports a 64bit DMA mask. So the
> > > > > driver probing would fail in that case.
> > > >
> > > > The driver is broken then. It is supposed to retry with a small
> > > > mask on an error. Please fix the driver.
> > >
> > > I already added a workaround to the driver. Why do we need to
> > > workaround this in _every_ driver? (Note that _every_ driver
> > > supporting a 64bit mask is affected). Why not fix it in the DMA
> > > layer?
> >
> > Some hardware wants to know it can get a given DMA mask or failure. I
> > agree however that a "pci_prefer_64bit_dma(pdev)" function would be a
> > good patch for someone to submit tot he PCI layer code.
>
> yes, and i suspect Michael is correct in suggesting that the majority of
> drivers would use that interface and would let the PCI layer handle the
> probing/fallback details. (Jesse Cc:-ed)

With an implied fallback to 32 bits?  Michael's right (at least I think 
Michael's the one being quoted there) that "try 64 then fallback to 32 on 
error" is a pretty common sight, so having a hint that says you'd like 64 but 
don't really care would be a win for drivers.

Michael, want to hack something up?

Thanks,
Jesse


