Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbXFLAQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbXFLAQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXFLAQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:16:35 -0400
Received: from mail.suse.de ([195.135.220.2]:55038 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbXFLAQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:16:34 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 Jun 2007 10:16:22 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18029.58838.518919.415999@notabene.brown>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 001 of 2] Fix read/truncate race.
In-Reply-To: message from Andrew Morton on Thursday June 7
References: <20070607114043.26967.patches@notabene>
	<1070607014653.27304@suse.de>
	<20070607181820.6b22bb29.akpm@linux-foundation.org>
	<18024.50064.799102.305585@notabene.brown>
	<20070607231042.97c7b68b.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday June 7, akpm@linux-foundation.org wrote:
> On Fri, 8 Jun 2007 12:48:48 +1000 Neil Brown <neilb@suse.de> wrote:
> 
> > The following patch will remove the extra seqlock except when we
> > actually need it and remove the extra arithmetic - but I haven't
> > tested it or reviewed it properly.  I can do that if you think it is
> > the right direction.
> 
> Yes, the optimisation is valid and looks useful.
> 
> >  ./mm/filemap.c |   34 ++++++++++++++++++++++++++++------
> 
> It didn't apply - your tree seems different from mine.

Odd.  I had no other changes to that file in my tree.  I'll wait until
the next -mm(?).
It's just as well really, the patch was buggy - didn't even compile
and (as I said) totally untested.  I'll get you a tested patch after I
can rebase.

> 
> > +		 *
> > +		 * NOTE: This access of inode->i_size is not protected
> > +		 *  and if there is a concurrent update on a 32bit machine,
> > +		 *  it could return the wrong value.  This could only be a problem
> > +		 *  if i_size has actually changed to a smaller value before the
> > +		 *  page became uptodate, and at this point it still has a smaller
> > +		 *  value, but due to a race while reading, it appears unchanged.
> > +		 *  The chances of this happening are so small and the consequence
> > +		 *  sufficiently minor, that the cost of the seqlock seems
> > +		 *  not to be justified.
> 
> please consider incorporating scripts/checkpatch.pl into your patch
> preparation toolchain.

Done... Any reason that it isn't executable (chmod +x)?

NeilBrown
