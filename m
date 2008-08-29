Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYH2P1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYH2P1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYH2P1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:27:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbYH2P1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:27:45 -0400
Date: Fri, 29 Aug 2008 08:26:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4
In-Reply-To: <20080829063012.GA19459@elte.hu>
Message-ID: <alpine.LFD.1.10.0808290824070.3300@nehalem.linux-foundation.org>
References: <1219973391-9580-1-git-send-email-yhlu.kernel@gmail.com> <20080829063012.GA19459@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Ingo Molnar wrote:
> 
>  BIOS-e820: 0000000077ff0000 - 0000000078000000 (reserved)
>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> 
> which overlaps with the chipset PCI BAR (hpet) resource:
> 
>    pci 0000:00:14.0: BAR has HPET at fed00000-fed003ff
> 
> so due to this 1K conflict we take the full e820-reserved entry out and 
> give the range 0xfec00000-0x100000000 as 'free'.

That's wrong. It's a full overlap, so "insert_resource()" should happily 
insert the 00000000fec00000 - 0000000100000000 _around_ the HPET bar.

Do you actually see this behavior, or do you just misunderstand how 
"insert_resource()" works?

			Linus
