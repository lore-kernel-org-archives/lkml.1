Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbXHBK0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbXHBK0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbXHBK0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:26:33 -0400
Received: from ns1.suse.de ([195.135.220.2]:52749 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbXHBK0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:26:32 -0400
Date: Thu, 2 Aug 2007 12:26:31 +0200
From: Jan Blunck <jblunck@suse.de>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070802102631.GW5101@hasse.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu> <20070731170012.GN5101@hasse.suse.de> <20070731171159.GA27234@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731171159.GA27234@filer.fsl.cs.sunysb.edu>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, Josef Sipek wrote:

> > So you think that just because you mounted the filesystem somewhere else it
> > should look different? This is what sharing is all about. If you share a
> > filesystem you also share the removal of objects.
> 
> The removal happens at the union level, not the branch level. Say you have:
> 
> /a/
> /b/foo
> /c/foo
> 
> And you mount /u1 as a union of {a,b}, and /u2 as union of {a,c}.
> 
> $ find /u*
> /u1
> /u1/foo
> /u2
> /u2/foo
> $ rm /u1/foo # this creates whiteout for "foo" in /a
> $ find /u*
> /u1
> /u2
> 
> Is that what you'd expect as a user? I don't think so.
> 

Yes, although that might sound strange: you are sharing the topmost writable
layer. This is what I expect.

> > > store. We did an experiment with Unionfs, and moving the whiteout handling
> > > to effectively a "library" that did all the dirty work cleaned up the code
> > > considerably [2,3].
> > 
> > Haven't checked if you could use ODF for a generic store for filesystems that
> > couldn't support whiteouts. This might be an interesting idea.
>  
> Yes, since the ODF is completely separate, you can use _any_ filesystem and
> regardless of whether or not they support whiteouts.

Completely separate? It is totally tied to UnionFS and tries to work out
purely the problems that this kind of VFS emulating filesystems have.
