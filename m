Return-Path: <linux-kernel-owner+w=401wt.eu-S1759867AbZFIKxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbZFIKxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZFIKww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:52:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbZFIKwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:52:51 -0400
Date: Tue, 9 Jun 2009 12:52:51 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com,
       tj@kernel.org, adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk,
       gregkh@suse.de, akpm@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 0/23] File descriptor hot-unplug support v2
Message-ID: <20090609105251.GK14820@wotan.suse.de>
References: <m1oct739xu.fsf@fess.ebiederm.org> <20090606080334.GA15204@ZenIV.linux.org.uk> <E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu> <20090608162913.GL8633@ZenIV.linux.org.uk> <E1MDhxh-0004nz-Qm@pomaz-ex.szeredi.hu> <20090608175018.GM8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906081100000.6847@localhost.localdomain> <20090608185041.GN8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906081217340.6847@localhost.localdomain> <m1ocsxykk2.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ocsxykk2.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 11:42:53PM -0700, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Mon, 8 Jun 2009, Al Viro wrote:
> >> 
> >> Sure, even though I'm not at all certain that copy_from_user() is that easy.
> >> We can make locking current->mm in there interruptible, all right, but that's
> >> only a part of the answer - even aside of the allocations, we'd need vma
> >> ->fault() interruptible as well, which leads to interruptible instances of
> >> ->readpage(), with all the fun _that_ would be.
> >
> > We already have all that - the NFS people wanted it.
> >
> > More importantly, you don't actually need to interrupt readpage itself - 
> > you just need to stop _waiting_ on it. So in your fault handler, just stop 
> > waiting, and instead just return FAULT_RETRY or whatever.
> 
> That sounds doable.  Has that code been merged yet?
> 
> I took a quick look and it didn't see anyone breaking out of page fault with a
> signal or code to really handle that.

The problem is get_user_pages I think. Now that we have a good number of
fault flags, we can pass down whether the caller is able to be
interrupted or not.

Ben H had some interest in doing this, but I don't know how far he got
with it.

