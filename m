Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbZCSTdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbZCSTdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbZCSTc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:32:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764AbZCSTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:32:55 -0400
Date: Thu, 19 Mar 2009 15:32:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sage Weil <sage@newdream.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, adilger@sun.com
Subject: Re: [PATCH] vfs: make real_lookup do dentry revalidation with
	i_mutex held
Message-ID: <20090319193249.GA23267@infradead.org>
References: <Pine.LNX.4.64.0903091118210.2773@cobra.newdream.net> <20090317081730.GA20213@infradead.org> <Pine.LNX.4.64.0903170957560.18956@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903170957560.18956@cobra.newdream.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 10:03:35AM -0700, Sage Weil wrote:
> On Tue, 17 Mar 2009, Christoph Hellwig wrote:
> > Keeping i_mutes over do_revalidate seem fine from a first glance, but
> > can you please do it without rearranging the whole code?
> 
> Yeah, but not without an extra goto.  Holding i_mutex over revalidate is 
> only half of it... we also want to go ahead with the ->lookup if the 
> revalidate fails (instead of returning -ENOENT).  I make the patch easier 
> to read (with a goto), but I assumed we'd want the resulting code to be 
> more clear?

Well, if you want to re-organize real_lookup make that a separate patch.
Might actually be worthwile to do so and clean up the other issues
in there (too long line in the prototype, spaces after the pointer *,
too.  And then have a small patch ontop to implement the mutex and
going ahead with the lookup.

