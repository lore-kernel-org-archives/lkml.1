Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZAFXEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZAFXEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZAFXEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:04:39 -0500
Received: from verein.lst.de ([213.95.11.210]:58580 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbZAFXEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:04:38 -0500
Date: Wed, 7 Jan 2009 00:03:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Eric Sesterhenn <snakebyte@gmx.de>, hch@lst.de
Subject: Re: nfsd stuckage
Message-ID: <20090106230356.GA31520@lst.de>
References: <20090106145612.d4d9948d.akpm@linux-foundation.org> <20090106230244.GB13785@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106230244.GB13785@fieldses.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 06:02:44PM -0500, J. Bruce Fields wrote:
> On Tue, Jan 06, 2009 at 02:56:12PM -0800, Andrew Morton wrote:
> > 
> > I just built current mainline plus the just-sent 266 -mm patches.
> > 
> > The machine failed to power off when hit with `halt -pfn'.  dmesg output:
> 
> Christoph, can you live with this for now?

nfsd part is well, livable.  But the fs/sync.c is buggy as stackable
filesystems can call vfs_fsync with a NULL pointer due to nfs calling it
that way, so please drop that hunk.
