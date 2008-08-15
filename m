Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYHOABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYHOABU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 20:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYHOABM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 20:01:12 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59801 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYHOABL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 20:01:11 -0400
Date: Fri, 15 Aug 2008 01:00:54 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Johannes Weiner <hannes@saeurebad.de>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ian Campbell <ijc@hellion.org.uk>,
       linux-kernel@vger.kernel.org, Kel Modderman <kel@otaku42.de>,
       Markus Armbruster <armbru@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
In-Reply-To: <871w0r5gw8.fsf@skyscraper.fehenstaub.lan>
Message-ID: <Pine.LNX.4.64.0808150049110.17216@blonde.site>
References: <1218697362.26014.9.camel@localhost.localdomain>
 <Pine.LNX.4.64.0808141347480.11013@blonde.site> <48A48879.2000309@goop.org>
 <Pine.LNX.4.64.0808142104080.29719@blonde.site> <48A4AC01.7040402@goop.org>
 <871w0r5gw8.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, Johannes Weiner wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> > Hugh Dickins wrote:
> >
> >> An additional useful input would be: what happens if you replace
> >> that /dev/fb0 by a symlink /dev/fb0 pointing to an fb0 device node in
> >> one of your disk filesystems?  I rather expect that to cause the same
> >> trouble, which would argue that the driver is wrong and shmem right.
> >
> > I don't follow. Do you mean make /dev/fb0 a plain file on a
> > filesystem?  Or make it a disk device node?  Something else?
> 
> Creating a device node on a different filesystem to see if the driver
> only worked with the safe shmem set_page_dirty and now breaks due to
> exposure to the generic version.  Or if the driver works with the
> generic version through other mappings and the shmem code screws it up
> somewhere else.

Yes, that's it.  I think it was ext2 I referred to, when I worried
about this when making the change to tmpfs; and my reading of it
was that ext2 left a device node's a_ops unset, as I was changing
tmpfs to do.  (Looking at it again, ext2 doesn't even specify its
.set_page_dirty, so even if it had assigned an a_ops, it wouldn't
have avoided the default behaviour.)  But I'd like to hear what
actually happens in practice, rather than relying on my reading.

Hugh
