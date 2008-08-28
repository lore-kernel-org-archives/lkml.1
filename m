Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYH1Upy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYH1Upy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYH1Upo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:45:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50545 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbYH1Upn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:45:43 -0400
Message-ID: <48B70E4F.3080200@zytor.com>
Date: Thu, 28 Aug 2008 13:45:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late
References: <1219952345-13574-1-git-send-email-yhlu.kernel@gmail.com> <alpine.LFD.1.10.0808281255200.3300@nehalem.linux-foundation.org> <48B70ABC.8010805@zytor.com> <alpine.LFD.1.10.0808281334150.3300@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808281334150.3300@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 28 Aug 2008, H. Peter Anvin wrote:
>>     The sucky case, of course, would be an uninitialized BAR pointing 
>> into unusable address space which happens to be reserved in e820.  This 
>> seems very difficult to disambiguate from the above case through any 
>> algorithm that I can think of.
> 
> Yeah, well, the good news is that it should be fairly rare. Any sane PCI 
> device will come out of reset with IO and MEM disabled, and even if some 
> crazy BIOS enables IO/MEM on it and activates the BAR's with some random 
> content, I'm not seeing how that would work well with Windows either if it 
> really was overlapping with some critical real other piece of hardware.
> 
> So I'd _assume_ that something like that would break Windows too, and thus 
> not actually make it into a real product.
> 

I believe you are right.

I think the key bit here is that if the IO or MEM bit is enabled, it's 
likely to be initialized.  The PCI specs say that BARs should come out 
of reset initialized to zero, but I know for a fact that at least 
several Broadcom chips don't -- however, the combination of BAR and 
enable bits should be enough of a sentry.

	-hpa
