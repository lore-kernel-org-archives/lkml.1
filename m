Return-Path: <linux-kernel-owner+w=401wt.eu-S934124AbXDFSGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934124AbXDFSGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934123AbXDFSGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:06:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39467 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934124AbXDFSGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:06:06 -0400
Date: Fri, 6 Apr 2007 19:05:52 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Snook <csnook@redhat.com>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406180552.GH32549@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Snook <csnook@redhat.com>, Robin Holt <holt@sgi.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Jack Steiner <steiner@americas.sgi.com>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org> <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 06:29:16PM -0700, Linus Torvalds wrote:
> > The support angel on my shoulder says we should just put all the kernel
> > threads under a kthread subtree to shorten init's child list and minimize
> > impact.
> 
> A number are already there, of course, since they use the kthread 
> infrastructure to get there. 

As all kernel thread (1) should be converted to kthread anyway for
proper containers support and general "let's get rid of a crappy API'
cleanups I think that's enough.  It would be nice to have SGI helping
to convert more drivers over to the proper API as conversions have stalled
a little bit.


(1) There's a few very core kernel threads that need to stick to the
    low-level API, but they're too few to make any differences.

