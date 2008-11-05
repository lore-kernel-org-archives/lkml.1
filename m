Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYKEXcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYKEXcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYKEXcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:32:08 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56251 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbYKEXcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:32:07 -0500
Date: Wed, 5 Nov 2008 23:31:35 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Eugene V. Lyubimkin" <jackyf.devel@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       Chris Friesen <cfriesen@nortel.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: mmap: is default non-populating behavior stable?
In-Reply-To: <4911DCEF.80904@gmail.com>
Message-ID: <Pine.LNX.4.64.0811052307460.5496@blonde.site>
References: <490F73CD.4010705@gmail.com> <1225752083.7803.1644.camel@twins>
 <490F8005.9020708@redhat.com> <491070B5.2060209@nortel.com>
 <1225814820.7803.1672.camel@twins> <20081104162820.644b1487@lxorguk.ukuu.org.uk>
 <49107D98.9080201@gmail.com> <Pine.LNX.4.64.0811051613400.21353@blonde.site>
 <4911DCEF.80904@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008, Eugene V. Lyubimkin wrote:
> Hugh Dickins wrote:
> 
> >>From time to time we toy with prefaulting adjacent pages when a fault
> > occurs (though IIRC tests have proved disappointing in the past): we'd
> > like to keep that option open, but it would go against your guidelines
> > above to some extent.
> It depends how is "adjacent" would count :) If several pages, probably not.
> If millions or similar, that would be a problem.

That's fine, you'll be safe: you can be sure that it would never be
in the kernel's interest to prefault more than "several" extra pages.

Well, bearing in mind that famous "640K enough for all" remark, let's
not say "never"; but it won't prefault millions until memory is so abundant
and I/O so fast that you'd be happy with it prefaulting millions yourself.

> It's very convenient to use such
> "open+truncate+mmap+write/read" behavior to make self-growing-on-demand cache
> in memory with disk as back-end without remaps.

Yes.  Though one thing to beware of is running out of disk space:
whereas a write system call should be good at reporting -ENOSPC,
the filesystem may not be able to handle running out of disk space
when writing back dirty mmaped pages - it may quietly lose the data.

Hugh
