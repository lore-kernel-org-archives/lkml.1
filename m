Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYH0QmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYH0QmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYH0QmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:42:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34600 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbYH0QmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:42:15 -0400
Date: Wed, 27 Aug 2008 22:10:55 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
Message-ID: <20080827164055.GA22236@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080826220102.89635154233@magilla.localdomain> <20080826223402.GB27724@x200.localdomain> <y0m7ia3xqev.fsf@ton.toronto.redhat.com> <20080827135453.GA31240@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827135453.GA31240@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 09:54:53AM -0400, Christoph Hellwig wrote:
> On Tue, Aug 26, 2008 at 08:17:12PM -0400, Frank Ch. Eigler wrote:
> > Among others, utrace is an enablement layer for systemtap user-space
> > probing, through another subsequent part that implements a
> > kprobes-like API for user-space tasks.  All this code now exists in at
> > least prototype form, so if you need to see the bigger picture, look
> > that way.  Other users are anticipated, but first we need to get past
> > the chicken-and-egg.
> 
> As usual nothing of that stuff has any real in-kernel users so the same
> argument applies here.  If it did have real uses it could be merged at
> the same time.  But the current uprobes mess is not a reason to merge
> utrace.

Uprobes is just one user of utrace. It is intended for use for simple
tracing where we need a kernel+userspace look at the problem at hand.
The intention is for use in simple cases (when condition x is met, what
is the value of variable y, etc).

For more advanced tracing though, there are other ideas being proposed
(see ntrace discussions on utrace-devel, but I guess now lkml is the
right place for that discussion too).

However, there are components of uprobes such as breakpoint
insertion/removal and single-stepping infrastructure that are
potentially useful to other userspace debuggers. We are working on
factoring those out to live independent of uprobes. You should be seeing
those patches soon.

Ananth
