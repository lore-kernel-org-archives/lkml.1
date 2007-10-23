Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbXJWDf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbXJWDf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 23:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXJWDfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 23:35:50 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3126 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752173AbXJWDft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 23:35:49 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jeff@garzik.org (Jeff Garzik)
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, matthew@wil.cx,
       arnd@arndb.de, ralf@linux-mips.org, adobriyan@gmail.com,
       viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Organization: Core
In-Reply-To: <471D0C54.7060207@garzik.org>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IkAWI-0006vX-00@gondolin.me.apana.org.au>
Date: Tue, 23 Oct 2007 11:33:30 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> wrote:
> 
> Let me add to the chorus of voices:  I continually see two cases where 
> real bugs crop up:
> 
> 1) hacker uses spin_lock_irq() in incorrect context (where it is not 
> safe to do a blind enable/disable)
> 
> 2) hacker uses spin_lock_irq() correctly, but the surrounding code 
> changes, thus invalidating prior assumptions.
> 
> I would even go so far as to support the drastic measure of deleting 
> spin_lock_irq().
> 
> spin_lock_irqsave() generates fewer bugs, is more future-proof, and by 
> virtue of 'flags' permits architectures a bit more flexibility.

Could we add a debug option that warned if spin_lock_irq is
executed with IRQs turned off already?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
