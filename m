Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZF2OqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZF2OqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZF2Opx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:45:53 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:47498
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752782AbZF2Opx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:45:53 -0400
X-SpamScore: -28
X-BigFish: VPS-28(z1039oz1432R9370P98dR936eN1805Mzz1202hzz5a6ciz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KM08ZX-03-JOH-01
Date: Mon, 29 Jun 2009 16:45:36 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ming Lei <tom.leiming@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
	in dma_sync_*_for_cpu
Message-ID: <20090629144536.GP5139@amd.com>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <200906281534.37148.arnd@arndb.de> <20090629123142.GL5139@amd.com> <d82e647a0906290651yc25e38dkce7d59df5dd86d1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <d82e647a0906290651yc25e38dkce7d59df5dd86d1f@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Jun 2009 14:45:36.0625 (UTC) FILETIME=[437E0610:01C9F8C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 09:51:34PM +0800, Ming Lei wrote:
> 2009/6/29 Joerg Roedel <joerg.roedel@amd.com>:
> > On Sun, Jun 28, 2009 at 03:34:35PM +0000, Arnd Bergmann wrote:
> >> On Sunday 28 June 2009 14:39:19 tom.leiming@gmail.com wrote:
> >> > From: Ming Lei <tom.leiming@gmail.com>
> >> >
> >> > dma_sync_*_for_cpu() is introduced to make cpu access dma buffers safely when
> >> > dma transfer is over, it seems there is nothing to do with cpu write buffer,
> >> > so remove it.
> >> >
> >> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> >>
> >> Right, this looks correct. On a related note, flush_write_buffers is
> >> architecture specific right now: only x86 and frv implement it at all,
> >> though and with slightly different semantics.
> >
> > This doen't look correct to me. The sync functions may do bounce buffering
> > which is all about copying data from one place in main memory to another. So we
> > need these flush_write_buffer() calls in the _for_cpu path too.
> 
> IMHO, even we do not call flush_write_buffer(), CPU can read correct
> data from the
> dma buffer since write buffer can't affect cache, right?

flush_write_buffer is not about cache flushing. It is about read/write
reordering in the CPU. Think of it as a memory barrier. On most x86
systems this function is therefore a nop. Cache flushing for
architectures without cache-coherent DMA is typically handled in their
low-level dma-api code (I have seen that at least in parisc32).

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

