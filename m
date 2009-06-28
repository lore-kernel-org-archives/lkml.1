Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbZF1SP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbZF1SP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZF1SPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:15:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61093 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZF1SPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:15:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: tom.leiming@gmail.com
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in dma_sync_*_for_cpu
Date: Sun, 28 Jun 2009 15:34:35 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906281534.37148.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18S6FX+lXePWQRG2sSjMM8wALwYCR3gWEUggd7
 3wAdirIFCHnE2wuVL+HCXCTgCt/G9IiDkutt/BKKZwMqzmULjz
 9uak2pRTH37g6Ok8V19xg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 June 2009 14:39:19 tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> dma_sync_*_for_cpu() is introduced to make cpu access dma buffers safely when
> dma transfer is over, it seems there is nothing to do with cpu write buffer,
> so remove it.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Right, this looks correct. On a related note, flush_write_buffers is
architecture specific right now: only x86 and frv implement it at all,
though and with slightly different semantics.

Maybe it would be more consistent to change the dma_map_* and
dma_sync_*_for_device stuff there to wmb() to make it  portable
to other architectures.

	Arnd <><
