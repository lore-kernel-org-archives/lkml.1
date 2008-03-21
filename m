Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbYCUSDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbYCUSDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbYCUSDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:03:37 -0400
Received: from www.tglx.de ([62.245.132.106]:45244 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995AbYCUSDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:03:36 -0400
Date: Fri, 21 Mar 2008 19:03:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/7] Don't use large pages to map the first 2/4MB of
 memory
In-Reply-To: <20080321175936.GJ2346@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803211859410.3781@apollo.tec.linutronix.de>
References: <20080312353.598285931@firstfloor.org> <20080312025330.AC1961B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211843120.3781@apollo.tec.linutronix.de> <20080321175936.GJ2346@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Andi Kleen wrote:
> > Also we split the first GB mapping anyway due to the various regions
> > (NX, RO, UC) in there.
> 
> I didn't think so unless you have DEBUG_RODATA enabled? 

NX is independent of DEBUG_RODATA and the RODATA protection should be
made unconditional on anyway.

> Also there
> should be no UC region there as known by the kernel. There might
> be a WC region there from the frame buffer code, but that is an MTRR,
> not a pageattr.

The first ioremap of the PCI space splits the GB page as well.

Thanks,

	tglx
