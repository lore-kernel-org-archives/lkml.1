Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYDXJwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYDXJwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 05:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYDXJw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 05:52:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57429 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYDXJw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 05:52:28 -0400
Date: Thu, 24 Apr 2008 05:52:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: T David Chinner <dgc@sgi.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080424095215.GA13088@infradead.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <1208928421.9060.22.camel@pasglop> <20080423233652.GT103491721@sgi.com> <20080423174516.0982a325@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423174516.0982a325@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 05:45:16PM -0700, Arjan van de Ven wrote:
> THe good news is that direct reclaim is.. rare.
> And I also doubt XFS is unique here; imagine the whole stacking thing on x86-64 just the same ...

It's bad news actually.  Beause it means the stack overflow happens
totally random and hard to reproduce.   And no, XFS is not unique there,
any filesystem with a complex enough writeback path (aka extents +
delalloc + smart allocator) will have to use quite a lot here.  I'll be
my 2 cent that ext4 one finished up will run into this just as likely.

> I wonder if the direct reclaim path should avoid direct reclaim if the stack has only X bytes left.
> (where the value of X is... well we can figure that one out later)

Actually direct reclaim should be totally avoided for complex
filesystems.  It's horrible for the stack and for the filesystem
writeout policy and ondisk allocation strategies.

