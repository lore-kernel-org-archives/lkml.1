Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbZF2McQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbZF2McQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZF2McD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:32:03 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:45581 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZF2McC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:32:02 -0400
X-SpamScore: -22
X-BigFish: VPS-22(z1039oz1432R9370P98dR1805Mzz1202hzz5a6ciz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KM02SU-03-EJV-01
Date: Mon, 29 Jun 2009 14:31:42 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: tom.leiming@gmail.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
	in dma_sync_*_for_cpu
Message-ID: <20090629123142.GL5139@amd.com>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <200906281534.37148.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200906281534.37148.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Jun 2009 12:31:42.0861 (UTC) FILETIME=[8EFEEBD0:01C9F8B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 03:34:35PM +0000, Arnd Bergmann wrote:
> On Sunday 28 June 2009 14:39:19 tom.leiming@gmail.com wrote:
> > From: Ming Lei <tom.leiming@gmail.com>
> > 
> > dma_sync_*_for_cpu() is introduced to make cpu access dma buffers safely when
> > dma transfer is over, it seems there is nothing to do with cpu write buffer,
> > so remove it.
> > 
> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> 
> Right, this looks correct. On a related note, flush_write_buffers is
> architecture specific right now: only x86 and frv implement it at all,
> though and with slightly different semantics.

This doen't look correct to me. The sync functions may do bounce buffering
which is all about copying data from one place in main memory to another. So we
need these flush_write_buffer() calls in the _for_cpu path too.

> Maybe it would be more consistent to change the dma_map_* and
> dma_sync_*_for_device stuff there to wmb() to make it  portable
> to other architectures.

If we change it to wmb() it would be executed every time there even if the
processor doesn't require it. Other architectures could simply add a
flush_write_buffers() implemention if they want to adapt the common dma-mapping
implementation, no?

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

