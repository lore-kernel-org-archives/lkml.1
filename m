Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbXFAByH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbXFAByH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbXFABxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:53:51 -0400
Received: from ns1.suse.de ([195.135.220.2]:43948 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbXFABxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:53:50 -0400
Date: Fri, 1 Jun 2007 03:53:49 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-ID: <20070601015349.GC28585@wotan.suse.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070531231354.GR20632@ca-server1.us.oracle.com> <20070601010129.GA15878@wotan.suse.de> <20070601012440.GS20632@ca-server1.us.oracle.com> <20070601013402.GB28585@wotan.suse.de> <20070601014517.GT20632@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601014517.GT20632@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 06:45:17PM -0700, Mark Fasheh wrote:
> On Fri, Jun 01, 2007 at 03:34:02AM +0200, Nick Piggin wrote:
> > > Here's a nasty idea... Would it be valid for ->page_mkwrite to unlock the
> > > page, so long as it's returned in a locked state? Though, do we even need
> > > the page lock that early? It seemed to me that you were adding it for
> > > consistency reasons (I could be wrong though).
> > 
> > You could do that, but you'd have to probably check that it is
> > within i_size after you relock it, I think... yeah, that might
> > be the best thing for ocfs to do for now.
> 
> Well, ocfs2 already does i_size checks in page_mkwrite, so we're covered
> with respect to truncate races.
> 
> I'm still not clear though - what was the reason for adding the page locking
> there in the 1st place?

Yeah, its to cover page invalidation races. There is a description in
an earlier patch's changelog.

