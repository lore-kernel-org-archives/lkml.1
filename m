Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbXBFK1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbXBFK1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 05:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXBFK1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 05:27:09 -0500
Received: from ns2.suse.de ([195.135.220.15]:33495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbXBFK1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 05:27:07 -0500
From: Neil Brown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Date: Tue, 6 Feb 2007 21:26:14 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17864.22470.113271.293084@notabene.brown>
Cc: Andreas Gruenbacher <agruen@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
In-Reply-To: message from Christoph Hellwig on Tuesday February 6
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
	<1170701906.5934.41.camel@lade.trondhjem.org>
	<20070205190230.GA23104@infradead.org>
	<200702051920.36057.agruen@suse.de>
	<20070206094709.GB5328@infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday February 6, hch@infradead.org wrote:
> On Mon, Feb 05, 2007 at 07:20:35PM -0800, Andreas Gruenbacher wrote:
> > It's actually not hard to "fix", and nfsd would look a little less weird. But 
> > what would this add, what do pathnames mean in the context of nfsd, and would 
> > nfsd actually become less weird?
> 
> It's not actually a pathname we care about, but a vfsmount + dentry
> combo.  That one means as much in nfsd as elsewhere.  We want nfsd
> to obey r/o or noatime mount flags if /export/foo is exported with them
> but /foo not.  Even better would be to change nfsd so it creates it's
> own non-visible vfsmount for the filesystems it exports..

What would be the benefit of having private non-visible vfsmounts?
Sounds like a recipe for confusion?

It is possible that mountd might start doing bind-mounts to create the
'pseudo filesystem' thing for NFSv4, but they would be very visible
(under /var/lib/nfs/v4root or something).  So having it's own vfsmount
might make sense, but I don't get 'non-visible'.

NeilBrown
