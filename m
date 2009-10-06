Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbZJFGfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbZJFGfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbZJFGfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:35:36 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:55734
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbZJFGfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:35:36 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH 1/1] md: drivers/md/unroll.pl replaced with awk analog
Date: Tue, 6 Oct 2009 01:34:56 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; x86_64; ; )
Cc: "berk walker" <berk@panix.com>, "Vladimir Dronnikov" <dronnikov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
References: <4aca1863.0a1ad00a.33bf.1017@mx.google.com> <200910052344.46809.rob@landley.net> <f2dbd45db6d92b291359456c98cf1f35.squirrel@neil.brown.name>
In-Reply-To: <f2dbd45db6d92b291359456c98cf1f35.squirrel@neil.brown.name>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910060134.57457.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009 00:03:50 NeilBrown wrote:
> On Tue, October 6, 2009 3:44 pm, Rob Landley wrote:
> > On Monday 05 October 2009 18:57:14 berk walker wrote:
> >> Rob Landley wrote:
> >> > On Monday 05 October 2009 11:01:39 Vladimir Dronnikov wrote:
> >> >> From: Vladimir Dronnikov <dronnikov@gmail.com>
> >> >>
> >> >> drivers/md/unroll.pl replaced by awk script to drop build-time
> >> >> dependency on perl
> >> >>
> >> >> Signed-off-by: Vladimir Dronnikov <dronnikov@gmail.com>
> >> >
> >> > Acked-by: Rob Landley <rob@landley.net>
> >> >
> >> > We already discussed this on another mailing list, thread starts at:
> >> >
> >> > http://lists.impactlinux.com/pipermail/firmware-impactlinux.com/2009-O
> >> >cto ber/000328.html
> >> >
> >> > I've added this as patch #4 in the perl removal series I've submitted
> >> > during the last few merge windows.
> >> >
> >> > Thanks,
> >> >
> >> > Rob
> >>
> >> Why is perl being removed? [I know that I have missed a lot]
> >> berk-
> >
> > Before 2.6.25 the kernel build had never used perl,
>
> Uhhhmmmm.  md has used perl for creating some C files since
> RAID6 was added, which is before the dawn of git.
>
> So I don't think this statement is true.

I was wrong, my mistake.  (The kernel builds I was doing had never needed 
perl, but I wasn't building raid for any target systems.  The systems that had 
raid were generally big suckers using distro kernels.  Vladimir _is_ building 
with raid support, so he addressed the issue.)

My current perl removal patch series started when timeconst.pl came in, 
meaning you couldn't build any kernel without perl anymore because 
_everything_ uses time constants.  My current patch to remove that is 
something like the fifth version I've had to do to keep up with various changes 
to the kernel since then.  Most recently reposted here:

  http://lkml.indiana.edu/hypermail/linux/kernel/0909.2/01661.html

Before that, I noticed (and removed) perl from the User Mode Linux build in 
2005:

  http://lkml.indiana.edu/hypermail/linux/kernel/0503.1/0806.html

It's not _just_ perl, it's gratuitous build dependencies in general, which 
make a cross-compiler's life unpleasant.  For example, there was a window 
during which you needed curses development headers to run "make oldconfig" (and 
that leaked into uClibc's copy of kconfig when they synced with upstream), but 
it was pretty easy to patch out and Sam Ravnborg had already fixed it upstream 
before I got around to pushing that.

I hit this sort of thing and have to fix it locally, life is easier for me if 
it's fixed upstream so I don't have to maintain out-of-tree patches...

Thanks,

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
