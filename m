Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYHNRt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYHNRt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbYHNRtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:49:06 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:34652 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYHNRtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:49:05 -0400
Date: Thu, 14 Aug 2008 18:42:33 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ian Campbell <ijc@hellion.org.uk>
cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Kel Modderman <kel@otaku42.de>, Markus Armbruster <armbru@redhat.com>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
In-Reply-To: <1218725794.29410.17.camel@zakaz.uk.xensource.com>
Message-ID: <Pine.LNX.4.64.0808141831370.9951@blonde.site>
References: <1218697362.26014.9.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0808141347480.11013@blonde.site> <1218725794.29410.17.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Ian Campbell wrote:
> On Thu, 2008-08-14 at 14:06 +0100, Hugh Dickins wrote:
> > On Thu, 14 Aug 2008, Ian Campbell wrote:
> > > Jeremy first noticed this
> > > http://marc.info/?l=linux-kernel&m=121783008503477&w=2
> > > 
> > > I've bisected it down to:
> > > commit 14fcc23fdc78e9d32372553ccf21758a9bd56fa1
> > > Author: Hugh Dickins <hugh@veritas.com>
> > > Date:   Mon Jul 28 15:46:19 2008 -0700
> > > 
> > >     tmpfs: fix kernel BUG in shmem_delete_inode
> 
> > In both cases it's handling a page fault: I'm curious as to what kind
> > of vma this fault is occurring on.  Could you devise a way of getting
> > us /proc/<pid>/maps output, together with the faulting address, when
> > it hits one of these BUGs?  Or should I try to put together a patch
> > for that?
> 
> I'll have a go but I'm just about to go away for a long weekend so it
> might be next week unless I get to it tonight. Any pointers on how to go
> about it would be appreciated though...

No, have a good break and come back to it next week.  Whatever I suggest
in a rush will at first give you more oopses than you started out with,
back and forth, then it'll give us some info but not enough, back and
forth... no.  I'd rather spend the time trying to work out a hypothesis
from my end: it's always easier to devise an info patch once you have
a hypothesis to test, right now it makes no sense to me at all.

My starting point will be, prior to my tmpfs patch the faulting page
had a .set_page_dirty that kept it out of trouble, with that change
of ops now it hasn't; but what kind of page it actually is, a shmem
page (because the ops change affected it) that isn't a shmem page
(because it doesn't have the ops), I don't grasp yet.

Hugh
