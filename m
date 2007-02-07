Return-Path: <linux-kernel-owner+w=401wt.eu-S1161114AbXBGJ6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161114AbXBGJ6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161107AbXBGJ6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:58:35 -0500
Received: from ns2.suse.de ([195.135.220.15]:41832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161070AbXBGJ6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:58:34 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Date: Wed, 7 Feb 2007 01:58:15 -0800
User-Agent: KMail/1.9.5
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <200702051920.36057.agruen@suse.de> <20070206094709.GB5328@infradead.org>
In-Reply-To: <20070206094709.GB5328@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702070158.15997.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 February 2007 01:47, Christoph Hellwig wrote:
> On Mon, Feb 05, 2007 at 07:20:35PM -0800, Andreas Gruenbacher wrote:
> > It's actually not hard to "fix", and nfsd would look a little less weird.
> > But what would this add, what do pathnames mean in the context of nfsd,
> > and would nfsd actually become less weird?
>
> It's not actually a pathname we care about, but a vfsmount + dentry
> combo.  That one means as much in nfsd as elsewhere.  We want nfsd
> to obey r/o or noatime mount flags if /export/foo is exported with them
> but /foo not.

This assumes that you can discover from the file handle which export it 
belongs to. And right, this can be done using the fsid export option. Okay, 
I'm now convinced that passing the vfsmounts from the svc_export to the vfs_ 
helpers is good at least for *something*. I'll update the patches.

> > But there is no way to tell different hardlinks to the same inode in the
> > same directory from each other (both the file and directory inode are the
> > same), and depending on the export options, we may or may not be able to
> > distinguish different hardlinks across directories.
>
> This doesn't matter.  hardlinks are per definition on the same vfsmount.

Hardlinks are per definition on the same filesystem. This doesn't mean that 
you can't have two filehandles for the same file but with different 
vfsmounts -- you can have the same file visible in multiple locations, each 
with their own vfsmount.

Thanks,
Andreas
