Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYEEGKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYEEGKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 02:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYEEGKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 02:10:32 -0400
Received: from ozlabs.org ([203.10.76.45]:46889 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYEEGKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 02:10:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Replace down_trylock() with down_try(), reverse return values.
Date: Mon, 5 May 2008 16:09:12 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, kaos@sgi.com,
       Stephen Rothwell <sfr@au1.ibm.com>, rolandd@cisco.com,
       "Brian S. Julin" <bri@calyx.com>, Martin Diehl <info@mdiehl.de>,
       mokuno@sm.sony.co.jp, aacraid@adaptec.com, mfasheh@suse.com,
       wim@iguana.be, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
References: <200805051156.36437.rusty@rustcorp.com.au> <20080505055823.GA20970@infradead.org>
In-Reply-To: <20080505055823.GA20970@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051609.13731.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008 15:58:23 Christoph Hellwig wrote:
> On Mon, May 05, 2008 at 01:56:35AM +0000, Rusty Russell wrote:
> > down_trylock() returns 1 on failure, 0 on success.  This differs from
> > spin_trylock(), mutex_trylock() and common sense.  Or as ocfs2 put it
> > "kernel 1, world 0".
> >
> > Rename it to down_try() (which makes more sense anyway), and reverse
> > it.  Fortunately there aren't a huge number of callers left.
>
> Given that people are actively trying to kill struct semaphore I don't
> think doing a big search and rename is a good idea right now.

If it goes away before the 2.6.27 merge window, great.  But I don't see that 
happening, so let's clean up this horror.  I cc'd all the people effected in 
the hope that it will prod some of them towards mutexes anyway.

> (And I also really hate the name down_try, but when it goes away that's
>  rather void and we can spare the discussion)

Ideas?  down() is pretty bad, down_try() matches it.

Thanks,
Rusty.

