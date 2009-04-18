Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZDRTEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZDRTEm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 15:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZDRTEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 15:04:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbZDRTEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 15:04:32 -0400
Date: Sat, 18 Apr 2009 11:57:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
In-Reply-To: <20090418092216.GP7678@elte.hu>
Message-ID: <alpine.LFD.2.00.0904181151230.4042@localhost.localdomain>
References: <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu>
 <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <20090418092216.GP7678@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Apr 2009, Ingo Molnar wrote:
> 
> Am i missing something?

We also try to avoid random motherboard resources etc that aren't reserved 
or documented by the BIOS. It's better to go into big holes. It's also 
better to try to keep as close to the old (tested) behavior.

Now, admittedly those undocumented resources are _much_ more common in IO 
space, but still. They're _very_ common. Om my modern Nehalem thing with 
an Intel BIOS (supposedly "good" and not from some random manufacturer), I 
have, for example:

[   26.533771] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)

byt that one isn't covered by any PnP range or anythign else.

[ Now, it's possible that it's bogus: "0x810" has a bit set in the same 
  bits that cover the mask, and I don't know if the mask is a "ignore 
  these bits" (and the range would thus match all of 0x0800-0x087f) or if 
  the mast is a "port & ~mask == base" in which case nothing would ever 
  match.

  But I _think_ the BIOS literally set up something to answer int he 
  0x08?? range, and didn't document it anywhere. The same can be true of 
  MMIO too, and so we should try to avoid using random memory areas if we 
  can ]

			Linus

