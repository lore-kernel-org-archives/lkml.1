Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZE0UgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZE0UgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZE0Uf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:35:58 -0400
Received: from sous-sol.org ([216.99.217.87]:44555 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750928AbZE0Uf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:35:57 -0400
Date: Wed, 27 May 2009 13:35:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Gregory Haskins <ghaskins@novell.com>,
       avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix coalesced_mmio leak on shutdown
Message-ID: <20090527203540.GJ20823@sequoia.sous-sol.org>
References: <20090527164059.23966.75880.stgit@dev.haskins.net> <20090527202932.GI20823@sequoia.sous-sol.org> <4A1DA361.6050303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1DA361.6050303@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (gregory.haskins@gmail.com) wrote:
> Chris Wright wrote:
> > * Gregory Haskins (ghaskins@novell.com) wrote:
> >> It would appear that we are invoking kfree() on the wrong pointer in the
> >> destructor for the coalesced_mmio device.  This would result in a potential
> >> leak during shutdown.
> >
> > Happens to work and not leak:
> >
> > struct kvm_coalesced_mmio_dev { 
> >         struct kvm_io_device dev;
> >         struct kvm *kvm;
> >         int nb_zones;
> >         struct kvm_coalesced_mmio_zone zone[KVM_COALESCED_MMIO_ZONE_MAX];
> > };
> >
> >   
> Ah, yes.  That explains it.  Still sloppy, tho.

Definitely.

> >>  static void coalesced_mmio_destructor(struct kvm_io_device *this)
> >>  {
> >> -	kfree(this);
> >> +	struct kvm_coalesced_mmio_dev *dev =
> >> +		(struct kvm_coalesced_mmio_dev *)this->private;
> >>     
> >
> > I think container_of() makes more sense here.
> 
> I was working on that patch when I noticed the "leak" above.  Figured I
> should send the fix out first, in case my container_of patch is shot down.
> 
> Just polishing it up now.  Will send out soon.

Sounds good.

thanks,
-chris
