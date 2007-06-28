Return-Path: <linux-kernel-owner+w=401wt.eu-S1765325AbXF1SDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765325AbXF1SDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760386AbXF1SDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:03:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760836AbXF1SDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:03:30 -0400
Date: Thu, 28 Jun 2007 11:02:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] ICH Force HPET: Make generic time capable of
 switching broadcast timer
Message-Id: <20070628110254.3957c927.akpm@linux-foundation.org>
In-Reply-To: <1183034748.3504.3.camel@localhost.localdomain>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
	<20070628001221.364438ce.akpm@linux-foundation.org>
	<20070628012749.caf450f6.akpm@linux-foundation.org>
	<1183034748.3504.3.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 08:45:48 -0400 Eric Paris <eparis@redhat.com> wrote:

> On Thu, 2007-06-28 at 01:27 -0700, Andrew Morton wrote:
> > On Thu, 28 Jun 2007 00:12:21 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > I can't start the X server any more, but that's probably unrelated ;)
> > > 
> > > <goes back to yet another bisection search.  sigh.  you guys have
> > > me hopelessly outnumbered>
> > 
> > And the winner of the u-o-akpm-1-hour-of-his-life-back award (and the bonus
> > u-delayed-next-mm-by-a-day award!) is ....  git-selinux.patch!
> > 
> > (II) Loading /usr/lib/xorg/modules/libvgahw.so
> > (II) Module vgahw: vendor="X.Org Foundation"
> >         compiled for 7.0.0, module version = 0.1.0
> >         ABI class: X.Org Video Driver, version 0.8
> > (**) I810(0): Depth 24, (--) framebuffer bpp 32
> > (==) I810(0): RGB weight 888
> > (==) I810(0): Default visual is TrueColor
> > (II) Loading sub module "int10"
> > (II) LoadModule: "int10"
> > (II) Reloading /usr/lib/xorg/modules/libint10.so
> > (II) I810(0): initializing int10
> > (EE) I810(0): Cannot shmat() low memory
> > (EE) I810(0): shmat(low_mem) error: Invalid argument
> > (EE) I810(0): VBE initialization failed.
> 
> It has been found and the policy people already know about it.

So I spent slightly over an hour hunting down an already-known-about bug.

>  I'm not
> sure what the upstream status of the fixed policy is should appear soon.

We cannot merge a kernel change which requires a userspace upgrade to get
the X server working again.

You can do it the other way: make the X server work by default (my patch)
then, in your upgraded userspace, set /proc/sys/kernel/mmap_min_addr to
65536.  

Repeat: I think you should have used /proc/sys/vm/ for that tunable.
