Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbXEOQQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbXEOQQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 12:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbXEOQQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 12:16:00 -0400
Received: from verein.lst.de ([213.95.11.210]:38039 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095AbXEOQP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 12:15:59 -0400
Date: Tue, 15 May 2007 18:15:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, nate.diller@gmail.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Timothy Shimmin <tes@sgi.com>, Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Re: [PATCH] deprecate memclear_highpage_flush deprecation warnings
Message-ID: <20070515161500.GA23538@lst.de>
References: <20070515122440.GA8765@lst.de> <20070515090032.e6f94d58.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515090032.e6f94d58.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 09:00:32AM -0700, Andrew Morton wrote:
> On Tue, 15 May 2007 14:24:40 +0200 Christoph Hellwig <hch@lst.de> wrote:
> 
> > Recent builds get tons of warnings about memclear_highpage_flush
> > beeing deprecated.  Turns out it's replaced by zero_user_page
> > which takes an additional argument.
> > 
> > Now folks, deprecated is for actual functionality going away, there
> > is no need to mark the old name deprecated for such a trivial
> > paramter change and rename.
> 
> Yes, it's rather trivial, but memclear_highpage_flush() *is* going away.

Well, it's renamed to zero_user_page and gained an argument.  We do
changed like that all the time and don't put silly deprecation warnings
in.

> > Here's a patch to kill memclear_highpage_flush and convert the reaming
> > user to make the build a littler more silent, it's more than noisy
> > enough due to all the useless addition of __deprecated or __must_check
> > to widely used functionality and gcc stupid false positives.
> 
> Patches have been prepared which convert all in-kernel users.  I thought
> I'd dtrt and feed them through maintainers, but that takes time.  The
> laggards are on cc ;)

No, there is absolutely no point in feeding this through maintainers.
For something as trivial as a rename and adding an argument doing one
patch is enough and the right thing.  We can't feed any trivial global
search & replace through maintainer and generate warnings in the
meantime.
