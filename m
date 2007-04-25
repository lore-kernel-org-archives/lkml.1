Return-Path: <linux-kernel-owner+w=401wt.eu-S2992790AbXDYQEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992790AbXDYQEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992793AbXDYQEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:04:12 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:48455 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S2992790AbXDYQEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:04:10 -0400
Message-ID: <377517042.01728@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 26 Apr 2007 00:04:00 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Pratt <slpratt@austin.ibm.com>, Ram Pai <linuxram@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] on-demand readahead
Message-ID: <20070425160400.GA27954@mail.ustc.edu.cn>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org
References: <377506695.54393@ustc.edu.cn> <p73odlc34ga.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73odlc34ga.fsf@bingen.suse.de>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 04:37:41PM +0200, Andi Kleen wrote:
> Fengguang Wu <fengguang.wu@gmail.com> writes:
> 
> > OVERHEADS
> > 
> > The new code reduced the overheads of
> > 
> > 	- excessively calling the readahead routine on small sized reads
> > 	  (the current readahead code insists on seeing all requests)
> > 
> > 	- doing a lot of pointless page-cache lookups for small cached files
> > 	  (the current readahead only turns itself off after 256 cache hits,
> > 	  unfortunately most files are < 1MB, so never see that chance)
> 
> Would it make sense to keep track in the AS if the file is completely in cache?
> Then you could probably avoid a lot of these lookups for small in cache files

Yeah, the on-demand readahead can avoid _all_ lookups for small in-cache files.
But what do you mean by AS?

> > --- linux-2.6.21-rc7-mm1.orig/mm/readahead.c
> > +++ linux-2.6.21-rc7-mm1/mm/readahead.c
> > @@ -733,6 +733,11 @@ unsigned long max_sane_readahead(unsigne
> 
> Quite simple patch, why is it that much simpler than your earlier patchkits?
> Or is that on top of them?

The earlier ones focus on features, while this one aims to be simple.
Even simpler than the current readahead, while keeping the same feature set.

The on-demand readahead is now on top of them, but can/will be made
independent.

> You seem to have a lot of magic numbers. They probably all need symbols and 
> explanations.

The magic numbers are for easier testings, and will be removed in
future.  For now, they enables convenient comparing of the two
algorithms in one kernel.

If this new algorithm has been further tested and approved, I'll
re-submit the patch in a cleaner, standalone form. The adaptive
readahead patches can be dropped then. They may better be reworked as
a kernel module.

> Your white space also needs some work.

White space in patch description?
OK, thanks.

Wu

