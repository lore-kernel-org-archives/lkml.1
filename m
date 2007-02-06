Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712AbXBFKhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbXBFKhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 05:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbXBFKhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 05:37:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50776 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbXBFKhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 05:37:38 -0500
Date: Tue, 6 Feb 2007 10:37:37 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Message-ID: <20070206103737.GA14454@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Neil Brown <neilb@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
	linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <1170701906.5934.41.camel@lade.trondhjem.org> <20070205190230.GA23104@infradead.org> <200702051920.36057.agruen@suse.de> <20070206094709.GB5328@infradead.org> <17864.22470.113271.293084@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17864.22470.113271.293084@notabene.brown>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 09:26:14PM +1100, Neil Brown wrote:
> What would be the benefit of having private non-visible vfsmounts?
> Sounds like a recipe for confusion?
> 
> It is possible that mountd might start doing bind-mounts to create the
> 'pseudo filesystem' thing for NFSv4, but they would be very visible
> (under /var/lib/nfs/v4root or something).  So having it's own vfsmount
> might make sense, but I don't get 'non-visible'.

It would allow creating an exported tree without interferance with
the local visible tree.  Note that the local visible tree isn't
global anymore either, and this allows to adjust what's exported
through nfsd throug a specific interface instead of needing to
get into nfsd namespace through some way.  Think of listing the
actually exported devices in /etc/exports instead of the indirection
through fstab aswell.
