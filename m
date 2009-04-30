Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZD3GPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZD3GPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZD3GO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:14:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbZD3GOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:14:55 -0400
Date: Thu, 30 Apr 2009 08:14:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 00/27] [rfc] vfs scalability patchset
Message-ID: <20090430061454.GE23746@wotan.suse.de>
References: <20090425012020.457460929@suse.de> <20090425041829.GX8633@ZenIV.linux.org.uk> <20090425080143.GA29033@infradead.org> <20090425080649.GA8633@ZenIV.linux.org.uk> <20090428090930.GA14638@infradead.org> <m1d4axggjm.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4axggjm.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 04:32:13AM -0700, Eric W. Biederman wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > On Sat, Apr 25, 2009 at 09:06:49AM +0100, Al Viro wrote:
> >> Maybe...  What Eric proposed is essentially a reuse of s_list for per-inode
> >> list of struct file.  Presumably with something like i_lock for protection.
> >> So that's not a conflict.
> >
> > But what do we actually want it for?  Right now it's only used for
> > ttys, which Nick has split out, and for remount r/o.  For the normal
> > remount r/o case it will go away once we have proper per-sb writer
> > counts.  And the fource remount r/o from sysrq is completely broken.
> 
> The plan is to post my updated patches tomorrow after I have slept.
> 
> What I am looking at is that the tty layer is not a special case.  Any
> subsystem that wants any revoke kind of functionality starts wanting
> the list of files that are open.  My current list where we have
> something like this is: sysfs, proc, sysctl, tun, tty, sound.

How's this coming along? It would be good to get this change out
and reviewed ASAP, and ahead of the rest of your patchset IMO.
Hopefully we can get it into Al's tree for 2.6.31 if it all falls
out nicely.

BTW. I would just keep the single files_lock spinlock in the
first patch that would move to per-inode lists, and then a 2nd
patch could swap out the locking without making any other changes
(or else you could just leave the locking global and we can
evaluate it in the context of the rest of the vfs scalability
work).

