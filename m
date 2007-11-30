Return-Path: <linux-kernel-owner+w=401wt.eu-S933927AbXK3IX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927AbXK3IX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 03:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXK3IXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 03:23:49 -0500
Received: from lazybastard.de ([212.112.238.170]:54675 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758979AbXK3IXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 03:23:49 -0500
Date: Fri, 30 Nov 2007 09:18:35 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071130081835.GA28414@lazybastard.org>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 November 2007 00:15:53 +0000, Daniel Drake wrote:
> 
> What's the definition of an unaligned access?
> =============================================
> 
> Unaligned memory accesses occur when you try to read N bytes of data starting
> from an address that is not evenly divisible by N (i.e. addr % N != 0).
> For example, reading 4 bytes of data from address 0x10000004 is fine, but
> reading 4 bytes of data from address 0x10000005 would be an unaligned memory
> access.

The wording could also apply to a DMA of 8k from a 4k-aligned address.
But I don't have a good idea how to improve it.

> It's safe to assume that memcpy will always copy bytewise and hence will
> never cause an unaligned access.

s/always copy/always behave as if copying/

memcpy usually copies at least wordwise, possibly even in bigger chunks.
But that is just the inner loop.  Unaligned bytes at the beginning/end
receive special treatment.

Jörn

-- 
The rabbit runs faster than the fox, because the rabbit is rinning for
his life while the fox is only running for his dinner.
-- Aesop
