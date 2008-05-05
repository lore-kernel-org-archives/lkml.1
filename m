Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYEEF6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYEEF6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYEEF62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:58:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47314 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbYEEF61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:58:27 -0400
Date: Mon, 5 May 2008 01:58:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, kaos@sgi.com,
       Stephen Rothwell <sfr@au1.ibm.com>, rolandd@cisco.com,
       "Brian S. Julin" <bri@calyx.com>, Martin Diehl <info@mdiehl.de>,
       mokuno@sm.sony.co.jp, aacraid@adaptec.com, mfasheh@suse.com,
       wim@iguana.be, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/1] Replace down_trylock() with down_try(), reverse
	return values.
Message-ID: <20080505055823.GA20970@infradead.org>
References: <200805051156.36437.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805051156.36437.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 01:56:35AM +0000, Rusty Russell wrote:
> 
> down_trylock() returns 1 on failure, 0 on success.  This differs from
> spin_trylock(), mutex_trylock() and common sense.  Or as ocfs2 put it
> "kernel 1, world 0".
> 
> Rename it to down_try() (which makes more sense anyway), and reverse
> it.  Fortunately there aren't a huge number of callers left.
> 
> I took the liberty of reversing the sense of usb_trylock_device()
> without renaming it: it's only used in one place anyway.

Given that people are actively trying to kill struct semaphore I don't
think doing a big search and rename is a good idea right now.

(And I also really hate the name down_try, but when it goes away that's
 rather void and we can spare the discussion)

