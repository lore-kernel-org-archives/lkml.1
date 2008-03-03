Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbYCCXLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbYCCXLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYCCXLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:11:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51467 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYCCXLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:11:35 -0500
Message-ID: <47CC83F5.3020702@zytor.com>
Date: Mon, 03 Mar 2008 15:04:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Segher Boessenkool <segher@kernel.crashing.org>, hans.rosenfeld@amd.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com> <962471e5d2b8c88858dd5e0f50269751@kernel.crashing.org> <4ffd9be7b13d6300b888c146d6d040d5@kernel.crashing.org> <a9af8424f96a9118c6b097d9b2df79b2@kernel.crashing.org> <47CC8211.7090704@goop.org>
In-Reply-To: <47CC8211.7090704@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> I went through and made a bunch of these flags signed so that they would 
> sign-extend properly in 32 vs 64 bit.  We could make them 
> unconditionally 64-bit, but I'm worried that will have unforeseen 
> consequences too.
> 
> In this case, PAGE_MASK should probably be signed too, so the sign 
> extension happens properly.
> 

Yes, it should.

> Alternatively, they could be cast to pteval_t and/or phys_addr_t so that 
> they will have an inherent size which matches the pagetable format 
> (using _AT() rather than _AC()).

Either that, or we could use a custom constructor macro (PTEVAL_C()). 
This is arguably The Right Thing, but the sign-extending version is OK, too.

	-hpa
