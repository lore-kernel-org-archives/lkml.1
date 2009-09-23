Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZIWIs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZIWIs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZIWIsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:48:25 -0400
Received: from mail2.shareable.org ([80.68.89.115]:57931 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbZIWIsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:48:24 -0400
Date: Wed, 23 Sep 2009 09:48:16 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] vfs: new FROM_ACCESS flag
Message-ID: <20090923084816.GA7687@shareable.org>
References: <20090921013048.2763.1494.stgit@paris.rdu.redhat.com> <20090922135612.GA17769@infradead.org> <1253640526.2747.7.camel@dhcp231-106.rdu.redhat.com> <20090922200635.GB28826@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922200635.GB28826@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Sep 22, 2009 at 01:28:46PM -0400, Eric Paris wrote:
> > > only using MAY_ACCESS for calles from access() insteaf of introducing
> > > a FROM_ACCESS flag and causing lots of naming confusion.
> > 
> > What would you think of a new, MUST_REVALIDATE_PERMS which will do what
> > MAY_ACCESS does today.  MAY_ACCESS would be just for access(2) and would
> > be the flag that I use for SELinux?
> 
> Yeah, something like this.  I don't like the MUST_REVALIDATE_PERMS name
> too much, but unless someone comes up with a better one I can live with
> it.

MAY_ACCESS is used in only these places:

    - access/faccessat
    - chdir/fchdir
    - chroot

And it is checked in only two easy to change places: nfs/dir.c and
fuse/dir.c.

Therefore how about MAY_CHDIR.

-- Jamie
