Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbZF2PpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbZF2PpC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759670AbZF2PoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:44:18 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:52723
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759531AbZF2PoP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:44:15 -0400
X-SpamScore: -23
X-BigFish: VPS-23(z1039oz1432R98dR936eN1805Mzz1202hzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KM0BPE-01-27Z-01
Date: Mon, 29 Jun 2009 17:44:06 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ming Lei <tom.leiming@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
	in dma_sync_*_for_cpu
Message-ID: <20090629154406.GQ5139@amd.com>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <200906281534.37148.arnd@arndb.de> <20090629123142.GL5139@amd.com> <d82e647a0906290651yc25e38dkce7d59df5dd86d1f@mail.gmail.com> <20090629144536.GP5139@amd.com> <d82e647a0906290754t13bc1b37s6ea6fd582a7fdbe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <d82e647a0906290754t13bc1b37s6ea6fd582a7fdbe@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Jun 2009 15:44:07.0062 (UTC) FILETIME=[6FE03360:01C9F8D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 10:54:51PM +0800, Ming Lei wrote:
> 2009/6/29 Joerg Roedel <joerg.roedel@amd.com>:
> >>
> >> IMHO, even we do not call flush_write_buffer(), CPU can read correct
> >> data from the
> >> dma buffer since write buffer can't affect cache, right?
> >
> > flush_write_buffer is not about cache flushing. It is about read/write
> > reordering in the CPU. Think of it as a memory barrier. On most x86
> 
> You mean we may need a memory barrier between writing data from bouncing buffer
> to dma buffer and reading data from dma buffer, do you?

CONFIG_X86_OOSTORE (when set flush_write_buffers is a memory barrier and not a
nop on x86) is defined for WINCHIP. So it seems necessary on some chips.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

