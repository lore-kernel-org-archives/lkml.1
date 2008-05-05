Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYEEGM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYEEGM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 02:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYEEGMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 02:12:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37180 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbYEEGMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 02:12:19 -0400
Date: Mon, 5 May 2008 02:12:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, kaos@sgi.com, Stephen Rothwell <sfr@au1.ibm.com>,
       rolandd@cisco.com, "Brian S. Julin" <bri@calyx.com>,
       Martin Diehl <info@mdiehl.de>, mokuno@sm.sony.co.jp,
       aacraid@adaptec.com, mfasheh@suse.com, wim@iguana.be, xfs@oss.sgi.com,
       reiserfs-devel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/1] Replace down_trylock() with down_try(), reverse
	return values.
Message-ID: <20080505061217.GA13398@infradead.org>
References: <200805051156.36437.rusty@rustcorp.com.au> <20080505055823.GA20970@infradead.org> <200805051609.13731.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805051609.13731.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 04:09:12PM +1000, Rusty Russell wrote:
> > Given that people are actively trying to kill struct semaphore I don't
> > think doing a big search and rename is a good idea right now.
> 
> If it goes away before the 2.6.27 merge window, great.  But I don't see that 
> happening, so let's clean up this horror.  I cc'd all the people effected in 
> the hope that it will prod some of them towards mutexes anyway.

.27 might not be doable but .28 seems probable if willy and co are
continuing to churn like they do currently.

> > (And I also really hate the name down_try, but when it goes away that's
> >  rather void and we can spare the discussion)
> 
> Ideas?  down() is pretty bad, down_try() matches it.

The trylock is a convention for real locking function, so having one
stand out would be nasty.  Then again a semaphore is not just a simple
lock but a higher level locking primitive, so a down_nowait might make
sense because we don't encode the lock anywhere else either
