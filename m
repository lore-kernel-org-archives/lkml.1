Return-Path: <linux-kernel-owner+w=401wt.eu-S1763566AbXHAKBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763566AbXHAKBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbXHAKBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:01:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbXHAKBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:01:03 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC 12/26] ext2 white-out support
Date: Wed, 1 Aug 2007 12:00:42 +0200
User-Agent: KMail/1.9.5
Cc: Jan Blunck <jblunck@suse.de>, Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
       linux-fsdevel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
References: <20070730161323.100048969@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu> <20070731170012.GN5101@hasse.suse.de>
In-Reply-To: <20070731170012.GN5101@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708011200.44093.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX19JmMCNWV5r54mdekWJEr4AnvYtPIYkuR6P+T1
 yQCangv1OUX3czfX9zckglLR5TuRyMzIh5nZDPJLTaBm848N6b
 F3lPdlEZs+MRjBS2mefIg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 31. Juli 2007 19:00 schrieb Jan Blunck:
> On Tue, Jul 31, Josef Sipek wrote:
> > On Mon, Jul 30, 2007 at 06:13:35PM +0200, Jan Blunck wrote:
> > > Introduce white-out support to ext2.
> >
> > I think storing whiteouts on the branches is wrong. It creates all sort
> > of nasty cases when people actually try to use unioning. Imagine a
> > (no-so unlikely) scenario where you have 2 unions, and they share a
> > branch. If you create a whiteout in one union on that shared branch,
> > the whiteout magically affects the other union as well! Whiteouts are a
> > union-level construct, and therefore storing them at the branch level
> > is wrong.
>
> So you think that just because you mounted the filesystem somewhere else
> it should look different? This is what sharing is all about. If you share
> a filesystem you also share the removal of objects.

No. At least I don't. 

Usage case: I heavily depend on using union mounts in diskless nfs setups, 
since it drops the amount of administration of many systems _near_ one. It 
boils down on installing the distribution of your choice in a directory, 
union mount it ro, overlayed with a node private one (doing this in initrd 
on the client for several reasons), add a little boot and automatic setup 
machinery and be done. Since all changes are persistant, any system can be 
set up individually, and still mostly only one tree is needed to keep up to 
date.. Being in production in an office environment since two years without 
major hassle (*).

This setup is likely to be useful for virtualization needs, too, but side 
effects via the base directory from one node to another would render this 
setup void.

Cheers,
  Pete

*) The amount of administration work of any (necessary, unfortunately) 
VMware XP instance running on top of those diskless clients excels that of 
all diskless clients by an order of magnitude. 
