Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbZJ0I6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbZJ0I6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932124AbZJ0I6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:58:13 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:24431 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbZJ0I6N convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;6:1>);
	Tue, 27 Oct 2009 04:58:13 -0400
Message-Id: <4AE6C436020000780001BF10@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 27 Oct 2009 08:58:14 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Cc: <yinghai@kernel.org>, <tglx@linutronix.de>, <tiwai@suse.de>,
       <linux-kernel@vger.kernel.org>, <jbarnes@virtuousgeek.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent
	 allocations
References: <20091026152246.GB3749@elte.hu>
 <4AE5D238020000780001BD46@vpn.id2.novell.com>
 <20091026201917.GE24682@elte.hu>
 <20091027103758L.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091027103758L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> 27.10.09 02:38 >>>
>On Mon, 26 Oct 2009 21:19:17 +0100
>Ingo Molnar <mingo@elte.hu> wrote:
>> Well, can ISA_BIT_MASK fall back to DMA_BIT_MASK(32) on !CONFIG_ISA? If 
>> we have ISA support disabled we might as well pretend the whole world is 
>> PCI, right?
>
>I don't think that it works. At least, you can't do that with
>the DMA_BIT_MASK(24) in arch/x86/kernl/pci-dma.c; it must be
>DMA_BIT_MASK(24) even with !CONFIG_ISA.

This one I too was about to point out, which is why I think
DMA_ISA_BIT_MASK should only be an alias of DMA_BIT_MASK(24), with
no fallback to DMA_BIT_MASK(32).

>> That way we'd get rid of that #ifdef in the .c code too.
>
>Well, in the first place, we don't need the #ifdef in Jan's patch. We
>can always use DMA_BIT_MASK(24) for the fallback device.

But this one I don't agree with - the purpose of the patch is to not have
a 24-bit (or 32-bit) mask here unconditionally: It would result in GFP_DMA
to be forced on for the allocation (which the patch specifically eliminates),
and for x86-64 this wasn't the case up to .25, which is the behavior I'm
trying to restore (and extend to the !CONFIG_ISA case for ix86).

Jan

