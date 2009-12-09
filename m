Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZLINYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZLINYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 08:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZLINYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 08:24:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52935 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbZLINYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 08:24:39 -0500
Date: Wed, 9 Dec 2009 13:24:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       David Miller <davem@davemloft.net>, Ollie Wild <aaw@google.com>,
       Rik van Riel <riel@redhat.com>, viro@ftp.linux.org.uk,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
Message-ID: <20091209132436.GQ14381@ZenIV.linux.org.uk>
References: <20091208060701.GM14381@ZenIV.linux.org.uk> <Pine.LNX.4.64.0912081142280.31223@sister.anvils> <Pine.LNX.4.64.0912081254500.3365@sister.anvils> <20091208.130802.25121122.davem@davemloft.net> <20091208220638.GN14381@ZenIV.linux.org.uk> <Pine.LNX.4.64.0912091041250.23659@sister.anvils> <1260361302.5489.372.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260361302.5489.372.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 01:21:42PM +0100, Peter Zijlstra wrote:

> /me ponders.. doesn't the binfmt engine cruft need the args in place in
> order to execute?

Needs to modify them in case #! and a few other.  But that's generally
a matter of "drop argv[0], push several arguments in its place"

> That is, IIRC the problem is that you need to have the argc/env in place
> for the binfmt engine thing, and need to have ran the binfmt engine
> thing before you know the personality.
> 
> As to your idea, if that were feasible we could do without the copy and
> simply steal the pages directly from the old mm.

*raised brows*
Old mm may bloody well be still shared, so I'd be vary of trying that -
there's a lot of nasty surprises we could get on that way.
