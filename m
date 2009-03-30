Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZC3Xp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZC3Xp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 19:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZC3Xpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:45:44 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37837 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbZC3Xpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:45:43 -0400
Date: Mon, 30 Mar 2009 18:45:39 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>, Hugh Dickins <hugh@veritas.com>,
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
Message-ID: <20090330234539.GA3462@us.ibm.com>
References: <20090329060118.GI28946@ZenIV.linux.org.uk> <20090329213635.GA21820@redhat.com> <20090329222022.GJ28946@ZenIV.linux.org.uk> <20090329235639.GA32199@redhat.com> <20090330000338.GB32199@redhat.com> <20090330010843.GM28946@ZenIV.linux.org.uk> <20090330011303.GN28946@ZenIV.linux.org.uk> <20090330013612.GA4080@redhat.com> <20090330014040.GA4807@redhat.com> <20090330123101.GQ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330123101.GQ28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Al Viro (viro@ZenIV.linux.org.uk):
> On Mon, Mar 30, 2009 at 03:40:40AM +0200, Oleg Nesterov wrote:
> 
> > > We can't proceed. If that another exec() fails, it will clear "under exec" at
> > > the end of do_execve(), before we kill other threads.
> > 
> > Or we need a counter to mark/unmark.
> 
> Nah, easier to have check_unsafe_exec() return -EAGAIN in cases we care
> about.
> 
> Anyway, completely untested patchset is in
> git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ execve-mess
> (the last 9 changesets of it).
> 
> WARNING: that's *NOT* for merge at the moment; this is not a pull request.
> 
> Review (and testing) would be welcome.

(note exactly *meaningful* review, but)

exit_fs() and daemonize_fs_struct() do:

                if (--fs->users)
                        fs = NULL;
                write_unlock(&fs->lock);

Moving the write_unlock up actually let's the kernel boot and
start running ltp.

-serge
