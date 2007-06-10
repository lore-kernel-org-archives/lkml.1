Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbXFJOCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbXFJOCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 10:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXFJOCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 10:02:13 -0400
Received: from thunk.org ([69.25.196.29]:42332 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbXFJOCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 10:02:11 -0400
Date: Sun, 10 Jun 2007 10:02:00 -0400
From: Theodore Tso <tytso@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Rules on how to use sysfs in userspace programs
Message-ID: <20070610140200.GD9726@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
References: <20070608203637.GA9259@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608203637.GA9259@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 01:36:37PM -0700, Greg KH wrote:
> The kernel exported sysfs exports internal kernel implementation-details
> and depends on internal kernel-structures and layout. It is agreed upon
> kernel developers, that the Linux kernel does not provide a stable
> internal API.  As sysfs is a direct export of kernel internal
> structures, the sysfs interface can't provide a stable interface too, it
> may always change along with internal kernel changes.

I want to step back and ask a very fundamental philosophical question
--- who are the intended users of sysfs?  If it exports an interface,
part of which is known not be stable, except for backwards
compatibility issues, why and to whom are we exporting them?

If the answer is "no one", then maybe modulo backwards compatibility
issues, we should only export via sysfs those things that are
guaranteed to be a stable interface.  Or maybe there should be a mount
option that filters out anything which isn't guaranteed to be stable,
so that user programs can easily determine if they are using anything
"bad" --- and then a year or two from now, we make that mount option
the default, and require a mount option if people want to see the
unstable bits of sysfs.

Way back in 2003, Rusty's OLS keynote talked at great length about
kernel design and interface similicity as a hallmark of good design:

    1. Compiler/linker won't let you get it wrong.
    2. Compiler will warn if you get it wrong.
    3. The simplest use is the correct one.
    4. The name tells you how to use it.
    5. Do it right or it will break at runtime.
    6. Follow common convention and you'll get it right.
    7. Read the documentation and you'll get it right.
    8. Read the implementation and you'll get it right.
    9. Read the correct mailing list thread and you'll get it right.
    10. Read the documentation and you'll get it wrong.
    11. Follow common convention and you'll get it wrong.
    12. Do it right and it will break at runtime.
    13. The name tells you how not to use it.
    14. The obvious use is wrong.
    15. Compiler will warn if you get it right.
    16. Compiler won't let you get it right.
    17. It's impossible to get right. 

The documentation is a good step, but wouldn't it be better if we can
prohibit (or warn) applications who are getting it wrong in the first
place?  Providing interfaces that aren't stable, and then requiring
people to read documentation so they know not to use them, seems to be
providing an attractive nuisance.

						- Ted
