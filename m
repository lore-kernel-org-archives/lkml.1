Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZLINjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZLINjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 08:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbZLINje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 08:39:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44912 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbZLINjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 08:39:33 -0500
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
From: Peter Zijlstra <peterz@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       David Miller <davem@davemloft.net>, Ollie Wild <aaw@google.com>,
       Rik van Riel <riel@redhat.com>, viro@ftp.linux.org.uk,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091209132436.GQ14381@ZenIV.linux.org.uk>
References: <20091208060701.GM14381@ZenIV.linux.org.uk>
	 <Pine.LNX.4.64.0912081142280.31223@sister.anvils>
	 <Pine.LNX.4.64.0912081254500.3365@sister.anvils>
	 <20091208.130802.25121122.davem@davemloft.net>
	 <20091208220638.GN14381@ZenIV.linux.org.uk>
	 <Pine.LNX.4.64.0912091041250.23659@sister.anvils>
	 <1260361302.5489.372.camel@laptop>
	 <20091209132436.GQ14381@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 14:39:18 +0100
Message-ID: <1260365958.5489.546.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 13:24 +0000, Al Viro wrote:

> > That is, IIRC the problem is that you need to have the argc/env in place
> > for the binfmt engine thing, and need to have ran the binfmt engine
> > thing before you know the personality.
> > 
> > As to your idea, if that were feasible we could do without the copy and
> > simply steal the pages directly from the old mm.
> 
> *raised brows*
> Old mm may bloody well be still shared, so I'd be vary of trying that -
> there's a lot of nasty surprises we could get on that way.

Good point, but I think we might be able to do the copy from old to new
in flush_old_exec() if we can get the binfmt things to pass the right
address along (or set it in the brpm struct). It looks like it has clue
about personality at that point.

