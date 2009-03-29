Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZC2GDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZC2GDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 02:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZC2GDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 02:03:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33383 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZC2GDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 02:03:39 -0400
Date: Sun, 29 Mar 2009 07:01:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20090329060118.GI28946@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils> <Pine.LNX.4.64.0903282319270.15432@blonde.anvils> <20090329005343.GA12139@redhat.com> <20090329041022.GF28946@ZenIV.linux.org.uk> <20090329045206.GA15519@redhat.com> <20090329055513.GH28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329055513.GH28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 06:55:13AM +0100, Al Viro wrote:
> On Sun, Mar 29, 2009 at 06:52:06AM +0200, Oleg Nesterov wrote:
> 
> > Let's suppose that check_unsafe_exec() does not set LSM_UNSAFE_SHARE and
> > drops ->siglock. After that, another sub-thread does clone(CLONE_FS) without
> > CLONE_THREAD.
> 
> Lovely.  And yes, AFAICS that's a hole.
> 
> > Unless we killed other threads, I can't see how we can check ->fs is not
> > shared with another process, we can fool ->bprm_set_creds() anyway.
> 
> We can't do that, until we are past the point of no return.  Charming...
> In principle, we can mark these threads as "-EAGAIN on such clone()" and
> clean that on exec failure.

... or just do that to fs_struct.  After finding that there's no outside
users.  Commenst?
