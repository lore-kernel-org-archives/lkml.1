Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbZE0WDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbZE0WDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZE0WDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:03:42 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:24683 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZE0WDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:03:41 -0400
X-IronPort-AV: E=Sophos;i="4.41,261,1241395200"; 
   d="scan'208";a="165018113"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
	<1243409850-21577-18-git-send-email-jeremy@goop.org>
	<alpine.LFD.2.01.0905270829530.3435@localhost.localdomain>
	<20090527211828.GA6166@elte.hu>
	<alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 27 May 2009 15:03:42 -0700
In-Reply-To: <alpine.LFD.2.01.0905271436140.3435@localhost.localdomain> (Linus
	Torvalds's message of "Wed, 27 May 2009 14:46:15 -0700 (PDT)")
Message-ID: <adavdnm5hkx.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 May 2009 22:03:43.0038 (UTC) FILETIME=[FFC895E0:01C9DF16]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Pu another way: if they actually add value in highlighting the commits 
 > that _should_ stand out, then hey, by all means, keep such ones. I would 
 > not at all object if it was an issue of 
 > 
 >  [ Impact: fix bugzilla entry 455123 ]

I wonder if it's really worth having such a visually distinctive style
for tagging things that fix bugzilla entries.  I've been just writing
out in English the bug information -- eg a recent changelog contains

    This patch fixes <https://bugs.openfabrics.org/show_bug.cgi?id=1571>,
    an NFS/RDMA server crash.

I could see adding a tag along the lines of tested-by, reported-by,
reviewed-by, etc.  Maybe something like

    Closes-bug: <URL>

so the above language would become

    Closes-bug: https://bugs.openfabrics.org/show_bug.cgi?id=1571

And then "git log|grep 'Closes-bug:'" or "git log|grep '<bug URL>'"
becomes interesting...

 >  [ Impact: fix user-triggerable oops ]

This I think gets close to the never-ending argument about tagging
"security" bugs.  It might not be obvious immediately that a given
change fixes a user-triggerable oops and grepping the log for commits
that claim to fix a certain type of problem is quite likely to miss some
such fixes.

In the case where I know that a commit *does* fix a user-triggerable
oops, I try to note it in the changelog by saying, "This fixes an oops
that can be triggered by a user passing in garbage input xyz..." but I'm
not sure if we want to put that in a standardized greppable form.

 - R.
