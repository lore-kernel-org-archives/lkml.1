Return-Path: <linux-kernel-owner+w=401wt.eu-S1763927AbXHALqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763927AbXHALqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 07:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760280AbXHALqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 07:46:39 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:41484 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900AbXHALqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 07:46:38 -0400
Date: Wed, 1 Aug 2007 07:43:20 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070801114320.GA13223@filer.fsl.cs.sunysb.edu>
References: <20070730161323.100048969@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu> <20070731170012.GN5101@hasse.suse.de> <200708011200.44093.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708011200.44093.hpj@urpla.net>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 12:00:42PM +0200, Hans-Peter Jansen wrote:
> Am Dienstag, 31. Juli 2007 19:00 schrieb Jan Blunck:
> > On Tue, Jul 31, Josef Sipek wrote:
> > > On Mon, Jul 30, 2007 at 06:13:35PM +0200, Jan Blunck wrote:
> > > > Introduce white-out support to ext2.
> > >
> > > I think storing whiteouts on the branches is wrong. It creates all sort
> > > of nasty cases when people actually try to use unioning. Imagine a
> > > (no-so unlikely) scenario where you have 2 unions, and they share a
> > > branch. If you create a whiteout in one union on that shared branch,
> > > the whiteout magically affects the other union as well! Whiteouts are a
> > > union-level construct, and therefore storing them at the branch level
> > > is wrong.
> >
> > So you think that just because you mounted the filesystem somewhere else
> > it should look different? This is what sharing is all about. If you share
> > a filesystem you also share the removal of objects.
> 
> No. At least I don't. 
> 
> Usage case: I heavily depend on using union mounts in diskless nfs setups, 
> since it drops the amount of administration of many systems _near_ one. It 
> boils down on installing the distribution of your choice in a directory, 
> union mount it ro, overlayed with a node private one (doing this in initrd 
> on the client for several reasons),

You're not sharing the rw layer so it's a different scenario, and will not
have the problem I'm talking about. See my other post [1] for exact scenario
where storing whiteouts on a branch would cause problems.

> add a little boot and automatic setup 
> machinery and be done. Since all changes are persistant, any system can be 
> set up individually, and still mostly only one tree is needed to keep up to 
> date.. Being in production in an office environment since two years without 
> major hassle (*).

Unionfs is used by many people in this way.

Josef 'Jeff' Sipek.

[1] http://lkml.org/lkml/2007/7/31/365

-- 
Intellectuals solve problems; geniuses prevent them
		- Albert Einstein
