Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbXBFJr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbXBFJr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXBFJr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:47:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40536 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbXBFJrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:47:25 -0500
Date: Tue, 6 Feb 2007 09:47:09 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Message-ID: <20070206094709.GB5328@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
	linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <1170701906.5934.41.camel@lade.trondhjem.org> <20070205190230.GA23104@infradead.org> <200702051920.36057.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702051920.36057.agruen@suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 07:20:35PM -0800, Andreas Gruenbacher wrote:
> It's actually not hard to "fix", and nfsd would look a little less weird. But 
> what would this add, what do pathnames mean in the context of nfsd, and would 
> nfsd actually become less weird?

It's not actually a pathname we care about, but a vfsmount + dentry
combo.  That one means as much in nfsd as elsewhere.  We want nfsd
to obey r/o or noatime mount flags if /export/foo is exported with them
but /foo not.  Even better would be to change nfsd so it creates it's
own non-visible vfsmount for the filesystems it exports..

> But there is no way to tell different hardlinks to the same inode in the same 
> directory from each other (both the file and directory inode are the same), 
> and depending on the export options, we may or may not be able to distinguish 
> different hardlinks across directories.

This doesn't matter.  hardlinks are per definition on the same vfsmount.

> If the nohide or crossmnt export options are used, we might run into similar 
> aliasing issues with mounts (I'm not sure about this).

no, we won't.

