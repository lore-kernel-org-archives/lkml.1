Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbZF2Qa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbZF2Qa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZF2Qat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:30:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41996 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752581AbZF2Qas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:30:48 -0400
Date: Mon, 29 Jun 2009 17:31:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, tom.leiming@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
 in dma_sync_*_for_cpu
Message-ID: <20090629173121.768f2923@lxorguk.ukuu.org.uk>
In-Reply-To: <200906291822.18334.arnd@arndb.de>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
	<200906281534.37148.arnd@arndb.de>
	<20090629123142.GL5139@amd.com>
	<200906291822.18334.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Wouldn't it be better to put the flush_write_buffer in the specific
> operation (swiotlb_sync_*_for_*) rather than the multiplexer?
> 
> Maybe in that case, smp_wmb() would be more appropriate because
> it is defined on all architectures.

smp_wmb() is stronger and it would slow down x86 if we did that (we'd go
from no-op on a coherent platform to using mfence/lfence etc)

