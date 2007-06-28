Return-Path: <linux-kernel-owner+w=401wt.eu-S1764759AbXF1MsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764759AbXF1MsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 08:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761173AbXF1MsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 08:48:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760761AbXF1MsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 08:48:00 -0400
Subject: Re: [PATCH 1/7] ICH Force HPET: Make generic time capable of
	switching broadcast timer
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070628012749.caf450f6.akpm@linux-foundation.org>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
	 <20070628001221.364438ce.akpm@linux-foundation.org>
	 <20070628012749.caf450f6.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 08:45:48 -0400
Message-Id: <1183034748.3504.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 01:27 -0700, Andrew Morton wrote:
> On Thu, 28 Jun 2007 00:12:21 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I can't start the X server any more, but that's probably unrelated ;)
> > 
> > <goes back to yet another bisection search.  sigh.  you guys have
> > me hopelessly outnumbered>
> 
> And the winner of the u-o-akpm-1-hour-of-his-life-back award (and the bonus
> u-delayed-next-mm-by-a-day award!) is ....  git-selinux.patch!
> 
> (II) Loading /usr/lib/xorg/modules/libvgahw.so
> (II) Module vgahw: vendor="X.Org Foundation"
>         compiled for 7.0.0, module version = 0.1.0
>         ABI class: X.Org Video Driver, version 0.8
> (**) I810(0): Depth 24, (--) framebuffer bpp 32
> (==) I810(0): RGB weight 888
> (==) I810(0): Default visual is TrueColor
> (II) Loading sub module "int10"
> (II) LoadModule: "int10"
> (II) Reloading /usr/lib/xorg/modules/libint10.so
> (II) I810(0): initializing int10
> (EE) I810(0): Cannot shmat() low memory
> (EE) I810(0): shmat(low_mem) error: Invalid argument
> (EE) I810(0): VBE initialization failed.

It has been found and the policy people already know about it.  I'm not
sure what the upstream status of the fixed policy is should appear soon.
(I also talked with the X people and apparently this is unfixable on
i686.  ajax posted about this on the original thread)

There is another bug however which I have a patch but haven't tested
much, I'll try to get it out today.  If you use a hint > 0 but <
mmap_min_addr without map fixed you will likely be denied.  Simple fix,
change hints up to mmap_min_addr if they are too low.

-Eric

