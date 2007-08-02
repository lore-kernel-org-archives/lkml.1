Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbXHBDcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbXHBDcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 23:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbXHBDc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 23:32:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56405 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbXHBDc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 23:32:26 -0400
Date: Thu, 2 Aug 2007 09:14:10 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mundt <lethal@linux-sh.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Matthew Wilcox <matthew@wil.cx>, Kyle McMartin <kyle@parisc-linux.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix WARN_ON() on bitfield ops for all other archs
In-Reply-To: <20070801221838.GA9010@osiris.ibm.com>
Message-ID: <alpine.LFD.0.999.0708020900010.8258@enigma.security.iitk.ac.in>
References: <20070801221838.GA9010@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Aug 2007, Heiko Carstens wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Fixes WARN_ON() on bitfiels ops for all architectures that have
> been left out in 8d4fbcfbe0a4bfc73e7f0297c59ae514e1f1436f.

Well, considering ...

On Tue, 31 Jul 2007, Alexey Dobriyan wrote:
> But I question the rationale of that commit:
> [...]
> I think that second case is more clear and immediately understandable.

and

On Tue, 31 Jul 2007, Linus Torvalds wrote:
> For all I know, the proper solution is
> to just revert the whole mess, and *not* make WARN_ON() return a value
> at all, since that seems to be the fundamental mistake here.

... I think it makes sense to stop returning the value from WARN_ON()
in the first place. There's only 5 places in the tree that uses its
return value anyway, and one of them ( net/xfrm/xfrm_policy.c:681 )
is a good example of why it's less readable that way.


Satyam
