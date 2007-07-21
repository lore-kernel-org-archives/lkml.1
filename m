Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbXGUWgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbXGUWgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbXGUWgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:36:44 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53703 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbXGUWgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:36:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CTL_UNNUMBERED (Re: [PATCH] 9p: Don't use binary sysctl numbers.)
References: <m1y7h9wpuo.fsf@ebiederm.dsl.xmission.com>
	<20070721205709.GB5772@martell.zuzino.mipt.ru>
Date: Sat, 21 Jul 2007 16:36:03 -0600
In-Reply-To: <20070721205709.GB5772@martell.zuzino.mipt.ru> (Alexey Dobriyan's
	message of "Sun, 22 Jul 2007 00:57:09 +0400")
Message-ID: <m1odi5wfjg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

>
> That's separate patch but CTL_UNNUMBERED must die, because it's totally
> unneeded. If you don't want sysctl(2) interface just SKIP ->ctl_name
> initialization and save one line for something useful.

As for the 9p code it doesn't seem to need or want a real binary
interface.  The 9p debug code picking of a semi-random number and not
patching it into sysctl.h like it should for a binary interface is
an implementation bug, and a maintenance problem.

Further it is a classic example of the silliness that goes on
when people actually try and add to the binary interface.

So not assigning a binary number very much looks like the right thing
to do for 9p.

I expect if the change had not happened in a mega patch to 9p that
seems to have changed everything the addition of a new user space
interface would more likely have been caught in a code review.



Now to the issue of using CTL_UNNUMBERED versus knowing that the magic
value is zero and we can just leave it uninitialized.  I don't much
care but given how often people who are not actively watching this
mess up I tend to prefer the explicit value.  It is a practical
question of how do we get the word out that we should not expand the
binary interface anymore. 

The only really practical way I can see us doing better then we are
today is to have a separate tree that maps binary numbers into ascii
strings and so we remove the ctl_name field entirely from ctl_table. 

That way people attempting to assign binary numbers using old
conventions will have code that doesn't even compile, and the
developers themselves are more likely to spot the problem.

Eric
