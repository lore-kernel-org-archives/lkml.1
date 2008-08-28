Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYH1Ujd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYH1Ujd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbYH1UjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:39:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913AbYH1UjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:39:23 -0400
Date: Thu, 28 Aug 2008 13:38:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late
In-Reply-To: <48B70ABC.8010805@zytor.com>
Message-ID: <alpine.LFD.1.10.0808281334150.3300@nehalem.linux-foundation.org>
References: <1219952345-13574-1-git-send-email-yhlu.kernel@gmail.com> <alpine.LFD.1.10.0808281255200.3300@nehalem.linux-foundation.org> <48B70ABC.8010805@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Aug 2008, H. Peter Anvin wrote:
>
>     The sucky case, of course, would be an uninitialized BAR pointing 
> into unusable address space which happens to be reserved in e820.  This 
> seems very difficult to disambiguate from the above case through any 
> algorithm that I can think of.

Yeah, well, the good news is that it should be fairly rare. Any sane PCI 
device will come out of reset with IO and MEM disabled, and even if some 
crazy BIOS enables IO/MEM on it and activates the BAR's with some random 
content, I'm not seeing how that would work well with Windows either if it 
really was overlapping with some critical real other piece of hardware.

So I'd _assume_ that something like that would break Windows too, and thus 
not actually make it into a real product.

Maybe.

			Linus
