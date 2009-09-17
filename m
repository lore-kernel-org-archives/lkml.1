Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZIQMMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZIQMMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZIQMMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:12:33 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:34731 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZIQMMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:12:33 -0400
Date: Thu, 17 Sep 2009 14:12:32 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org, mingo@elte.hu,
       npiggin@suse.de, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917121232.GA5041@osiris.boeblingen.de.ibm.com>
References: <1253083059.5478.1.camel@penberg-laptop>
 <20090917100841.GF13002@csn.ul.ie>
 <1253183365.4975.20.camel@penberg-laptop>
 <20090917105707.GA7205@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917105707.GA7205@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 11:57:08AM +0100, Mel Gorman wrote:
> On Thu, Sep 17, 2009 at 01:29:24PM +0300, Pekka Enberg wrote:
> > On Wed, Sep 16, 2009 at 09:37:39AM +0300, Pekka Enberg wrote:
> > > > The SLQB allocator is known to be broken on certain PowerPC and S390
> > > > configurations. Disable the allocator in Kconfig for those architectures
> > > > until the issues are resolved. 
> > > 
> > > Can the issues be summarised?
> > 
> > It's a boot time crash during module load:
> > 
> > http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg33092.html
> > 
> > AFAICT, it's related to a memoryless node 0. Nick suggested it could be
> > a latent bug in the kernel that's triggered by SLQB.
> 
> The danger is that this isn't a PPC or s390 bug then as such, but a bug where
> there are either memoryless nodes or when node 0 is memoryless.  Hence, there
> is no guarantee that your Kconfig option will catch all instances where this
> bug triggers.  Granted, the configuration is most likely a PPC machine :)

Ok, I just wanted to debug this on s390. But... the bug seems to have
disappeared.
I pulled in

git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slqb/core

and tried defconfig (+SLQB) as well as allyesconfig (+SLQB). Both started and
didn't show the crash-before-console-is-active which went away when switching
to a different allocator.
So the s390 restriction seems to be resolved. Don't know why...
