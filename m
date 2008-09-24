Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYIXNH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYIXNH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 09:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYIXNHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 09:07:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37579 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991AbYIXNHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 09:07:15 -0400
Date: Wed, 24 Sep 2008 14:06:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, andi@firstfloor.org,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 3/3] x86: restore old GART alloc_coherent behavior
Message-ID: <20080924140644.569cdd1d@lxorguk.ukuu.org.uk>
In-Reply-To: <1222256917-14321-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1222256917-14321-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1222256917-14321-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1222256917-14321-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1222256917-14321-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008 20:48:37 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Currently, GART alloc_coherent tries to allocate pages with GFP_DMA32
> for a device having dma_masks > 24bit < 32bits. If GART gets an
> address that a device can't access to, GART try to map the address to
> a virtual I/O address that the device can access to.
> 
> But Andi pointed out, "The GART is somewhere in the 4GB range so you
> cannot use it to map anything < 4GB. Also GART is pretty small."
> 
> http://lkml.org/lkml/2008/9/12/43
> 
> That is, it's possible that GART doesn't have virtual I/O address
> space that a device can access to. The above behavior doesn't work for
> a device having dma_masks > 24bit < 32bits.
> 
> This patch restores old GART alloc_coherent behavior (before the
> alloc_coherent rewrite).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Alan Cox <alan@redhat.com>

This is indeed a specific problem found with things like older AACRAID
where control blocks must be below 31bits and the GART is above 0x80000000

Alan
