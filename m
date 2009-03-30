Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbZC3Blr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbZC3Blr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbZC3Blg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:41:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51440 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888AbZC3Blf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:41:35 -0400
Date: Mon, 30 Mar 2009 03:36:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
	sometimes doesn't)
Message-ID: <20090330013612.GA4080@redhat.com>
References: <20090329041022.GF28946@ZenIV.linux.org.uk> <20090329045206.GA15519@redhat.com> <20090329055513.GH28946@ZenIV.linux.org.uk> <20090329060118.GI28946@ZenIV.linux.org.uk> <20090329213635.GA21820@redhat.com> <20090329222022.GJ28946@ZenIV.linux.org.uk> <20090329235639.GA32199@redhat.com> <20090330000338.GB32199@redhat.com> <20090330010843.GM28946@ZenIV.linux.org.uk> <20090330011303.GN28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330011303.GN28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Al Viro wrote:
>
> On Mon, Mar 30, 2009 at 02:08:43AM +0100, Al Viro wrote:
>
> > So...
> > 	* check_unsafe_exec() locks current->fs shared, goes through all
> > threads comparing their ->fs with our, if the number doesn't match - bail
> > out.  Otherwise we mark it "under exec".

Unless I missed something again, check_unsafe_exec() should check "under exec"
after it takes fs->lock. If set - we are racing with sub-thread, return -EAGAIN.

We can't proceed. If that another exec() fails, it will clear "under exec" at
the end of do_execve(), before we kill other threads.

Oleg.

