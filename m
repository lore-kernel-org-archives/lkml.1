Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZGAU5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZGAU5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbZGAU5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:57:12 -0400
Received: from deleuze.hcoop.net ([69.90.123.67]:34576 "EHLO deleuze.hcoop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbZGAU5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:57:12 -0400
From: Jeremy Maitin-Shepard <jeremy@jeremyms.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by encrypting page cache
References: <87hbxx0wcp.fsf@jeremyms.com> <87d48k2992.fsf@jeremyms.com>
	<4A4B27D0.8020906@crca.org.au> <200907011755.10386.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Wed, 01 Jul 2009 13:57:01 -0700
In-Reply-To: <200907011755.10386.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 01 Jul 2009 17:55:09 +0200")
Message-ID: <874otw15r6.fsf@jeremyms.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> [snip]

>> As far as the possibility of using uswsusp goes, I'd like to get
>> Rafael's input there - he knows it much better than I do (explicitly
>> adding him to the ccs).

> No, the current mainline hibernation code can't be modified easily
> to encrypt the page cache before suspending.

> Also, I don't see much value in doing that before suspend to RAM, because
> (1) passwords and encryption keys should be stored in mlocked memory

I do not have a complete understanding of linux memory management, but
couldn't such memory also be included in the encryption?  The page cache
is presumably the bulk of memory, but I realize there are likely several
other places in memory that may contain sensitive data.  However, it
would seem that encrypting these in place should, for the most part,
also be quite feasible.

> and (2)
> the encryption overhead (including measures to protect the encrypted page cache
> from being corrupted) would hurt the speed of suspend to RAM and resume, which
> is a very important thing.

I am not suggesting that it be done unconditionally.  I am simply
suggesting that it be made available as an option, just as hibernating
to encrypted swap is an option, and using dm-crypt in general is an
option.  Surely encrypting and decrypting would take additional time,
but it would also surely take far less time than hibernating and
resuming.  On machines with hardware encryption support (such as the
future Intel Westmere processor), encrypting several gigabytes of memory
may not take very much time at all.

> Moreover, I don't really see how we can feed the decryption key to the
> kernel during resume before the page cache can be accessed.

My understanding is that this is something that is already done in
tuxonice.  After the contents of the page cache are written to disk,
some of the page cache is overwritten with a copy of the rest of memory,
and the kernel continues to interact with the userspace UI program.  I
would assume that this state is effectively equivalent to the state the
system would be in after encrypting the page cache.  (Obviously the
memory needed by the userspace helper would have to be treated
specially.)

-- 
Jeremy Maitin-Shepard
