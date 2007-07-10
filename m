Return-Path: <linux-kernel-owner+w=401wt.eu-S1763769AbXGJTBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763769AbXGJTBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbXGJTB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:01:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837AbXGJTB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:01:26 -0400
Date: Tue, 10 Jul 2007 15:00:09 -0400
From: Neil Horman <nhorman@redhat.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: Neil Horman <nhorman@redhat.com>, Vivek Goyal <vgoyal@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710190009.GB11130@hmsendeavour.rdu.redhat.com>
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070709092154.GA19705@suse.de> <20070709114131.GA18750@localdomain> <20070710150037.GB10216@in.ibm.com> <20070710171740.GA11130@hmsendeavour.rdu.redhat.com> <20070710173541.GA21743@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710173541.GA21743@localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 08:35:41PM +0300, Dan Aloni wrote:
> On Tue, Jul 10, 2007 at 01:17:40PM -0400, Neil Horman wrote:
> > On Tue, Jul 10, 2007 at 08:30:37PM +0530, Vivek Goyal wrote:
> > > I am still thinking that why can't we change initrd building process
> > > (Be it mkinitrd or mkdumprd depending on distriution). Whole idea is
> > > that while building an initrd/initramfs for the first kernel, one will
> > > ask user for kdump kernel (if user wishes to load kdump kenrel through
> > > initrd) and then it will generate kdump kenrel's initrd and pack into
> > > first kernel's initrd.
> > > 
> > > So steps would look something like this.
> > > 
> > > - mkinitrd takes second kernel's vmlinux as argument
> > > - mkinitrd runs "makedumpfile -g" on debug version of first kernel's vmlinux.
> > > - mkinitrd generates the initramfs for kdump kernel and packs output
> > >   of "makedumpfile -g" into that.
> > > - mkinitrd packs statically linked kexec, kdump kernel vmlinux/bzImage,
> > >   and kdump kernel initramfs into first kernel's initramfs.
> > > 
> > Agreed, this is exactly what happens right now.
> 
> Isn't there some sort of a circular dependency going on here? As I 
> understand it the vmlinux binary already contains the initramfs as 
> built-in data (at least that's what I use here for initramfs). It 
You're misunderstood.  The vmlinux binary and the initramfs are stored in the
same protected memory area when you execute a kexec -l, but they are separate
and distinct files.

> makes more sense if you guys are creating an _initrd_ image (that's 
> what mkinitrd originally did AFAIK) and supply it to the boot-loader.
initrd is old, initramfs is the new way to go, but they effecitvley do the same
thing, and while the initramfs _can_ be built into the kernel, it can also be
separately managed (which is what most distros tend to do, AFAICS).
Neil

> 
> -- 
> Dan Aloni
> XIV LTD, http://www.xivstorage.com
> da-x (at) monatomic.org, dan (at) xiv.co.il

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
