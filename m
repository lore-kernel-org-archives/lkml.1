Return-Path: <linux-kernel-owner+w=401wt.eu-S1763417AbYEIRVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763417AbYEIRVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYEIRUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:20:52 -0400
Received: from outbound-mail-133.bluehost.com ([67.222.39.23]:42368 "HELO
	outbound-mail-133.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750735AbYEIRUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:20:50 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Date: Fri, 9 May 2008 10:20:22 -0700
User-Agent: KMail/1.9.9
Cc: Takashi Iwai <tiwai@suse.de>, Rene Herman <rene.herman@keyaccess.nl>,
       Glauber Costa <gcosta@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <4823AAF2.7070102@keyaccess.nl> <20080509085511.GE2592@elte.hu> <20080509085824.GF2592@elte.hu>
In-Reply-To: <20080509085824.GF2592@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805091020.22541.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 09, 2008 1:58 am Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> > good catch! Queued it up for testing. Jesse, do you concur?
>
> here's the patch below, tidied up.

Yeah, that looks like a clear problem. :)

> ------------------------------->
> Subject: x86/pci: fix broken ISA DMA
> From: Takashi Iwai <tiwai@suse.de>
> Date: Fri, 09 May 2008 08:06:55 +0200
>
> Rene Herman reported:
> > commit 8779f2fc3b84ebb6c5181fb13d702e9944c16069
> >
> > "x86: don't try to allocate from DMA zone at first"
> >
> > breaks all of ISA DMA. Or all of ALSA ISA DMA at least. All
> > ISA soundcards are silent following that commit -- no error
> > messages, everything appears fine, just silence.
>
> That patch is buggy. We had an implicit assumption that
> dev = NULL for ISA devices that require 24bit DMA.
>
> The recent work on x86 dma_alloc_coherent() breaks the ISA DMA buffer
> allocation, which is represented by "dev = NULL" and requires 24bit
> DMA implicitly.

Patch looks good, applied to my 'for-linus' tree.

Thanks,
Jesse
