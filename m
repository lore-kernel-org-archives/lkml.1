Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZFCGhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZFCGhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZFCGhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:37:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbZFCGhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:37:21 -0400
Date: Wed, 3 Jun 2009 08:37:21 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/23] vfs: Introduce infrastructure for revoking a file
Message-ID: <20090603063721.GD27563@wotan.suse.de>
References: <m1oct739xu.fsf@fess.ebiederm.org> <1243893048-17031-4-git-send-email-ebiederm@xmission.com> <20090602071411.GE31556@wotan.suse.de> <alpine.LFD.2.01.0906021005190.3351@localhost.localdomain> <m1y6sas6ht.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6sas6ht.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 01:52:46PM -0700, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Tue, 2 Jun 2009, Nick Piggin wrote:
> >>
> >> Why is it called hotplug? Does it have anything to do with hardware?
> >> Because every concurrently changed software data structure in the
> >> kernel can be "hot"-modified, right?
> >> 
> >> Wouldn't file_revoke_lock be more appropriate?
> >
> > I agree, "hotplug" just sounds crazy. It's "open" and "revoke", not 
> > "plug" and "unplug".
> 
> I guess this shows my bias in triggering this code path from pci
> hotunplug.  Instead of with some system call.
> 
> I'm not married to the name.  I wanted file_lock but that is already
> used, and I did call the method revoke.

Definitely it is not going to be called hotplug in the generic
vfs layer :)

 
> The only place where hotplug gives a useful hint is that it makes it
> clear we really are disconnecting the file descriptor from what lies
> below it.

Isn't that hotUNplug?

But anyway hot plug/unplug is a purely hardware concept. Revoke
for "unplug", please, including naming of patches, changelogs,
and locks etc.


>  We can't do some weird thing like keep the underlying object.
> Because the underlying object is gone.

