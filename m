Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYEPPuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYEPPuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYEPPt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:49:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48993 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYEPPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:49:56 -0400
Date: Fri, 16 May 2008 11:49:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] char dev BKL pushdown
Message-ID: <20080516154922.GA25412@infradead.org>
References: <alpine.LFD.1.10.0805141452330.3019@woody.linux-foundation.org> <16082.1210952646@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16082.1210952646@vena.lwn.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 09:44:06AM -0600, Jonathan Corbet wrote:
> trivial as to not require locking (quite few of them are "return 0;"), or

If they literaly are 'return 0' you can just remove them, as a
non-existing open op will just be fine.

> (2) clearly doing its own locking, I wrapped the code in the BKL.

Even if clearly does it's own locking please add the BKL for now and let
the maintainers sort it out later, better be safe then sorry.

Except for that thanks a lot, this is the kind of work that's more
productive than all these discussions here :)

For some reason about 80 instances seem awfully few, but we've move a
lot of device into subsystems from beeing plain chardevs so this
might actually be correct.
