Return-Path: <linux-kernel-owner+w=401wt.eu-S935368AbXGWU25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935368AbXGWU25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932684AbXGWU2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:28:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:51099 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765761AbXGWU2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:28:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=nGbYWFVknP2uR+kBkzzwviNvmaS+84HRzAbbZSRUX/UPdzJd2yRTjmkNmoyxZQa/4SUuuUc03EpesAUESfUcCow31TqPYVn1kbNVkHy867Gi7T4QPdrvI/tMj0zcfZlbF2BIo6qTHyFbeHUZSAoEF9NhaJMgKAJKcckUq7DScrQ=
Date: Tue, 24 Jul 2007 00:28:36 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CTL_UNNUMBERED (Re: [PATCH] 9p: Don't use binary sysctl numbers.)
Message-ID: <20070723202836.GC5755@martell.zuzino.mipt.ru>
References: <m1y7h9wpuo.fsf@ebiederm.dsl.xmission.com> <20070721205709.GB5772@martell.zuzino.mipt.ru> <m1odi5wfjg.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1odi5wfjg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 04:36:03PM -0600, Eric W. Biederman wrote:
> Alexey Dobriyan <adobriyan@gmail.com> writes:
> > That's separate patch but CTL_UNNUMBERED must die, because it's totally
> > unneeded. If you don't want sysctl(2) interface just SKIP ->ctl_name
> > initialization and save one line for something useful.

[9p and .ctl_name]

> Now to the issue of using CTL_UNNUMBERED versus knowing that the magic
> value is zero and we can just leave it uninitialized.  I don't much
> care but given how often people who are not actively watching this
> mess up I tend to prefer the explicit value.

mmm, from my own experience the quickest way to add sysctl to kernel is
to _copy_ from other place and tweak variable name and string itself.
I'm sure that's what evebody is doing.

And once you're copy-pasting, existence of CTL_UNNUMBERED or absence of
it doesn't matter. Propagating of CTL_UNNUMBERED or empty .ctl_name
depends entirely on the place from where you're copy-pasting.

And since it doesn't matter, we'd better save one line :)

> It is a practical
> question of how do we get the word out that we should not expand the
> binary interface anymore.

Article on LWN, scary comment near struct ctl_table::ctl_name, tree-wide
removal .ctl_name initializers, periodic grepping of -mm and -rc diffs.
I promise to grep next -mm patch and submit CTL_UNNUMBERED removal :)

> The only really practical way I can see us doing better then we are
> today is to have a separate tree that maps binary numbers into ascii
> strings and so we remove the ctl_name field entirely from ctl_table.

Not sure how to do this cleanly and without flag-day. And it's
additional code.

> That way people attempting to assign binary numbers using old
> conventions will have code that doesn't even compile, and the
> developers themselves are more likely to spot the problem.

