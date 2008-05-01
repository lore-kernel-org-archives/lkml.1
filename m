Return-Path: <linux-kernel-owner+w=401wt.eu-S932575AbYEAVmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbYEAVmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761084AbYEAVm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:42:28 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53405 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbYEAVm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:42:27 -0400
Date: Fri, 2 May 2008 00:41:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       lucho@ionkov.net, ericvh@gmail.com
Subject: Re: [PATCH] fix flags length in net 9p
Message-ID: <20080501214138.GT29330@cs181133002.pp.htv.fi>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com> <20080501141919.78b7dc4f.akpm@linux-foundation.org> <1209677160.12461.267.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1209677160.12461.267.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 02:26:00PM -0700, Daniel Walker wrote:
> 
> On Thu, 2008-05-01 at 14:19 -0700, Andrew Morton wrote:
> > On Thu, 1 May 2008 17:08:05 -0400 (EDT)
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Some files in the net/9p directory uses "int" for flags. This can
> > > cause hard to find bugs on some architectures. This patch converts the
> > > flags to use "long" instead.
> > 
> > gargh.
> > 
> > > This bug was discovered by doing an allyesconfig make on the -rt kernel
> > > where checks are done to ensure all flags are of size sizeof(long).
> > 
> > I was about to suggest that we do something like that...
> > 
> > I wonder how messy it is.  I long ago lost the ability to follow the
> > convolutions in include/linux/spinlock*.h :(  gotta patch?
> 
> The check that's in -rt for this uses BUILD_BUG_ON(), and it's extremely
> cryptic when there is a failure .. Most people will be baffled why the
> build stopped. If a check went into mainline it should at least give you
> some sort of idea what's happening ..

A cryptic compile error is _much_ better than a hard to find runtime 
error.

> Daniel

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

