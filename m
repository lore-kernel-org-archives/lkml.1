Return-Path: <linux-kernel-owner+w=401wt.eu-S965296AbXBLSc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965296AbXBLSc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965294AbXBLScz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:32:55 -0500
Received: from mail.fieldses.org ([66.93.2.214]:51391 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965296AbXBLScy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:32:54 -0500
Date: Mon, 12 Feb 2007 13:32:34 -0500
To: Christoph Hellwig <hch@infradead.org>, Neil Brown <neilb@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Message-ID: <20070212183234.GA7589@fieldses.org>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <1170701906.5934.41.camel@lade.trondhjem.org> <20070205190230.GA23104@infradead.org> <200702051920.36057.agruen@suse.de> <20070206094709.GB5328@infradead.org> <17864.22470.113271.293084@notabene.brown> <20070206103737.GA14454@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206103737.GA14454@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 10:37:37AM +0000, Christoph Hellwig wrote:
> On Tue, Feb 06, 2007 at 09:26:14PM +1100, Neil Brown wrote:
> > What would be the benefit of having private non-visible vfsmounts?
> > Sounds like a recipe for confusion?
> > 
> > It is possible that mountd might start doing bind-mounts to create the
> > 'pseudo filesystem' thing for NFSv4, but they would be very visible
> > (under /var/lib/nfs/v4root or something).
> > So having it's own vfsmount might make sense, but I don't get
> > 'non-visible'.

> It would allow creating an exported tree without interferance with
> the local visible tree.  Note that the local visible tree isn't
> global anymore either, and this allows to adjust what's exported
> through nfsd throug a specific interface instead of needing to
> get into nfsd namespace through some way.

What would this interface look like?  Would it be a user<->kernel
interface, or a user<->mountd interface?

Tentatively what I was thinking of was having mountd fork off its own
namespace, use /etc/exports to construct a mount tree there, then pass
that mount tree down to the kernel using the existing exports cache
channel.  Name resolution in svc_export_parse should be done in mountd's
namespace, so I think this works.

> Think of listing the actually exported devices in /etc/exports instead
> of the indirection through fstab aswell.

Hm.  We'd have to add mount options to /etc/exports too if we were going
to do that, right?

--b.
