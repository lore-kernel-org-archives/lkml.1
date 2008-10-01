Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYJAWiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYJAWiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 18:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYJAWiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 18:38:00 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:47753 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751767AbYJAWh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 18:37:59 -0400
Date: Wed, 1 Oct 2008 18:37:55 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/4] ext3: Fix ext3_dx_readdir hash collision handling
Message-ID: <20081001223755.GL10080@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
	linux-ext4@vger.kernel.org
References: <1221319971-29879-1-git-send-email-tytso@mit.edu> <20080917121943.904b66b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917121943.904b66b6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 12:19:43PM -0700, Andrew Morton wrote:
> On Sat, 13 Sep 2008 11:32:48 -0400
> "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> 
> > This fixes a bug where readdir() would return a directory entry twice
> > if there was a hash collision in an hash tree indexed directory.
> 
> That sounds like a serious problem, but given the amount of time it
> took to turn up, I guess it's pretty rare.
> 
> What are your thoughts regarding a 2.6.27 merge for this?  2.6.26.x? 
> 2.6.25.x?  ...
> 

It's not a regression, so per Linus's request that at this point we're
too late for anything other than regression fixes, I had assumed that
it should be pushed for 2.6.28, and then go into the various stable
trees.  It's true that it took quite a while for people to notice,
probably because many programs won't notice if readdir() returns a
directory entry twice.

BTW, this hasn't hit -mm yet, and I've got a number of ext3 patches
that don't appear to have hit -mm, including one that was authored by
Linus.  Should I create a git tree or a quilt series if that would
make things easier for you?

	      	   	   	      	- Ted


